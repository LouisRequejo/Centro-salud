from flask import Blueprint, request, jsonify
from models.cita import Cita

ws_cita = Blueprint('ws_cita', __name__)
Cita = Cita()

@ws_cita.route('/reservar', methods=['POST'])
def reservar_cita():
    data = request.get_json()

    if not data:
        return jsonify({"data": None,"status": False, "message": "Datos inválidos"}), 400
    if 'paciente_id' not in data or 'tipo_atencion' not in data or 'direccion_domicilio' not in data or 'turno_id' not in data:
        return jsonify({"data": None, "status": False, "message": "Faltan campos obligatorios"}), 400

    paciente_id = data.get('paciente_id')
    tipo_atencion = data.get('tipo_atencion')
    direccion_domicilio = data.get('direccion_domicilio')
    turno_id = data.get('turno_id')

    exito, resultado = Cita.reservar_cita(paciente_id, tipo_atencion, direccion_domicilio, turno_id)

    if exito:
        return jsonify({"data": {"message": "Cita reservada con éxito", "cita_id": resultado}, "status": True}), 201
    else:
        return jsonify({"data": None, "status": False, "message": resultado}), 400
