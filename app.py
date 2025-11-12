from flask import Flask, render_template

from routes.rol import ws_rol
from routes.medico import ws_medico
from routes.especialidad import ws_especialidad
from routes.domicilio import ws_domicilio
from routes.personal import ws_personal
from routes.programacion import ws_programacion
from routes.paciente import ws_paciente
from routes.cita import ws_cita
from routes.turno import ws_turno

app = Flask(__name__, template_folder='views')
app.register_blueprint(ws_rol, url_prefix='/rol')
app.register_blueprint(ws_medico, url_prefix='/medico')
app.register_blueprint(ws_especialidad, url_prefix='/especialidad')
app.register_blueprint(ws_domicilio, url_prefix='/domicilio')
app.register_blueprint(ws_personal, url_prefix='/personal')
app.register_blueprint(ws_programacion, url_prefix='/programacion')
app.register_blueprint(ws_paciente, url_prefix='/paciente')
app.register_blueprint(ws_cita, url_prefix='/cita')
app.register_blueprint(ws_turno, url_prefix='/turno')

@app.route('/')
def home():
    return render_template('web/login.html')

@app.route('/dashboard')
def dashboard():
    return render_template('web/dashboard.html', active_page='dashboard')

@app.route('/medicos')
def gestionar_medicos():
    return render_template('web/medicos.html', active_page='medicos')

@app.route('/agendas')
def gestionar_agendas():
    return render_template('web/agendas.html', active_page='agendas')

@app.route('/reportes')
def reportes():
    return render_template('web/reportes.html', active_page='reportes')

@app.route('/notificaciones')
def notificaciones():
    return render_template('web/notificaciones.html', active_page='notificaciones')

@app.route('/perfil')
def perfil():
    return render_template('web/perfil.html', active_page='perfil')

@app.route('/sedes')
def gestionar_sedes():
    return render_template('web/sedes.html', active_page='sedes')

@app.route('/recuperar-password')
def recuperar_password():
    return render_template('web/recuperarpass.html')

if __name__ == '__main__':
    app.run(port=3007, debug=True, host='0.0.0.0')