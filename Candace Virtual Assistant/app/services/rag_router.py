"""app/services/rag_router.py

This module implements a RAG router that decides whether a user prompt should be
answered with a specific tool from `crud.py` or fall back to a general vector
search in `rag_utils.py`.
"""

import re
from dataclasses import dataclass
from typing import Callable, Dict, List, Optional, Sequence

from .. import crud
from . import rag_utils

# --- Data Structures ---

@dataclass
class RouterResult:
    """Structured output that indicates what context should feed the LLM."""
    source: str
    context: str
    metadata: Dict[str, object]

@dataclass
class IntentRequest:
    """Parameters each handler receives so helpers stay testable."""
    user_message: str
    normalized_message: str
    student_id: Optional[int]

@dataclass
class IntentDefinition:
    """Declarative description of a structured intent and how to handle it."""
    name: str
    keywords: Sequence[str]
    handler: Callable[[IntentRequest, Dict[str, str]], Optional[RouterResult]]
    param_patterns: Optional[List[re.Pattern]] = None
    requires_student: bool = True

# --- Parameter Extraction ---

def _extract_params(text: str, patterns: List[re.Pattern]) -> Dict[str, str]:
    """Extracts named parameters from text using a list of regex patterns."""
    params = {}
    for pattern in patterns:
        match = pattern.search(text)
        if match:
            params.update(match.groupdict())
    return params

# --- Handlers (Tool Wrappers) ---

# Each handler now acts as a simple, clean bridge to a crud function.

def _handle_student_profile(req: IntentRequest, params: Dict) -> Optional[RouterResult]:
    context = crud.get_student_profile(req.student_id)
    return RouterResult(source="db_tool", context=context, metadata={"tool": "get_student_profile"})

def _handle_schedule(req: IntentRequest, params: Dict) -> Optional[RouterResult]:
    context = crud.get_student_schedule(req.student_id)
    return RouterResult(source="db_tool", context=context, metadata={"tool": "get_student_schedule"})

def _handle_upcoming_assignments(req: IntentRequest, params: Dict) -> Optional[RouterResult]:
    course_name = params.get("course_name")
    context = crud.get_upcoming_assignments(req.student_id, course_name=course_name)
    return RouterResult(source="db_tool", context=context, metadata={"tool": "get_upcoming_assignments", **params})

def _handle_recent_grades(req: IntentRequest, params: Dict) -> Optional[RouterResult]:
    context = crud.get_recent_grades(req.student_id)
    return RouterResult(source="db_tool", context=context, metadata={"tool": "get_recent_grades"})

def _handle_specific_grade(req: IntentRequest, params: Dict) -> Optional[RouterResult]:
    assignment_name = params.get("assignment_name")
    if not assignment_name: return None
    context = crud.get_assignment_grade(req.student_id, assignment_name=assignment_name)
    return RouterResult(source="db_tool", context=context, metadata={"tool": "get_assignment_grade", **params})

def _handle_list_modules(req: IntentRequest, params: Dict) -> Optional[RouterResult]:
    course_name = params.get("course_name")
    if not course_name: return None
    context = crud.list_course_modules(req.student_id, course_name=course_name)
    return RouterResult(source="db_tool", context=context, metadata={"tool": "list_course_modules", **params})

def _handle_course_syllabus(req: IntentRequest, params: Dict) -> Optional[RouterResult]:
    course_name = params.get("course_name")
    if not course_name: return None
    context = crud.get_course_syllabus_info(req.student_id, course_name=course_name)
    return RouterResult(source="db_tool", context=context, metadata={"tool": "get_course_syllabus_info", **params})

def _handle_recent_announcements(req: IntentRequest, params: Dict) -> Optional[RouterResult]:
    course_name = params.get("course_name") # Optional
    context = crud.get_recent_announcements(req.student_id, course_name=course_name)
    return RouterResult(source="db_tool", context=context, metadata={"tool": "get_recent_announcements", **params})

def _handle_class_professor(req: IntentRequest, params: Dict) -> Optional[RouterResult]:
    course_name = params.get("course_name")
    if not course_name: return None
    context = crud.get_class_professor(req.student_id, course_name=course_name)
    return RouterResult(source="db_tool", context=context, metadata={"tool": "get_class_professor", **params})

def _handle_list_files(req: IntentRequest, params: Dict) -> Optional[RouterResult]:
    course_name = params.get("course_name")
    if not course_name: return None
    context = crud.list_course_files(req.student_id, course_name=course_name)
    return RouterResult(source="db_tool", context=context, metadata={"tool": "list_course_files", **params})

def _handle_module_content(req: IntentRequest, params: Dict) -> Optional[RouterResult]:
    course_name = params.get("course_name")
    module_title = params.get("module_title")
    if not course_name or not module_title: return None
    context = crud.get_course_module_content(req.student_id, course_name=course_name, module_title=module_title)
    return RouterResult(source="db_tool", context=context, metadata={"tool": "get_course_module_content", **params})

# --- Router Implementation ---

class RAGRouter:
    def __init__(self, *, rag_top_k: Optional[int] = None):
        self.rag_top_k = rag_top_k or rag_utils.TOP_K
        
        # Define patterns for extracting course names and other entities.
        # This is a simple approach; more advanced would use NLP libraries.
        self._course_pattern = re.compile(r"(?P<course_name>[A-Z]{2,4}\s\d{2,3})", re.IGNORECASE)
        self._assignment_pattern = re.compile(r"(?:for|in|on)\s+'(?P<assignment_name>[^']+)'", re.IGNORECASE)
        self._assignment_pattern_alt = re.compile(r'(?:for|in|on)\s+"(?P<assignment_name>[^"]+)"', re.IGNORECASE)
        self._module_pattern = re.compile(r"module\s+'(?P<module_title>[^']+)'", re.IGNORECASE)
        self._module_pattern_alt = re.compile(r'module\s+"(?P<module_title>[^"]+)"', re.IGNORECASE)

        self._intents: Sequence[IntentDefinition] = (
            # Order matters: more specific intents should come first.
            IntentDefinition(
                name="get_module_content",
                keywords=("content of module", "in module", "what is in"),
                handler=_handle_module_content,
                param_patterns=[self._course_pattern, self._module_pattern, self._module_pattern_alt]
            ),
            IntentDefinition(
                name="get_specific_grade",
                keywords=("grade for", "score on", "what did i get on"),
                handler=_handle_specific_grade,
                param_patterns=[self._assignment_pattern, self._assignment_pattern_alt]
            ),
            IntentDefinition(
                name="get_course_syllabus",
                keywords=("syllabus", "grading policy", "outcomes for"),
                handler=_handle_course_syllabus,
                param_patterns=[self._course_pattern]
            ),
            IntentDefinition(
                name="get_class_professor",
                keywords=("professor of", "instructor for", "teacher of", "professors"),
                handler=_handle_class_professor,
                param_patterns=[self._course_pattern]
            ),
            IntentDefinition(
                name="list_course_files",
                keywords=("files for", "course files", "list the files"),
                handler=_handle_list_files,
                param_patterns=[self._course_pattern]
            ),
            IntentDefinition(
                name="list_modules",
                keywords=("modules for", "weeks for", "topics for", "modules"),
                handler=_handle_list_modules,
                param_patterns=[self._course_pattern]
            ),
            IntentDefinition(
                name="get_upcoming_assignments",
                keywords=("assignment", "homework", "due soon"),
                handler=_handle_upcoming_assignments,
                param_patterns=[self._course_pattern] # Can optionally filter by course
            ),
            IntentDefinition(
                name="get_recent_announcements",
                keywords=("announcements", "updates", "news for"),
                handler=_handle_recent_announcements,
                param_patterns=[self._course_pattern], # Optional course filter
                requires_student=True
            ),
            IntentDefinition(
                name="get_recent_grades",
                keywords=("grades", "scores", "recently graded"),
                handler=_handle_recent_grades,
            ),
            IntentDefinition(
                name="get_student_schedule",
                keywords=("schedule", "my classes", "what courses"),
                handler=_handle_schedule,
            ),
            IntentDefinition(
                name="get_student_profile",
                keywords=("gpa", "my major", "my profile", "who am i"),
                handler=_handle_student_profile,
            ),
        )

    def route(self, user_message: str, *, student_id: Optional[int] = None) -> RouterResult:
        """Detects intents, extracts params, and calls the correct tool or falls back to RAG."""
        normalized = user_message.lower()
        request = IntentRequest(
            user_message=user_message,
            normalized_message=normalized,
            student_id=student_id,
        )

        for intent in self._intents:
            if any(keyword in normalized for keyword in intent.keywords):
                if intent.requires_student and student_id is None:
                    continue # Skip student-only intents if no student is logged in

                params = {}
                if intent.param_patterns:
                    params = _extract_params(user_message, intent.param_patterns)
                
                result = intent.handler(request, params)
                if result:
                    print(f"[Router] Matched intent '{intent.name}' with params {params}")
                    return result
        
        print("[Router] No specific intent matched. Falling back to RAG.")
        return self._rag_fallback(user_message, student_id=student_id)

    def _rag_fallback(self, user_message: str, student_id: Optional[int] = None) -> RouterResult:
        """Provides vector-store context when no structured intent matches."""
        if student_id is None:
            # Cannot perform secure RAG without a student_id
            return RouterResult(source="none", context="", metadata={"intent": "rag_fallback", "hits": []})

        hits = rag_utils.retrieve(user_message, student_id=student_id, k=self.rag_top_k)
        context = rag_utils.format_context(hits)
        return RouterResult(
            source="rag" if context else "none",
            context=context,
            metadata={"intent": "rag_fallback", "hits": hits},
        )

# --- Singleton Accessor ---

def route(user_message: str, *, student_id: Optional[int] = None) -> RouterResult:
    """Singleton-style helper for quick imports without managing state by hand."""
    if not hasattr(route, "_instance"):
        route._instance = RAGRouter()
    return route._instance.route(user_message, student_id=student_id)
