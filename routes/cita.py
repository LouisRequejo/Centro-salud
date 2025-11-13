from flask import Blueprint, request, jsonify, render_template
from models.cita import Cita, filtrar_citas, listar_todas_citas_web, obtener_estadisticas_citas
from models.medico import listar_medicos  # Asegúrate de tener esta función
from models.especialidad import listar_especialidades  # Asegúrate de tener esta función

ws_cita = Blueprint('ws_cita', __name__)
Cita_instance = Cita()

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

    exito, resultado = Cita_instance.reservar_cita(paciente_id, tipo_atencion, direccion_domicilio, turno_id)

    if exito:
        return jsonify({"data": None, "status": True, "message": f"Cita reservada con éxito, número de cita:  {resultado}"}), 201
    else:
        return jsonify({"data": None, "status": False, "message": resultado}), 400


@ws_cita.route('/agendas', methods=['GET'])
def index_agendas():
    """Página principal de gestión de agendas"""
    try:
        # Obtener datos iniciales
        citas = listar_todas_citas_web()
        medicos = listar_medicos()
        especialidades = listar_especialidades()
        
        return render_template('agendas.html', 
                             citas=citas,
                             medicos=medicos,
                             especialidades=especialidades)
    except Exception as e:
        print(f"Error al cargar agendas: {e}")
        return render_template('agendas.html', 
                             citas=[],
                             medicos=[],
                             especialidades=[])


@ws_cita.route('/agendas/filtrar', methods=['POST'])
def filtrar():
    """Endpoint para filtrar citas vía AJAX"""
    try:
        # Obtener parámetros del request
        data = request.get_json()
        
        if not data:
            return jsonify({
                "data": None,
                "status": False, 
                "message": "Datos inválidos"
            }), 400
        
        medico_id = data.get('medico_id')
        especialidad_id = data.get('especialidad_id')
        estado = data.get('estado')
        fecha = data.get('fecha')
        
        # Filtrar citas
        citas = filtrar_citas(
            medico_id=medico_id,
            especialidad_id=especialidad_id,
            estado=estado,
            fecha=fecha
        )
        
        # Obtener estadísticas
        estadisticas = obtener_estadisticas_citas(
            medico_id=medico_id,
            especialidad_id=especialidad_id
        )
        
        return jsonify({
            "data": {
                "citas": citas,
                "estadisticas": estadisticas,
                "total": len(citas)
            },
            "status": True,
            "message": f"Se encontraron {len(citas)} citas"
        }), 200
        
    except Exception as e:
        print(f"Error en filtrar citas: {e}")
        return jsonify({
            "data": None,
            "status": False,
            "message": f"Error al filtrar citas: {str(e)}"
        }), 500


@ws_cita.route('/agendas/citas-por-fecha/<fecha>', methods=['GET'])
def citas_por_fecha(fecha):
    """Obtener citas de una fecha específica"""
    try:
        citas = filtrar_citas(fecha=fecha)
        
        return jsonify({
            "data": {
                "citas": citas,
                "total": len(citas)
            },
            "status": True,
            "message": f"Se encontraron {len(citas)} citas para la fecha {fecha}"
        }), 200
        
    except Exception as e:
        print(f"Error al obtener citas por fecha: {e}")
        return jsonify({
            "data": None,
            "status": False,
            "message": f"Error al obtener citas: {str(e)}"
        }), 500


@ws_cita.route('/detalle/<int:cita_id>', methods=['GET'])
def obtener_detalle(cita_id):
    """Obtener detalle completo de una cita"""
    try:
        detalle = Cita_instance.obtener_cita_detalle(cita_id)
        
        if detalle:
            return jsonify({
                "data": detalle,
                "status": True,
                "message": "Detalle de cita obtenido exitosamente"
            }), 200
        else:
            return jsonify({
                "data": None,
                "status": False,
                "message": "Cita no encontrada"
            }), 404
            
    except Exception as e:
        print(f"Error al obtener detalle de cita: {e}")
        return jsonify({
            "data": None,
            "status": False,
            "message": f"Error al obtener detalle: {str(e)}"
        }), 500


@ws_cita.route('/listar', methods=['GET'])
def listar_citas():
    """Listar todas las citas"""
    try:
        citas = listar_todas_citas_web()
        
        return jsonify({
            "data": citas,
            "status": True,
            "message": f"Se encontraron {len(citas)} citas"
        }), 200
        
    except Exception as e:
        print(f"Error al listar citas: {e}")
        return jsonify({
            "data": None,
            "status": False,
            "message": f"Error al listar citas: {str(e)}"
        }), 500