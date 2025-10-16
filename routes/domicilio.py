from flask import Blueprint, request, jsonify
from models.domicilio import Domicilio

ws_domicilio = Blueprint('ws_domicilio', __name__)

domicilio = Domicilio()

# ----- REGISTRAR DOMICILIO -----
@ws_domicilio.route('/domicilio/register', methods=['POST'])
def crear_domicilio():
    data = request.get_json(silent=True) or {}
    nombre = (data.get('nombre') or '').strip()
    direccion = (data.get('direccion') or '').strip()
    paciente_id = data.get('paciente_id')

    # Validación de campos
    if not nombre or not direccion or not paciente_id:
        return jsonify({
            'data': None,
            'status': False,
            'message': 'Debe completar todos los campos (nombre, dirección, paciente_id)'
        }), 400

    mensaje = domicilio.registrar(nombre, direccion, paciente_id)

    if mensaje is None:
        return jsonify({'data': None, 'status': False, 'message': 'Error al registrar el domicilio'}), 500

    low = mensaje.lower()
    ok = low.startswith('domicilio insertado')
    duplicado = 'ya ha sido registrado' in low

    if ok:
        return jsonify({'data': None, 'status': True, 'message': mensaje}), 200
    elif duplicado:
        return jsonify({'data': None, 'status': False, 'message': mensaje}), 409
    else:
        return jsonify({'data': None, 'status': False, 'message': mensaje}), 400


# ----- ELIMINAR DOMICILIO -----
@ws_domicilio.route('/domicilio/<int:domicilio_id>', methods=['DELETE'])
def eliminar_domicilio(domicilio_id):
    mensaje = domicilio.eliminar(domicilio_id)
    if mensaje is None:
        return jsonify({'data': None, 'status': False, 'message': 'Error interno'}), 500

    low = mensaje.lower()
    if low.startswith('domicilio eliminado'):
        return jsonify({'data': None, 'status': True, 'message': mensaje}), 200
    elif low == 'el domicilio no existe':
        return jsonify({'data': None, 'status': False, 'message': mensaje}), 404
    else:
        return jsonify({'data': None, 'status': False, 'message': mensaje}), 400


# ----- ACTUALIZAR DOMICILIO -----
@ws_domicilio.route('/domicilio/<int:domicilio_id>', methods=['PUT'])
def actualizar_domicilio(domicilio_id):
    data = request.get_json(silent=True) or {}
    nombre = (data.get('nombre') or '').strip()
    direccion = (data.get('direccion') or '').strip()

    if not nombre or not direccion:
        return jsonify({'data': None, 'status': False, 'message': 'Debe proporcionar nombre y dirección'}), 400

    mensaje = domicilio.actualizar(domicilio_id, nombre, direccion)
    if mensaje is None:
        return jsonify({'data': None, 'status': False, 'message': 'Error interno'}), 500

    low = mensaje.lower()
    if low.startswith('domicilio actualizado'):
        return jsonify({'data': None, 'status': True, 'message': mensaje}), 200
    elif low == 'el domicilio no existe':
        return jsonify({'data': None, 'status': False, 'message': mensaje}), 404
    else:
        return jsonify({'data': None, 'status': False, 'message': mensaje}), 400
