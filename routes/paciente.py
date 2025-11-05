from flask import Blueprint, request, jsonify
from models.paciente import Paciente
from tools.jwt_utils import generar_token

ws_paciente = Blueprint('ws_paciente', __name__)
paciente = Paciente()


def _resp(data=None, ok=True, message='', code=200):
    return jsonify({'data': data, 'status': ok, 'message': message}), code

@ws_paciente.route('/login', methods=['POST'])
def login_paciente():
    try:
        data = request.get_json(silent=True) or {}

        email = data.get('email', '').strip()
        password = data.get('password', '').strip()

        if not email or not password:
            return _resp(None, False, 'Email y contraseña son requeridos', 400)

        usuario = paciente.login(email, password)

        if usuario:
            # Generar token JWT
            token = generar_token({
                'id': usuario.get('id'),
                'email': usuario.get('email'),
                'nombre': usuario.get('nombre')
            })

            return jsonify({
                'status': True,
                'message': 'Login exitoso',
                'token': token,
                'data': {
                    'id': usuario.get('id'),
                    'nombre': usuario.get('nombre'),
                    'email': usuario.get('email')
                },
                'redirect': '/dashboard'
            }), 200
        else:
            return _resp(None, False, 'Correo o contraseña incorrectos', 401)

    except Exception as e:
        print(f"Error en login paciente: {e}")
        return _resp(None, False, 'Error interno del servidor', 500)