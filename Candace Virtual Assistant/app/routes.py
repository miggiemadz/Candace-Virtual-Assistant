from flask import Flask, redirect, url_for, request, app
import main

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def UserLoginPage():
    if main.accountVerified:
        return redirect(url_for('StudentLoginPage'))
    return "Main dashboard."

@app.route('/dashboard')
def DashboardPage():
    return "This is the student dashboard page."

@app.route('/student-login/sign-up')
def StudentSignUpPage():
    return "This is the student sign up page."

def RunApp():
    return app.run(debug=True)
