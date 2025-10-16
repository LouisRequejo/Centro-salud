from flask import Flask

from routes.rol import ws_rol
from routes.domicilio import ws_domicilio
from routes.personal import ws_personal

app = Flask(__name__)
app.register_blueprint(ws_rol, url_prefix='/rol')
app.register_blueprint(ws_domicilio, url_prefix = '/domicilio')
app.register_blueprint(ws_personal, url_prefix='/personal')


@app.route('/')
def home():
    return 'Prueba'

if __name__ == '__main__':
    app.run(port=3007, debug=True, host='0.0.0.0')