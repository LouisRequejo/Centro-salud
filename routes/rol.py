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

@ws_rol.route('/rol/eliminar/<int:rol_id>', methods=['DELETE'])
def eliminar_rol(rol_id):
    mensaje = rol.eliminar(rol_id)
    if mensaje is None:
        return jsonify({'data': None, 'status': False, 'message': 'Error interno'}), 500

    low = mensaje.lower()
    if low.startswith('rol eliminado'):
        return jsonify({'data': None, 'status': True, 'message': mensaje}), 200
    if low == 'el rol no existe':
        return jsonify({'data': None, 'status': False, 'message': mensaje}), 404
    if low == 'el rol está asignado a un personal y no puede eliminarse':
        return jsonify({'data': None, 'status': False, 'message': mensaje}), 409
    return jsonify({'data': None, 'status': False, 'message': mensaje}), 400


@ws_rol.route('/rol/<int:rol_id>', methods=['PUT'])
def actualizar_rol(rol_id):
    data = request.get_json(silent=True) or {}
    nombre = (data.get('nombre') or '').strip()
    if not nombre:
        return jsonify({'data': None, 'status': False, 'message': 'Debe proporcionar el nombre'}), 400

    mensaje = rol.actualizar(rol_id, nombre)
    if mensaje is None:
        return jsonify({'data': None, 'status': False, 'message': 'Error interno'}), 500

    low = mensaje.lower()
    if low.startswith('rol actualizado'):
        return jsonify({'data': None, 'status': True, 'message': mensaje}), 200
    if low == 'el rol no existe':
        return jsonify({'data': None, 'status': False, 'message': mensaje}), 404
    return jsonify({'data': None, 'status': False, 'message': mensaje}), 400


@ws_rol.route('/rol/<int:rol_id>/baja', methods=['PATCH'])
def dar_baja_rol(rol_id):
    mensaje = rol.dar_de_baja(rol_id)
    if mensaje is None:
        return jsonify({'data': None, 'status': False, 'message': 'Error interno'}), 500

    low = mensaje.lower()
    if low.startswith('rol dado de baja'):
        return jsonify({'data': None, 'status': True, 'message': mensaje}), 200
    if low == 'el rol no existe':
        return jsonify({'data': None, 'status': False, 'message': mensaje}), 404
    return jsonify({'data': None, 'status': False, 'message': mensaje}), 400
