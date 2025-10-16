from flask import Blueprint, request, jsonify
from models.rol import Rol

ws_rol = Blueprint('ws_rol', __name__)

rol = Rol()


@ws_rol.route('/register', methods=['POST'])
def crear_rol():
    data = request.get_json(silent=True) or {}
    nombre = data.get('nombre')

    if not nombre:
        return jsonify({'data': None, 'status': False,
                        'message': 'Debe completar todos los campos'}), 400

    mensaje = rol.registrar(nombre)

    if mensaje is None:
        return jsonify({'data': None, 'status': False,
                        'message': 'Error al registrar el rol'}), 500

    # Normaliza según mensaje del SP
    ok = mensaje.lower().startswith('rol insertado')
    return jsonify({'data': None, 'status': ok, 'message': mensaje}), 200 if ok else 409
