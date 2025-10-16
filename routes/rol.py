from flask import Blueprint, request, jsonify
from models.rol import Rol

ws_rol = Blueprint('ws_rol', __name__)

rol = Rol()


@ws_rol.route('/register', methods=['POST'])
def crear_rol():
    data = request.get_json()
    nombre = data.get('nombre')

    if not nombre:
        return jsonify({'data': None, 'status': False, 'message': 'Debe completar todos los campos'}), 401
    
    result = rol.registrar(nombre)
    if result:
        return jsonify({'data': None, 'status': True, 'message': 'Registro exitoso'}), 200
    else:
        return jsonify({'data': None, 'status': False, 'message': 'Error al registrar el rol'}), 500

