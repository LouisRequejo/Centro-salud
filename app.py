from flask import Flask

from routes.rol import ws_rol
from routes.medico import ws_medico
from routes.especialidad import ws_especialidad

app = Flask(__name__)
app.register_blueprint(ws_rol, url_prefix='/rol')
app.register_blueprint(ws_medico, url_prefix='/medico')
app.register_blueprint(ws_especialidad, url_prefix='/especialidad')


@app.route('/')
def home():
    return 'Prueba'

if __name__ == '__main__':
    app.run(port=3007, debug=True, host='0.0.0.0')