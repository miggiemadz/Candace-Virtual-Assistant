"""app/services/rag_router.py

This module implements a lightweight RAG router that decides whether a user
prompt should be answered with structured data from ``candace.db`` or whether
we should fall back to semantic retrieval + generation. 
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Callable, Dict, List, Optional, Sequence

from .. import crud
from . import rag_utils


@dataclass
class RouterResult:
    """Structured output that indicates what context should feed the LLM."""

    source: str
    context: str
    metadata: Dict[str, object]


@dataclass
class IntentDefinition:
    """Declarative description of a structured intent."""

    name: str
    keywords: Sequence[str]
    handler: Callable[["IntentRequest"], Optional[RouterResult]]
    requires_student: bool = True


@dataclass
class IntentRequest:
    """Parameters each handler receives so helpers stay testable."""

    user_message: str
    normalized_message: str
    student_id: Optional[int]


def _rows_to_dicts(raw_rows: object) -> List[Dict[str, object]]:
    """Converts sqlite rows (or False/None) to a list of dicts for ease of use."""

    if not raw_rows or raw_rows is False:
        return []
    return [dict(row) for row in raw_rows]


def _first(raw_rows: object) -> Optional[Dict[str, object]]:
    """Returns the first row as dict or None when the result set is empty."""

    rows = _rows_to_dicts(raw_rows)
    return rows[0] if rows else None


def _handle_student_profile(req: IntentRequest) -> Optional[RouterResult]:
    """Serves GPA/credits/major questions directly from STUDENT/MAJOR tables."""

    if req.student_id is None:
        return None
    student = _first(crud.get_student_by_id(req.student_id))
    if not student:
        return None
    major = _first(crud.read_Majors(student.get("major_id"))) if student.get("major_id") else None
    major_line = (
        f"They are majoring in {major['major_name']} under the {major['department']} department."
        if major else
        "Major information is not available in the record."
    )
    context = (
        f"Student {student['student_first_name']} {student['student_last_name']} has a GPA of "
        f"{student['student_gpa']} with {student['student_total_credits']} total credits. {major_line}"
    )
    return RouterResult(
        source="db",
        context=context,
        metadata={"intent": "student_profile", "student": student, "major": major},
    )


def _fetch_class_bundle(class_id: int) -> Optional[Dict[str, object]]:
    """Aggregates CLASS + COURSE + PROFESSOR information for richer answers."""

    class_row = _first(crud.read_class(class_id))
    if not class_row:
        return None
    course_row = _first(crud.read_courses(class_row.get("course_id"))) if class_row.get("course_id") else None
    prof_row = _first(crud.read_professors(class_row.get("professor_id"))) if class_row.get("professor_id") else None
    bundle = {
        "class": class_row,
        "course": course_row,
        "professor": prof_row,
    }
    return bundle


def _handle_schedule(req: IntentRequest) -> Optional[RouterResult]:
    """Summaries the student's schedule, enriched with course+professor context."""

    if req.student_id is None:
        return None
    schedule_rows = _rows_to_dicts(crud.read_schedule(req.student_id))
    if not schedule_rows:
        return None
    lines: List[str] = []
    enriched: List[Dict[str, object]] = []
    for idx, row in enumerate(schedule_rows, 1):
        bundle = _fetch_class_bundle(row.get("class_id"))
        enriched.append({"schedule": row, "bundle": bundle})
        if not bundle:
            lines.append(f"{idx}. Class ID {row.get('class_id')} is on the schedule, but no class metadata was found.")
            continue
        course = bundle.get("course")
        professor = bundle.get("professor")
        class_row = bundle.get("class")
        course_name = course.get("course_name") if course else "Unknown course"
        credits = course.get("course_credits") if course else "?"
        prof_name = (
            f"{professor['professor_first_name']} {professor['professor_last_name']}"
            if professor else "an unassigned professor"
        )
        lines.append(
            f"{idx}. {course_name} (Class ID {class_row['class_id']}, {credits} credits) is taught by {prof_name} "
            f"and is listed as a {class_row['class_type']} session."
        )
    context = "\n".join(lines)
    return RouterResult(
        source="db",
        context=context,
        metadata={"intent": "schedule", "entries": enriched},
    )


def _handle_work_load(req: IntentRequest) -> Optional[RouterResult]:
    """Provides the outstanding assignments recorded in WORK_LOAD/ASSIGNMENT."""

    if req.student_id is None:
        return None
    work_rows = _rows_to_dicts(crud.read_work_load(req.student_id))
    if not work_rows:
        return None
    lines: List[str] = []
    payload: List[Dict[str, object]] = []
    for idx, row in enumerate(work_rows, 1):
        assignment = _first(crud.read_assignments(row.get("assignment_id")))
        payload.append({"work": row, "assignment": assignment})
        if not assignment:
            lines.append(f"{idx}. Assignment ID {row.get('assignment_id')} is referenced but cannot be found.")
            continue
        lines.append(
            f"{idx}. {assignment['assignment_name']} ({assignment['assignment_type']}) weights "
            f"{assignment['assignment_score_weight']} and belongs to class {assignment['class_id']}."
        )
    context = "\n".join(lines)
    return RouterResult(
        source="db",
        context=context,
        metadata={"intent": "work_load", "entries": payload},
    )


def _handle_study_guides(req: IntentRequest) -> Optional[RouterResult]:
    """Answers study guide related prompts via the STUDY_GUIDE table."""

    if req.student_id is None:
        # Study guides are not tied to a student, so we allow None student IDs.
        guides = _rows_to_dicts(crud.read_study_guide())
    else:
        # When a student asks, highlight the classes they are already enrolled in.
        schedule = _rows_to_dicts(crud.read_schedule(req.student_id))
        class_ids = {row.get("class_id") for row in schedule if row.get("class_id")}
        guides = []
        for class_id in class_ids:
            guides.extend(_rows_to_dicts(crud.read_study_guide(class_id=class_id)))
    if not guides:
        return None
    lines = [
        f"Study guide {guide['study_guide_id']} is available for class {guide['class_id']}."
        for guide in guides
    ]
    context = "\n".join(lines)
    return RouterResult(
        source="db",
        context=context,
        metadata={"intent": "study_guides", "entries": guides},
    )


class RAGRouter:
    """Public interface; expose ``route`` so routes.py can call it before the LLM."""

    def __init__(self, *, rag_top_k: Optional[int] = None):
        self.rag_top_k = rag_top_k or rag_utils.TOP_K
        self._intents: Sequence[IntentDefinition] = (
            IntentDefinition(
                name="student_profile",
                keywords=("gpa", "credit", "profile", "major", "advisor", 'me', 'myself'),
                handler=_handle_student_profile,
            ),
            IntentDefinition(
                name="schedule",
                keywords=("schedule", "class", "timetable", "meeting", "course list", 'classes', 'courses', 'course'),
                handler=_handle_schedule,
            ),
            IntentDefinition(
                name="work_load",
                keywords=("assignment", "homework", "tasks", "work load", "workload", 'assignments', 'homework', 'tasks', 'work load', 'workload'),
                handler=_handle_work_load,
            ),
            IntentDefinition(
                name="study_guides",
                keywords=("study guide", "study material", "revision", 'study guides', 'study guide', 'study material', 'revision'),
                handler=_handle_study_guides,
                requires_student=False,
            ),
        )

    def route(self, user_message: str, *, student_id: Optional[int] = None) -> RouterResult:
        """Detects intents via keyword heuristics; falls back to RAG retrieval."""

        normalized = user_message.lower()
        request = IntentRequest(
            user_message=user_message,
            normalized_message=normalized,
            student_id=student_id,
        )
        for intent in self._intents:
            if any(keyword in normalized for keyword in intent.keywords):
                if intent.requires_student and student_id is None:
                    break
                result = intent.handler(request)
                if result:
                    return result
        return self._rag_fallback(user_message)

    def _rag_fallback(self, user_message: str) -> RouterResult:
        """Provides vector-store context when no structured intent matches."""

        hits = rag_utils.retrieve(user_message, k=self.rag_top_k)
        context = rag_utils.format_context(hits)
        return RouterResult(
            source="rag" if context else "none",
            context=context,
            metadata={"intent": "rag_fallback", "hits": hits},
        )


def route(user_message: str, *, student_id: Optional[int] = None) -> RouterResult:
    """Singleton-style helper for quick imports without managing state by hand."""

    if not hasattr(route, "_instance"):
        route._instance = RAGRouter()
    return route._instance.route(user_message, student_id=student_id)
