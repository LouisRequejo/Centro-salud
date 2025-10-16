from flask import Flask

from routes.rol import ws_rol

app = Flask(__name__)
app.register_blueprint(ws_rol, url_prefix='/rol')


@app.route('/')
def home():
    return 'Prueba'

if __name__ == '__main__':
    app.run(port=3007, debug=True, host='0.0.0.0')