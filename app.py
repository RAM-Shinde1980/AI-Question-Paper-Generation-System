
import os
import mysql.connector
from flask import Flask, render_template, request, redirect, url_for, session, send_from_directory
from werkzeug.utils import secure_filename
from sentence_transformers import SentenceTransformer, util
from datetime import datetime
from flask import session



from flask import send_file
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet


def get_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="Ramji@1980",
        database="questionpaperdb"
    )

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

app = Flask(
    __name__,
    template_folder=os.path.join(BASE_DIR, "templates"),
    static_folder=os.path.join(BASE_DIR, "static")
)

app.secret_key = "my_super_secret_key_123"

UPLOAD_FOLDER = os.path.join(BASE_DIR, "uploads")
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

if not os.path.exists(app.config["UPLOAD_FOLDER"]):
    os.makedirs(app.config["UPLOAD_FOLDER"])

from sentence_transformers import SentenceTransformer, util
import re

semantic_model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
SIMILARITY_THRESHOLD = 0.50

def normalize_text(text):
    if not text:
        return ""

    text = text.lower().strip()

    replacements = {
        "dbms": "database management system",
        "rdbms": "relational database management system",
        "sql": "structured query language",
        "os": "operating system",
        "cpu": "central processing unit",
        "ram": "random access memory"
    }

    for short_form, full_form in replacements.items():
        text = re.sub(rf"\b{re.escape(short_form)}\b", full_form, text)
        text = text.replace("define", "what is")
        text = text.replace("mean by", "what is")
        text = text.replace("meant by", "what is")
        text = text.replace("explain", "what is")

    text = re.sub(r"[^a-z0-9\s]", " ", text)
    text = re.sub(r"\s+", " ", text).strip()

    return text

def semantic_similarity(text1, text2):
    if not text1 or not text2:
        return 0.0

    text1 = normalize_text(text1)
    text2 = normalize_text(text2)

    if not text1 or not text2:
        return 0.0

    emb1 = semantic_model.encode(text1, convert_to_tensor=True)
    emb2 = semantic_model.encode(text2, convert_to_tensor=True)

    score = util.cos_sim(emb1, emb2).item()
    return float(score)

def check_semantic_duplicate(new_question, new_answer, existing_questions, threshold=0.40):
    for old_q in existing_questions:
        old_question = old_q.get("question_text", "") or ""
        old_answer = old_q.get("answer_text", "") or ""

        q_score = semantic_similarity(new_question, old_question)
        a_score = semantic_similarity(new_answer, old_answer)

        print("--------------------------------------------------")
        print("NEW QUESTION:", new_question)
        print("OLD QUESTION:", old_question)
        print("Q similarity:", q_score)
        print("A similarity:", a_score)

        if q_score > threshold or a_score > threshold:
            return True, old_q, q_score, a_score

    return False, None, 0.0, 0.0

@app.route("/")
def home():
    return redirect(url_for("login"))

@app.route("/add_question", methods=["GET", "POST"])
def add_question():

    if "user_id" not in session or session["role"] != "faculty":
        return redirect(url_for("login"))

    faculty_id = session["user_id"]

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT s.subject_id, s.subject_name
        FROM faculty_subject fs
        JOIN subject s ON fs.subject_id = s.subject_id
        WHERE fs.faculty_id = %s
        ORDER BY s.subject_name
    """, (faculty_id,))

    assigned_subjects = cursor.fetchall()

    message = None

    if request.method == "POST":

        subject_id = request.form.get("subject_id")
        module_id = request.form.get("module_id")
        question_text = request.form.get("question_text")
        answer_text = request.form.get("answer_text")
        marks = request.form.get("marks")
        difficulty = request.form.get("difficulty")
        blooms_level = request.form.get("blooms_level")

        try:

            # Fetch existing questions
            check_cursor = conn.cursor(dictionary=True)

            check_cursor.execute("""
                SELECT question_text, answer_text
                FROM question
                WHERE subject_id = %s
            """, (subject_id,))

            existing_questions = check_cursor.fetchall()
            check_cursor.close()

            # Duplicate check
            is_duplicate = False

            for q in existing_questions:

                old_q = q["question_text"]
                old_a = q["answer_text"]

                q_score = semantic_similarity(question_text, old_q)
                a_score = semantic_similarity(answer_text, old_a)

                print("NEW:", question_text)
                print("OLD:", old_q)
                print("Q SCORE:", q_score)
                print("A SCORE:", a_score)

                if q_score > 0.65 and a_score > 0.70:

                    is_duplicate = True

                    message = (
                        f"Duplicate question detected! "
                        f"Q similarity: {q_score:.2f}, "
                        f"A similarity: {a_score:.2f}"
                    )

                    break

            if is_duplicate:

                cursor.close()
                conn.close()

                return render_template(
                    "add_question.html",
                    assigned_subjects=assigned_subjects,
                    message=message
                )

            # Insert question
            insert_cursor = conn.cursor()

            insert_cursor.execute("""
                INSERT INTO question
                (
                    user_id,
                    subject_id,
                    module_id,
                    question_text,
                    answer_text,
                    marks,
                    difficulty,
                    blooms_level,
                    approved,
                    hod_id,
                    reject_reason
                )
                VALUES
                (
                    %s,%s,%s,%s,%s,
                    %s,%s,%s,
                    'N', NULL, NULL
                )
            """, (
                faculty_id,
                subject_id,
                module_id,
                question_text,
                answer_text,
                marks,
                difficulty,
                blooms_level
            ))

            conn.commit()

            activity_cursor = conn.cursor()

            activity_cursor.execute("""
            INSERT INTO activity_log (activity_text)
            VALUES (%s)
              """, ("New question submitted by Faculty",))

            conn.commit()
            activity_cursor.close()
            insert_cursor.close()

            message = "Question added successfully."

        except Exception as e:

            message = f"Error while adding question: {e}"

    cursor.close()
    conn.close()

    return render_template(
        "add_question.html",
        assigned_subjects=assigned_subjects,
        message=message
    )


@app.route("/signup", methods=["GET", "POST"])
def signup():
    popup_user_id = None
    error_message = None

    if request.method == "POST":
        name = request.form.get("name")
        email = request.form.get("email")
        password = request.form.get("password")
        role = request.form.get("role")
        department = request.form.get("department")

        try:
            conn = get_db()
            cursor = conn.cursor(dictionary=True)

            # duplicate email check
            cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
            existing_email = cursor.fetchone()

            # duplicate same name + role + department check
            cursor.execute("""
                SELECT * FROM users
                WHERE name = %s AND role = %s AND department = %s
            """, (name, role, department))
            existing_user = cursor.fetchone()

            if existing_email:
                error_message = "This email already exists. Please use another email."
            elif existing_user:
                error_message = "Same user already exists with this role and department."
            else:
                insert_cursor = conn.cursor()
                insert_cursor.execute("""
                    INSERT INTO users (name, email, password, role, department)
                    VALUES (%s, %s, %s, %s, %s)
                """, (name, email, password, role, department))
                conn.commit()

                popup_user_id = insert_cursor.lastrowid
                insert_cursor.close()

            cursor.close()
            conn.close()

        except Exception as e:
            error_message = f"Signup error: {e}"

    return render_template(
        "signup.html",
        popup_user_id=popup_user_id,
        error_message=error_message
    )

@app.route("/login", methods=["GET", "POST"])
def login():
    error = None

    if request.method == "POST":
        user_id = request.form.get("user_id")
        password = request.form.get("password")

        conn = get_db()
        cursor = conn.cursor(dictionary=True)

        query = "SELECT * FROM users WHERE user_id=%s AND password=%s"
        cursor.execute(query, (user_id, password))
        user = cursor.fetchone()

        cursor.close()
        conn.close()

        if user:
            session["user_id"] = user["user_id"]
            session["name"] = user["name"]
            session["role"] = user["role"]
            session["department"] = user["department"]

            if user["role"] == "admin":
                return redirect(url_for("admin_dashboard"))
            elif user["role"] == "hod":
                return redirect(url_for("hod_dashboard"))
            elif user["role"] == "faculty":
                return redirect(url_for("faculty_dashboard"))
            else:
                return f"Role not matched: {user['role']}"
        else:
            error = "Invalid User ID or Password"

    return render_template("login.html", error=error)

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))

@app.route("/uploads/<filename>")
def uploaded_file(filename):
    return send_from_directory(app.config["UPLOAD_FOLDER"], filename)

@app.route("/forgot_password", methods=["GET", "POST"])
def forgot_password():

    message = None

    if request.method == "POST":

        email = request.form.get("email")
        new_password = request.form.get("new_password")

        conn = get_db()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("""
            SELECT user_id
            FROM users
            WHERE email = %s
        """, (email,))

        user = cursor.fetchone()

        if user:

            cursor.execute("""
                UPDATE users
                SET password = %s
                WHERE email = %s
            """, (new_password, email))

            conn.commit()

            message = f"""
            Password updated successfully.
            Your User ID is: {user['user_id']}
            """

        else:
            message = "Email not found."

        cursor.close()
        conn.close()

    return render_template(
        "forgot_password.html",
        message=message
    )




@app.route("/get_modules/<int:subject_id>")
def get_modules(subject_id):
    if "user_id" not in session:
        return []

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT module_id, module_name
        FROM module
        WHERE subject_id = %s
        ORDER BY module_name
    """, (subject_id,))
    modules = cursor.fetchall()

    cursor.close()
    conn.close()

    return modules

@app.route("/admin_dashboard")
def admin_dashboard():
    if "user_id" not in session or session["role"] != "admin":
        return redirect(url_for("login"))

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    # Total HODs
    cursor.execute("SELECT COUNT(*) AS total_hods FROM users WHERE role='hod'")
    total_hods = cursor.fetchone()["total_hods"]

    # Total Faculty
    cursor.execute("SELECT COUNT(*) AS total_faculty FROM users WHERE role='faculty'")
    total_faculty = cursor.fetchone()["total_faculty"]

    # Total Questions
    cursor.execute("SELECT COUNT(*) AS total_questions FROM question")
    total_questions = cursor.fetchone()["total_questions"]

    # Pending Questions
    cursor.execute("SELECT COUNT(*) AS pending_questions FROM question WHERE approved='N'")
    pending_questions = cursor.fetchone()["pending_questions"]

    # Recent Activities
    cursor.execute("""
        SELECT activity_text, activity_time
        FROM activity_log
        ORDER BY activity_time DESC
        LIMIT 5
    """)
    recent_activities = cursor.fetchall()

    # CLOSE AFTER ALL QUERIES
    cursor.close()
    conn.close()

    return render_template(
        "admin_dashboard.html",
        total_hods=total_hods,
        total_faculty=total_faculty,
        total_questions=total_questions,
        pending_questions=pending_questions,
        recent_activities=recent_activities
    )


@app.route("/question_generator", methods=["GET", "POST"])
def question_generator():

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT subject_id, subject_name FROM subject")
    subjects = cursor.fetchall()

    generated_questions = {
        "part_a": [],
        "part_b": [],
        "part_c": []
    }

    total_marks = 0

    if request.method == "POST":

        subject_id = request.form["subject_id"]
        total_marks = int(request.form["total_marks"])
        difficulty = request.form["difficulty"]

        used_ids = []
        current_total = 0

        # PART A (2 marks)
        while current_total < (total_marks * 0.30):

            query = """
                SELECT * FROM question
                WHERE subject_id=%s
                AND marks=2
                AND difficulty=%s
                AND approved='Y'
            """

            if used_ids:
                query += " AND question_id NOT IN ({})".format(
                    ",".join(["%s"] * len(used_ids))
                )

            query += " ORDER BY RAND() LIMIT 1"

            params = [subject_id, difficulty] + used_ids

            cursor.execute(query, params)
            q = cursor.fetchone()

            if not q:
                break

            generated_questions["part_a"].append(q)
            used_ids.append(q["question_id"])
            current_total += q["marks"]

        # PART B (3 marks)
        while current_total < (total_marks * 0.60):

            query = """
                SELECT * FROM question
                WHERE subject_id=%s
                AND marks=3
                AND difficulty=%s
                AND approved='Y'
            """

            if used_ids:
                query += " AND question_id NOT IN ({})".format(
                    ",".join(["%s"] * len(used_ids))
                )

            query += " ORDER BY RAND() LIMIT 1"

            params = [subject_id, difficulty] + used_ids

            cursor.execute(query, params)
            q = cursor.fetchone()

            if not q:
                break

            generated_questions["part_b"].append(q)
            used_ids.append(q["question_id"])
            current_total += q["marks"]

        # PART C (10 marks)
        while current_total < total_marks:

            query = """
                SELECT * FROM question
                WHERE subject_id=%s
                AND marks=10
                AND difficulty=%s
                AND approved='Y'
            """

            if used_ids:
                query += " AND question_id NOT IN ({})".format(
                    ",".join(["%s"] * len(used_ids))
                )

            query += " ORDER BY RAND() LIMIT 1"

            params = [subject_id, difficulty] + used_ids

            cursor.execute(query, params)
            q = cursor.fetchone()

            if not q:
                break

            if current_total + q["marks"] > total_marks:
                break

            generated_questions["part_c"].append(q)
            used_ids.append(q["question_id"])
            current_total += q["marks"]

    

    session["generated_questions"] = generated_questions
    session["total_marks"] = total_marks

    cursor.close()
    conn.close()

    return render_template(
        "question_generator.html",
        subjects=subjects,
        generated_questions=generated_questions,
        total_marks=total_marks
    )

from flask import make_response
from reportlab.pdfgen import canvas
import io
from datetime import datetime


@app.route("/export_pdf")
def export_pdf():

    generated_questions = session.get("generated_questions", {})
    total_marks = session.get("total_marks", 0)

    buffer = io.BytesIO()
    pdf = canvas.Canvas(buffer)

    pdf.setFont("Helvetica-Bold", 18)
    pdf.drawString(150, 800, "AI Question Paper Generation System")

    pdf.setFont("Helvetica", 12)
    pdf.drawString(50, 770, f"Date: {datetime.now().strftime('%d-%m-%Y')}")
    pdf.drawString(50, 750, f"Total Marks: {total_marks}")

    y = 710

    # PART A
    pdf.setFont("Helvetica-Bold", 14)
    pdf.drawString(50, y, "PART A (2 Marks)")
    y -= 30

    for i, q in enumerate(generated_questions.get("part_a", []), start=1):
        pdf.drawString(60, y, f"Q{i}. {q['question_text']} ({q['marks']} Marks)")
        y -= 25

    # PART B
    pdf.drawString(50, y, "PART B (3 Marks)")
    y -= 30

    start_q = len(generated_questions.get("part_a", [])) + 1

    for i, q in enumerate(generated_questions.get("part_b", []), start=start_q):
        pdf.drawString(60, y, f"Q{i}. {q['question_text']} ({q['marks']} Marks)")
        y -= 25

    # PART C
    pdf.drawString(50, y, "PART C (10 Marks)")
    y -= 30

    start_q += len(generated_questions.get("part_b", []))

    for i, q in enumerate(generated_questions.get("part_c", []), start=start_q):
        pdf.drawString(60, y, f"Q{i}. {q['question_text']} ({q['marks']} Marks)")
        y -= 25

    pdf.save()

    buffer.seek(0)

    response = make_response(buffer.getvalue())
    response.headers["Content-Type"] = "application/pdf"
    response.headers["Content-Disposition"] = "attachment; filename=question_paper.pdf"

    return response

@app.route("/add_hod", methods=["GET", "POST"])
def add_hod():
    if "user_id" not in session or session["role"] != "admin":
        return redirect(url_for("login"))

    message = None

    if request.method == "POST":
        name = request.form.get("name")
        email = request.form.get("email")
        password = request.form.get("password")
        department = request.form.get("department")
        address = request.form.get("address")

        try:
            conn = get_db()
            cursor = conn.cursor()

            query = """
            INSERT INTO users (name, email, password, role, department, address)
            VALUES (%s, %s, %s, 'hod', %s, %s)
            """
            cursor.execute(query, (name, email, password, department, address))
            conn.commit()
            activity_cursor = conn.cursor()

            activity_cursor.execute("""
             INSERT INTO activity_log (activity_text)
             VALUES (%s)
            """, ("New HOD added to system",))

            conn.commit()
            activity_cursor.close()

            new_user_id = cursor.lastrowid

            cursor.close()
            conn.close()

            message = f"HOD created successfully. Generated User ID: {new_user_id}"

        except Exception as e:
            message = f"Error: {e}"

    return render_template("add_hod.html", message=message)

@app.route("/view_hods")
def view_hods():
    if "user_id" not in session or session["role"] != "admin":
        return redirect(url_for("login"))

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
    SELECT user_id, name, email, department
    FROM users
    WHERE role='hod'
    """)
    hods = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("view_hods.html", hods=hods)

@app.route("/hod_dashboard")
def hod_dashboard():
    if "user_id" not in session or session["role"] != "hod":
        return redirect(url_for("login"))

    hod_department = session["department"]

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    # total faculty
    cursor.execute("""
        SELECT COUNT(*) AS total_faculty
        FROM users
        WHERE role = 'faculty' AND department = %s
    """, (hod_department,))
    total_faculty = cursor.fetchone()["total_faculty"]

    # pending questions count
    cursor.execute("""
        SELECT COUNT(*) AS pending_count
        FROM question q
        JOIN users u ON q.user_id = u.user_id
        WHERE u.department = %s AND q.approved = 'N'
    """, (hod_department,))
    pending_count = cursor.fetchone()["pending_count"]

    # approved questions count
    cursor.execute("""
        SELECT COUNT(*) AS approved_count
        FROM question q
        JOIN users u ON q.user_id = u.user_id
        WHERE u.department = %s AND q.approved = 'Y'
    """, (hod_department,))
    approved_count = cursor.fetchone()["approved_count"]

    # rejected questions count
    cursor.execute("""
        SELECT COUNT(*) AS rejected_count
        FROM question q
        JOIN users u ON q.user_id = u.user_id
        WHERE u.department = %s AND q.approved = 'R'
    """, (hod_department,))
    rejected_count = cursor.fetchone()["rejected_count"]

    # real pending questions list
    cursor.execute("""
        SELECT
            q.question_id,
            q.question_text,
            q.answer_text,
            q.marks,
            q.difficulty,
            q.blooms_level,
            q.approved,
            u.user_id AS faculty_id,
            u.name AS faculty_name,
            s.subject_name,
            m.module_name
        FROM question q
        JOIN users u ON q.user_id = u.user_id
        LEFT JOIN subject s ON q.subject_id = s.subject_id
        LEFT JOIN module m ON q.module_id = m.module_id
        WHERE u.department = %s AND q.approved = 'N'
        ORDER BY q.question_id DESC
        LIMIT 10
    """, (hod_department,))
    questions = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "hod_dashboard.html",
        total_faculty=total_faculty,
        pending_count=pending_count,
        approved_count=approved_count,
        rejected_count=rejected_count,
        questions=questions
    )

@app.route("/hod_pending_questions")
def hod_pending_questions():
    if "user_id" not in session or session["role"] != "hod":
        return redirect(url_for("login"))

    hod_department = session["department"]

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            q.question_id,
            q.question_text,
            q.answer_text,
            
            q.marks,
            q.difficulty,
            q.blooms_level,
            q.approved,
            q.reject_reason,
            q.user_id AS faculty_id,
            u.name AS faculty_name,
            s.subject_name,
            m.module_name
        FROM question q
        JOIN users u ON q.user_id = u.user_id
        LEFT JOIN subject s ON q.subject_id = s.subject_id
        LEFT JOIN module m ON q.module_id = m.module_id
        WHERE u.department = %s AND q.approved = 'N'
        ORDER BY q.question_id DESC
    """, (hod_department,))

    questions = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("hod_pending_questions.html", questions=questions)

@app.route("/hod_approved_questions")
def hod_approved_questions():
    if "user_id" not in session or session["role"] != "hod":
        return redirect(url_for("login"))

    hod_department = session["department"]

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            q.question_id,
            q.question_text,
            q.answer_text,
            q.marks,
            q.difficulty,
            q.blooms_level,
            q.approved,
            q.reject_reason,
            q.user_id AS faculty_id,
            u.name AS faculty_name,
            u.department,
            s.subject_name,
            m.module_name
        FROM question q
        JOIN users u ON q.user_id = u.user_id
        LEFT JOIN subject s ON q.subject_id = s.subject_id
        LEFT JOIN module m ON q.module_id = m.module_id
        WHERE u.department = %s AND q.approved = 'Y'
        ORDER BY q.question_id DESC
    """, (hod_department,))

    questions = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("hod_approved_questions.html", questions=questions)

@app.route("/hod_rejected_questions")
def hod_rejected_questions():
    if "user_id" not in session or session["role"] != "hod":
        return redirect(url_for("login"))

    hod_department = session["department"]

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            q.question_id,
            q.question_text,
            q.answer_text,
            q.marks,
            q.difficulty,
            q.blooms_level,
            q.approved,
            q.reject_reason,
            q.user_id AS faculty_id,
            u.name AS faculty_name,
            u.department,
            s.subject_name,
            m.module_name
        FROM question q
        JOIN users u ON q.user_id = u.user_id
        LEFT JOIN subject s ON q.subject_id = s.subject_id
        LEFT JOIN module m ON q.module_id = m.module_id
        WHERE u.department = %s AND q.approved = 'R'
        ORDER BY q.question_id DESC
    """, (hod_department,))

    questions = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("hod_rejected_questions.html", questions=questions)

@app.route("/approve/<int:qid>")
def approve(qid):
    if "user_id" not in session or session["role"] != "hod":
        return redirect(url_for("login"))

    conn = get_db()
    cursor = conn.cursor()

    cursor.execute("""
        UPDATE question
        SET approved='Y', hod_id=%s, reject_reason=NULL
        WHERE question_id=%s
    """, (session["user_id"], qid))

    conn.commit()
    activity_cursor = conn.cursor()

    activity_cursor.execute("""
    INSERT INTO activity_log (activity_text)
    VALUES (%s)
""", ("Question approved by HOD",))

    conn.commit()
    activity_cursor.close()
    cursor.close()
    conn.close()

    return redirect(url_for("hod_pending_questions"))



@app.route("/reject/<int:qid>", methods=["POST"])
def reject(qid):
    if "user_id" not in session or session["role"] != "hod":
        return redirect(url_for("login"))

    reject_reason = request.form.get("reject_reason")

    conn = get_db()
    cursor = conn.cursor()

    cursor.execute("""
        UPDATE question
        SET approved='R', hod_id=%s, reject_reason=%s
        WHERE question_id=%s
    """, (session["user_id"], reject_reason, qid))

    conn.commit()
    cursor.close()
    conn.close()

    return redirect(url_for("hod_pending_questions"))


@app.route("/add_faculty", methods=["GET", "POST"])
def add_faculty():
    if "user_id" not in session or session["role"] != "hod":
        return redirect(url_for("login"))

    message = None
    hod_department = session["department"]

    if request.method == "POST":
        name = request.form.get("name")
        email = request.form.get("email")
        password = request.form.get("password")

        try:
            conn = get_db()
            cursor = conn.cursor(dictionary=True)

            # Check duplicate email
            cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
            existing_email = cursor.fetchone()

            # Check duplicate same name + role + department
            cursor.execute("""
                SELECT * FROM users
                WHERE name = %s AND role = 'faculty' AND department = %s
            """, (name, hod_department))
            existing_name = cursor.fetchone()

            if existing_email:
                message = "This email already exists. Please use another email."
            elif existing_name:
                message = "Faculty with same name already exists in this department."
            else:
                insert_cursor = conn.cursor()
                query = """
                INSERT INTO users (name, email, password, role, department)
                VALUES (%s, %s, %s, 'faculty', %s)
                """
                insert_cursor.execute(query, (name, email, password, hod_department))
                conn.commit()

                new_user_id = insert_cursor.lastrowid
                insert_cursor.close()

                message = f"Faculty created successfully. Generated User ID: {new_user_id}"

            cursor.close()
            conn.close()

        except Exception as e:
            message = f"Error: {e}"

    return render_template("add_faculty.html", message=message, hod_department=hod_department)

@app.route("/assign_subjects", methods=["GET", "POST"])
def assign_subjects():
    if "user_id" not in session or session["role"] != "hod":
        return redirect(url_for("login"))

    hod_id = session["user_id"]
    hod_department = session["department"]
    message = None

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    # faculty from same department
    cursor.execute("""
        SELECT user_id, name
        FROM users
        WHERE role = 'faculty' AND department = %s
        ORDER BY name
    """, (hod_department,))
    faculty_list = cursor.fetchall()

    # existing subjects from same department
    cursor.execute("""
        SELECT subject_id, subject_name
        FROM subject
        WHERE department = %s
        ORDER BY subject_name
    """, (hod_department,))
    subjects = cursor.fetchall()

    if request.method == "POST":
       faculty_id = request.form.get("faculty_id")

       subject_ids = request.form.getlist("subject_ids")

       new_subject = request.form.get("new_subject")

       if (not subject_ids or len(subject_ids) == 0) and (not new_subject or new_subject.strip() == ""):
        message = "Please select at least one subject or enter a new subject."
        cursor.close()
        conn.close()
        return render_template(
        "assign_subjects.html",
        faculty_list=faculty_list,
        subjects=subjects,
        message=message
    )

    try:
        insert_cursor = conn.cursor()

        # new subject logic
        if new_subject and new_subject.strip() != "":
            insert_cursor.execute("""
                SELECT subject_id FROM subject
                WHERE subject_name = %s AND department = %s
            """, (new_subject, hod_department))
            existing = insert_cursor.fetchone()

            if existing:
                new_subject_id = existing[0]
            else:
                insert_cursor.execute("""
                   INSERT INTO subject (subject_name, department)
                 VALUES (%s, %s)
                """, (new_subject, hod_department))

                conn.commit()

            new_subject_id = insert_cursor.lastrowid
# AUTO CREATE MODULES

        for i in range(1, 6):
            insert_cursor.execute("""
          INSERT INTO module (module_name, subject_id)
           VALUES (%s, %s)
         """, (f"Module {i}", new_subject_id))

        # assign subjects
        for sub_id in subject_ids:
            insert_cursor.execute("""
                SELECT id FROM faculty_subject
                WHERE faculty_id = %s AND subject_id = %s
            """, (faculty_id, sub_id))
            exists = insert_cursor.fetchone()

            if not exists:
                insert_cursor.execute("""
                    INSERT INTO faculty_subject (faculty_id, subject_id, hod_id, department)
                    VALUES (%s, %s, %s, %s)
                """, (faculty_id, sub_id, hod_id, hod_department))

        conn.commit()
        insert_cursor.close()

        message = "Subjects assigned successfully."

    except Exception as e:
        message = f"Error: {e}"

    cursor.close()
    conn.close()
    print("HOD Department:", hod_department)
    print("Faculty List:", faculty_list)
    print("Subjects:", subjects)   
    return render_template(
        "assign_subjects.html",
        faculty_list=faculty_list,
        subjects=subjects,
        message=message
    )

@app.route("/hod_faculty_submissions")
def hod_faculty_submissions():
    if "user_id" not in session or session["role"] != "hod":
        return redirect(url_for("login"))

    hod_department = session["department"]

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            u.user_id,
            u.name,
            u.email,
            u.department,
            COUNT(DISTINCT q.question_id) AS total_questions,
            GROUP_CONCAT(DISTINCT s.subject_name ORDER BY s.subject_name SEPARATOR ', ') AS assigned_subjects
        FROM users u
        LEFT JOIN question q ON u.user_id = q.user_id
        LEFT JOIN faculty_subject fs ON u.user_id = fs.faculty_id
        LEFT JOIN subject s ON fs.subject_id = s.subject_id
        WHERE u.role = 'faculty' AND u.department = %s
        GROUP BY u.user_id, u.name, u.email, u.department
        ORDER BY u.user_id DESC
    """, (hod_department,))

    faculty_list = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("hod_faculty_submissions.html", faculty_list=faculty_list)



@app.route("/faculty_dashboard")
def faculty_dashboard():
    if "user_id" not in session or session["role"] != "faculty":
        return redirect(url_for("login"))

    faculty_id = session["user_id"]

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    # profile
    cursor.execute("""
        SELECT user_id, name, email, department, role
        FROM users
        WHERE user_id = %s
    """, (faculty_id,))
    profile = cursor.fetchone()

    # assigned subjects
    cursor.execute("""
        SELECT s.subject_id, s.subject_name
        FROM faculty_subject fs
        JOIN subject s ON fs.subject_id = s.subject_id
        WHERE fs.faculty_id = %s
        ORDER BY s.subject_name
    """, (faculty_id,))
    assigned_subjects = cursor.fetchall()

    # my questions
    cursor.execute("""
        SELECT
            q.question_id,
            q.question_text,
            q.answer_text,
            q.marks,
            q.difficulty,
            q.blooms_level,
            q.approved,
            q.reject_reason,
            s.subject_name,
            m.module_name
        FROM question q
        LEFT JOIN subject s ON q.subject_id = s.subject_id
        LEFT JOIN module m ON q.module_id = m.module_id
        WHERE q.user_id = %s
        ORDER BY q.question_id DESC
    """, (faculty_id,))
    my_questions = cursor.fetchall()

    cursor.close()
    conn.close()
 
    return render_template(
        "faculty_dashboard.html",
        profile=profile,
        my_questions=my_questions,
        assigned_subjects=assigned_subjects
    )



if __name__ == "__main__":
    app.run(debug=True)