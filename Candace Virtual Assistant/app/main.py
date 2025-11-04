import routes
import sqlite3

def VerifyLoginCredentials(username: str, password: str, db: sqlite3.Connection) -> bool: 
    cur = db.cursor()
    cur.execute("SELECT * FROM LOGIN_INFO WHERE login_id = ? AND login_password = ?", (username, password))
    return cur.fetchone() != None
    

def VerifySignUpCredentials(student_id: int, username: str, password: str, db: sqlite3.Connection) -> bool:
    return False


if __name__ == '__main__':
    routes.RunApp()
