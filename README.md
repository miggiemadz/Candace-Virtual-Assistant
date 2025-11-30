# Candace: AI Virtual Assistant

An AI-powered Virtual Assistant currently in development as part of a **Fall 2025 research project** at **Union College of Union County, NJ**.  
**Candace** is designed to assist college students in managing classes, assignments, and daily academic tasks through an accessible, web-based interface.

---

## 📘 Project Overview

Candace is a research-driven prototype that integrates **natural language processing** and **data management** to create an intelligent assistant for student productivity.  
The project aims to explore how **LLM-based tools** can improve student engagement and time management in higher education.

```
Candace Virtual Assistant/
├── APIs.env
├── app/
│   ├── __init__.py
│   ├── auth_utils.py
│   ├── crud.py
│   ├── data/
│   │   └── student_database_final.json
│   ├── db_utils.py
│   ├── main.py
│   ├── models/
│   │   └── README.md
│   ├── routes.py
│   ├── services/
│   │   ├── __init__.py
│   │   ├── assistant/
│   │   │   ├── __init__.py
│   │   │   ├── llama_utils.py
│   │   │   └── prompt_utils.py
│   │   └── rag_utils.py
│   ├── static/
│   │   ├── css/ (chatbot.css, style.css)
│   │   ├── images/ (ucnj‑logo.png)
│   │   └── js/ (chatbot.js)
│   ├── templates/
│   │   ├── base.html, login-page.html, sign-up-page.html, dashboard.html, _course_nav.html
│   │   ├── admin/ (admin_dashboard.html, chat_logs.html, classes.html, courses.html, rag_tools.html, students.html, users.html)
│   │   └── student/
│   │       ├── account.html, calendar.html, courses.html, history.html, inbox.html
│   │       ├── course_shell.html and other course pages (analytics, assignments, cengage, files, grades, modules, pages, people, quizzes, syllabus)
│   ├── vectorstore/
│   │   └── store/ (candace.faiss, meta.json)
│   └── static/empty.py
├── config.py
├── database/
│   ├── candace.db
│   ├── schema.sql
│   ├── second_run.sql
│   ├── seeds/
│   │   ├── course-syllabus-fake-data.sql
│   │   ├── lecturers-fake-data.sql
│   │   ├── student-fake-data.sql
│   │   └── module_data/
│   │       └── *.sql  (fake module data for various courses: CST‑161, ENG‑101, MAT‑171, etc.)
│   └── testDatabase.py
├── docs/
│   ├── catalog/
│   │   ├── catalog_all_courses.txt
│   │   ├── current_term_courses.txt
│   │   └── future_term_courses.txt
│   ├── db_global/ (courses_global.txt, syllabi_global.txt)
│   ├── db_students/ (student_1000001.txt, … student_1000016.txt)
│   └── weekly/
│       └── [many course-specific “_weeks.txt” files for terms 2025FA, 2026SP, 2026WI, etc.]
├── export_db_rag_docs.py
├── ingest_rag.py
├── migrate_json_to_mysql.py
├── requirements.txt
├── run.py
├── seed_db.py
├── static/empty.py
├── tests/ (demo_account.py, inference_test.py)
└── README.md
```

---

## 👥 Research Team

- **Miguel Torres** — Project Manager, Back-End Developer & Designer  
- **Angello Bravo** — AI Developer & Front-End Developer  
- **Julio Padilla** — Database Engineer & Primary Researcher  
- **Professor Emilio Vasquez** — Research Mentor

---

## ⚙️ Tech Stack

| Area | Technologies |
|------|---------------|
| **Backend** | Flask (Python) |
| **Database** | SQLite |
| **AI/ML** | PyTorch, LLaMA 3 |
| **Front-End** | HTML / CSS / JS *(technologies to be finalized)* |
| **Version Control** | Git & GitHub |

---

## 🚀 Current Features

- Flask-based web application structure  
- SQLite database for user and task management  
- AI integration using **LLaMA 3** for natural language understanding  
- Early-stage web interface for student interaction  
- Modular codebase to support future front-end and API expansion

---

## 🧩 Planned Features

- Responsive, student-friendly front-end dashboard  
- AI conversation memory and contextual awareness  
- Calendar and assignment tracking  
- Secure user authentication  
- Expanded natural language interaction for academic assistance  

---

## 🧱 Project Structure

```
Candace-Virtual-Assistant/
├── app/                # Flask application files
│   ├── static/         # Front-end assets (CSS, JS, etc.)
│   ├── templates/      # HTML templates
│   ├── routes.py       # Flask routes
│   ├── models.py       # Database models
│   └── ai_engine/      # LLM logic (LLaMA 3, PyTorch)
├── database/           # SQLite schema and data
├── requirements.txt    # Python dependencies
├── README.md           # Project documentation
└── run.py              # Application entry point
```

*(Structure may evolve as development continues.)*

---

## 🧠 Research Focus

This project is conducted under the **Union College Undergraduate Research Initiative** to explore how AI can enhance academic performance and time management for college students.  
Our research emphasizes:
- Integrating large language models into lightweight, deployable web apps.  
- Evaluating the usability of conversational AI for educational support.  
- Building maintainable, modular back-end systems for LLM deployment.

---

## 🏗️ Status

**Status:** 🧩 *In Development*  
**Phase:** Research MVP Development (Fall 2025 Semester)  
**Goal:** Complete a functional prototype for demonstration and academic evaluation.

---

## 🧑‍💻 Setup Instructions

1. Clone the repository  
   ```bash
   git clone https://github.com/miggiemadz/Candace-Virtual-Assistant.git
   cd Candace-Virtual-Assistant
   ```

2. Install dependencies  
   ```bash
   pip install -r requirements.txt
   ```

3. Initialize the database  
   ```bash
   python run.py --init-db
   ```

4. Run the application  
   ```bash
   python run.py
   ```
   The server will start locally (default: `http://127.0.0.1:5000/`).

---

## 🧾 License

This project is licensed for academic and research use. Redistribution or commercial use requires permission from the authors.

---

## 📨 Contact

**Miguel Torres** — [LinkedIn](https://linkedin.com/in/miguel-torres-a46428227) | [GitHub](https://github.com/miggiemadz)  
Union College of Union County, NJ — Fall 2025 Research Program
