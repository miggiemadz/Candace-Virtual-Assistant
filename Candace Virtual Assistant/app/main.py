from flask import Flask, app
app = Flask(__name__)
@app.route('/')
def home():
    return "Candace is Running"
if __name__ == '__main__':
    app.run(debug=True)
