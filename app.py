from flask import Flask

app = Flask(__name__)


@app.route('/')
def home():
    return 'Prueba'

if __name__ == '__main__':
    app.run(port=3007, debug=True, host='0.0.0.0')