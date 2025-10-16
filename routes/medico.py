from flask import Blueprint, request, jsonify, send_from_directory
from tools.jwt_required import jwt_token_requerido
from models.medico import Medico
import os
from werkzeug.utils import secure_filename

# Crear un módulo blueprint para implementar el servicio web de médico
ws_medico = Blueprint('ws_medico', __name__)

# Instanciar a la clase Medico
medico = Medico()

#Definir la ruta base para las fotos de médicos
FOTOS_MEDICOS =  os.path.join(os.path.dirname(os.path.dirname(__file__)), 'uploads', 'fotos','medicos')

# Crear un endpoint para registrar nuevos médicos
@ws_medico.route('/medico/registrar', methods=['POST'])
@jwt_token_requerido
def registrar():
    # Obtener los datos que se envían como parámetros de entrada
    data = request.get_json()

    # Pasar los datos a variables
    nombres = data.get('nombres')
    ape_paterno = data.get('ape_paterno')
    ape_materno = data.get('ape_materno')
    dni = data.get('dni')
    email = data.get('email')
    telefono = data.get('telefono')
    id_personal_validado = data.get('id_personal_validado') # Asumiendo que este ID viene del token o de la sesión

    # Validar si contamos con los parámetros obligatorios
    if not all([nombres, ape_paterno, ape_materno, dni, email, telefono]):
        return jsonify({'status': False, 'data': None, 'message': 'Faltan datos obligatorios'}), 400

    # Validar que el email y dni no estén en uso
    valida, mensaje = medico.validar_existente(email, dni)
    if not valida:
        return jsonify({'status': False, 'data': None, 'message': mensaje}), 400

    # Registrar al médico
    try:
        resultado = medico.registrar(nombres, ape_paterno, ape_materno, dni, email, telefono, id_personal_validado)

        if resultado:
            return jsonify({'status': True, 'data': {'id': resultado}, 'message': 'Médico registrado correctamente'}), 200
        else:
            return jsonify({'status': False, 'data': None, 'message': 'Ocurrió un error al registrar al médico'}), 500

    except Exception as e:
        return jsonify({'status': False, 'data': None, 'message': str(e)}), 500

# Crear un endpoint para actualizar al médico
@ws_medico.route('/medico/actualizar', methods=['PUT'])
@jwt_token_requerido
def actualizar():
    # Obtener los datos que se envían como parámetros de entrada
    data = request.get_json()

    # Pasar los datos a variables
    id = data.get('id')
    nombres = data.get('nombres')
    ape_paterno = data.get('ape_paterno')
    ape_materno = data.get('ape_materno')
    dni = data.get('dni')
    email = data.get('email')
    telefono = data.get('telefono')

    # Validar si contamos con los parámetros obligatorios
    if not all([id, nombres, ape_paterno, ape_materno, dni, email, telefono]):
        return jsonify({'status': False, 'data': None, 'message': 'Faltan datos obligatorios'}), 400

    # Actualizar al médico
    try:
        resultado = medico.actualizar(id, nombres, ape_paterno, ape_materno, dni, email, telefono)

        if resultado:
            return jsonify({'status': True, 'data': None, 'message': 'Médico actualizado correctamente'}), 200
        else:
            return jsonify({'status': False, 'data': None, 'message': 'Ocurrió un error al actualizar al médico'}), 500

    except Exception as e:
        return jsonify({'status': False, 'data': None, 'message': str(e)}), 500

# Crear un endpoint para dar de baja a un médico
@ws_medico.route('/medico/darbaja', methods=['DELETE'])
@jwt_token_requerido
def darbaja():
    # Obtener los datos que se envían como parámetros de entrada
    data = request.get_json()
    id = data.get('id')

    # Validar si el id es válido
    if not id:
        return jsonify({'status': False, 'data': None, 'message': 'ID inválido'}), 400

    # Dar de baja al médico
    try:
        resultado = medico.darbaja(id)

        if resultado:
            return jsonify({'status': True, 'data': None, 'message': 'Médico dado de baja correctamente'}), 200
        else:
            return jsonify({'status': False, 'data': None, 'message': 'Ocurrió un error al dar de baja al médico'}), 500

    except Exception as e:
        return jsonify({'status': False, 'data': None, 'message': str(e)}), 500

# Crear un endpoint para actualizar la foto del médico
@ws_medico.route('/medico/actualizarfoto', methods=['PUT'])
@jwt_token_requerido
def actualizarfoto():
    # Obtener los datos que se envían como parámetros de entrada
    id = request.form.get('id')
    foto = request.files.get('foto')

    # Validar si contamos con los parámetros obligatorios
    if not all([id, foto]):
        return jsonify({'status': False, 'data': None, 'message': 'Faltan datos obligatorios'}), 400

    # Actualizar la foto del médico
    try:
        nombre_foto = None
        if 'foto' in request.files:
            extension = os.path.splitext(foto.filename)[1]
            nombre_foto = secure_filename(f"medico_{id}{extension}")
            # Asegúrate de que esta ruta exista
            ruta_foto = os.path.join(FOTOS_MEDICOS, nombre_foto)
            foto.save(ruta_foto)

            resultado, mensaje = medico.actualizarfoto(nombre_foto, id)

            if resultado:
                return jsonify({'status': True, 'data': None, 'message': 'Foto de médico actualizada correctamente'}), 200
            else:
                return jsonify({'status': False, 'data': None, 'message': 'Ocurrió un error al actualizar la foto del médico'}), 500
        else:
            return jsonify({'status': False, 'data': None, 'message': "No se encontró el archivo de la foto"}), 400

    except Exception as e:
        return jsonify({'status': False, 'data': None, 'message': str(e)}), 500

# Crear un endpoint para obtener la foto del médico mediante su id
@ws_medico.route('/medico/foto/<id>', methods=['GET'])
def obtener_foto(id):
    # Validar si se cuenta con el id para mostrar la foto
    if not id:
        return jsonify({'status': False, 'data': None, 'message': 'Faltan datos obligatorios'}), 400

    try:
        resultado = medico.obtener_foto(id)
        if resultado and resultado.get('foto'):
            return send_from_directory(FOTOS_MEDICOS, resultado['foto'])
        else:
            # Devuelve una imagen por defecto si el médico no tiene foto
            return send_from_directory(FOTOS_MEDICOS, 'default.png')
    except Exception as e:
        return jsonify({'status': False, 'data': None, 'message': str(e)}), 500