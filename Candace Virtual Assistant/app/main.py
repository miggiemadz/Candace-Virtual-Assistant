import routes

def VerifyLoginCredentials(username: str, password: str, db) -> bool: 
    return username == "0679866" and password == "Miggie(2004)"

def VerifySignUpCredentials(student_id: int, username: str, password: str, db) -> bool:
    return False

if __name__ == '__main__':
    routes.RunApp()
