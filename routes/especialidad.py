from flask import Blueprint, request, jsonify
from tools.jwt_required import jwt_token_requerido
from models.especialidad import Especialidad
import os


#Crear un módulo blueprint para implementar el servicio web de especialidad
ws_especialidad = Blueprint('ws_especialidad', __name__)

#Instanciar a la clase Especialidad
especialidad = Especialidad()

#Crear un endpoint para registrar nuevas especialidades
@ws_especialidad.route('/especialidad/registrar', methods=['POST'])
@jwt_token_requerido
def registrar():
    #Obtener los datos que se envían como parámetros de entrada
    data = request.get_json()

    #Pasar los datos a variables
    nombre = data.get('nombre')
    descripcion = data.get('descripcion')

    #Validar si contamos con los parámetros obligatorios
    if not all([nombre, descripcion]):
        return jsonify({'status': False, 'data': None, 'message': 'Faltan datos obligatorios'}), 400

    #Validar que el nombre de la especialidad no esté en uso
    valida, mensaje = especialidad.validar_existente(nombre)
    if not valida:
        return jsonify({'status': False, 'data': None, 'message': mensaje}), 400

    #Registrar la especialidad
    try:
        resultado = especialidad.registrar(nombre, descripcion)

        if resultado:
            return jsonify({'status': True, 'data': {'id': resultado}, 'message': 'Especialidad registrada correctamente'}), 200
        else:
            return jsonify({'status': False, 'data': None, 'message': 'Ocurrió un error al registrar la especialidad'}), 500

    except Exception as e:
        return jsonify({'status': False, 'data': None, 'message': str(e)}), 500
    
#Crear un endpoint para actualizar la especialidad
@ws_especialidad.route('/especialidad/actualizar', methods=['PUT'])
@jwt_token_requerido
def actualizar():
    #Obtener losd atos que se envía como parámetros de entrada
    data= request.get_json()

    #Pasar los datos o variables
    id = data.get('id')
    nombre = data.get('nombre')
    descripcion = data.get('descripcion')

    #Validar si contamos con los parámetros obligatiorios
    if not all([id, nombre, descripcion]):
        return jsonify({'status': False, 'data': None, 'message': 'Faltan datos obligatorios'}), 400
    
    #Actualizar la especialidad
    try:
        resultado = especialidad.actualizar(id, nombre, descripcion)

        if resultado:
            return jsonify({'status': True, 'data': {'id': id}, 'message': 'Especialidad actualizada correctamente'}), 200
        else:
            return jsonify({'status': False, 'data': None, 'message': 'Ocurrió un error al actualizar la especialidad'}), 500
    except Exception as e:
        return jsonify({'status': False, 'data': None, 'message': str(e)}), 500
    
#Crear un endpoint para dar de baja la especialidad
@ws_especialidad.route('/especialidad/darbaja', methods=['DELETE'])
@jwt_token_requerido
def darbaja():
    #Obtener losd atos que se envía como parámetros de entrada
    data = request.get_jsonU()
    id = data.get('id')

    #Validar si el id es válido
    if not id:
        return jsonify({'status': False, 'data': None, 'message': 'Falta el ID de la especialidad'}), 400
    
    #Dar de baja la especialidad
    try:
        resultado = especialidad.darbaja(id)

        if resultado:
            return jsonify({'status': True, 'data': {'id': id}, 'message': 'Especialidad dada de baja correctamente'}), 200
        else:
            return jsonify({'status': False, 'data': None, 'message': 'Ocurrió un error al dar de baja la especialidad'}), 500
    except Exception as e:
        return jsonify({'status': False, 'data': None, 'message': str(e)}), 500
    
@ws_especialidad.route('/listar', methods=['GET'])
def listar():
    try:
        result = especialidad.listar()
        return jsonify({'status': True, 'data': result, 'message': 'Especialidades obtenidas correctamente'}), 200
    except Exception as e:
        return jsonify({'status': False, 'data': None, 'message': str(e)}), 500
    
@ws_especialidad.route('/listarMedicoEP', methods=['POST'])
def listarMedicoEP():
    data = request.get_json()
    especialidadId = data.get('especialidadId')

    if not especialidadId:
        return jsonify({'status': False, 'data': None, 'message': 'Falta el ID de la especialidad'}), 400
    try:
        result = especialidad.listadoMedicosPorEspecialidad(especialidadId)
        return jsonify({'status': True, 'data': result, 'message': 'Médicos obtenidos correctamente'}), 200
    except Exception as e:
        return jsonify({'status': False, 'data': None, 'message': str(e)}), 500
    
