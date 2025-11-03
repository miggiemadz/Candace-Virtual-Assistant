from flask import Flask, redirect, url_for, request, app, render_template
import main, db_utils

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def UserLoginPage():
    if request.method == 'POST':
        db = db_utils.get_db()
        username_input = request.form['username']
        password_input = request.form['password']
        if (main.VerifyLoginCredentials(username_input, password_input, db)):
            return redirect(url_for('DashboardPage'))
        else:
            return render_template('login-page.html', error="Invalid credentials")
    else:
        return render_template('login-page.html')

@app.route('/dashboard')
def DashboardPage():
    return "This is the student dashboard page."

@app.route('/sign-up', methods=['GET', 'POST'])
def StudentSignUpPage():
    if request.method == 'POST':
        db = db_utils.get_db()
        
    return "This is the student sign up page."

def RunApp():
    return app.run(debug=True)
