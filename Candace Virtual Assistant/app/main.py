import routes

userNameInput = ""
passwordInput = ""

def VerifyLoginCredentials(username: str, password: str, db) -> bool: 
    return username == "0679866" and password == "Miggie(2004)"

if __name__ == '__main__':
    routes.RunApp()
