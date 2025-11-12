from flask import Blueprint, request, jsonify
from models.turno import Turno

ws_turno = Blueprint('ws_turno', __name__)
turno = Turno()

@ws_turno.route('/listarPorMedico', methods=['POST'])
def listar_turnos_por_medico():
    data = request.get_json()

    medico_id = data.get('medicoId')

    if not medico_id:
        return jsonify({
            "data": None,
            "message": "Falta el parámetro 'medicoId'",
            "status": False
        }), 400
    
    resultado = turno.listarTurnosPorMedico(medico_id)

    if not resultado:
        return jsonify({
            "data": [],
            "message": "No se encontraron turnos para el médico especificado",
            "status": True
        })
    
    turnos = []
    for row in resultado:
        id_val = row.get('id')
        fecha_val = row.get('fecha')
        hora_inicio_val = row.get('hora_inicio')
        hora_fin_val = row.get('hora_fin')
        estado_val = row.get('estado')
        dia_semana_val = row.get('dia_semana')

        turnos.append({
            "id": id_val,
            "fecha": str(fecha_val),
            "hora_inicio": str(hora_inicio_val),
            "hora_fin": str(hora_fin_val),
            "estado": estado_val,
            "dia_semana": dia_semana_val
        })

    return jsonify({
        "data": turnos,
        "message": "Turnos listados correctamente",
        "status": True
    })
