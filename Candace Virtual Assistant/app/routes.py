from flask import Flask, app

app = Flask(__name__)

@app.route('/')
def home():
    return "Candace is Running"

def RunApp():
    return app.run(debug=True)
