import routes
import sqlite3

def VerifyLoginCredentials(username: str, password: str, db: sqlite3.Connection) -> bool: 
    cur = db.cursor()
    cur.execute("SELECT * FROM LOGIN_INFO WHERE login_id = ? AND login_password = ?", (username, password))
    return cur.fetchone() != None
    

def VerifySignUpCredentials(student_id: int, username: str, password: str, db: sqlite3.Connection):
    cur = db.cursor()
    id_check = cur.execute("SELECT * FROM LOGIN_INFO WHERE login_id = ?", username)
    if id_check.fetchone() is not None:
        return False, "Student email already in use."
    else:
        return False
    
    return False

def ValidatePassword(password: str) -> bool:
    has_number = False
    has_special_character = False
    has_character_count = False

    pass_in_chars = list(password)
    has_character_count = pass_in_chars.count >= 8

    for p in pass_in_chars:
        try:
            return int(p)
        except ValueError:
            return None


if __name__ == '__main__':
    routes.RunApp()
