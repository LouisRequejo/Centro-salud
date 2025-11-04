from flask import Blueprint, request, jsonify
from models.programacion import Programacion
from datetime import datetime

ws_programacion = Blueprint('ws_programacion', __name__)
programacion = Programacion()

# Utilidad simple para validar fechas
def _parse_date(value):
    # acepta 'YYYY-MM-DD' o 'DD/MM/YYYY'
    if not value:
        return None
    try:
        if "-" in value:
            # ISO
            datetime.strptime(value, "%Y-%m-%d")
            return value
        else:
            # Latino
            dt = datetime.strptime(value, "%d/%m/%Y")
            return dt.strftime("%Y-%m-%d")
    except Exception:
        return None

# Utilidad para validar el arreglo de detalle
_VALID_DIAS = {
    "LUNES","MARTES","MIERCOLES","MIÉRCOLES",
    "JUEVES","VIERNES","SABADO","SÁBADO","DOMINGO"
}
def _validar_detalle(detalle):
    """
    detalle esperado: lista de objetos con:
      - dia_semana (str) uno de los válidos en español
      - hora_inicial (HH:MM o HH:MM:SS)
      - hora_final   (HH:MM o HH:MM:SS)
      - duracion_minutos (opcional, >0)
    Retorna (ok, msg) y normaliza horas a HH:MM:SS
    """
    if not isinstance(detalle, list) or len(detalle) == 0:
        return False, "El campo 'detalle' debe ser una lista no vacía."

    def _to_hms(h):
        # Normaliza HH:MM a HH:MM:SS si fuese necesario
        if not isinstance(h, str):
            return None
        if len(h) == 5 and h.count(":") == 1:
            return h + ":00"
        # validar HH:MM:SS
        try:
            datetime.strptime(h, "%H:%M:%S")
            return h
        except Exception:
            return None

    for i, item in enumerate(detalle, start=1):
        if not isinstance(item, dict):
            return False, f"Detalle índice {i}: debe ser objeto."
        dia = item.get("dia_semana")
        hi = _to_hms(item.get("hora_inicial"))
        hf = _to_hms(item.get("hora_final"))
        dur = item.get("duracion_minutos", 60)

        if not dia or not isinstance(dia, str) or dia.upper() not in _VALID_DIAS:
            return False, f"Detalle índice {i}: 'dia_semana' inválido."
        if not hi or not hf:
            return False, f"Detalle índice {i}: horas inválidas (use HH:MM o HH:MM:SS)."
        if hi >= hf:
            return False, f"Detalle índice {i}: 'hora_inicial' debe ser menor que 'hora_final'."
        try:
            if dur is not None and int(dur) <= 0:
                return False, f"Detalle índice {i}: 'duracion_minutos' debe ser > 0."
        except Exception:
            return False, f"Detalle índice {i}: 'duracion_minutos' debe ser numérico."

        # Normalizar dentro del mismo objeto para que el modelo reciba limpio
        item["dia_semana"] = dia
        item["hora_inicial"] = hi
        item["hora_final"] = hf
        item["duracion_minutos"] = int(dur) if dur is not None else 60
    return True, None


@ws_programacion.route('/registrar', methods=['POST'])
def crear_programacion():
    data = request.get_json(silent=True) or {}

    fecha_inicial = _parse_date(data.get('fecha_inicial'))
    fecha_final   = _parse_date(data.get('fecha_final'))
    medico_id      = data.get('medico_id')
    consultorio_id = data.get('consultorio_id')
    especialidad_id= data.get('especialidad_id')
    detalle        = data.get('detalle')

    # Validaciones básicas de request
    if not (fecha_inicial and fecha_final and medico_id and consultorio_id and especialidad_id and detalle):
        return jsonify({
            'data': None, 'status': False,
            'message': 'Debe completar todos los campos requeridos.'
        }), 400

    ok_det, msg_det = _validar_detalle(detalle)
    if not ok_det:
        return jsonify({'data': None, 'status': False, 'message': msg_det}), 400

    # Llamar al modelo (PA)
    codigo, mensaje = programacion.registrar(
        fecha_inicial, fecha_final,
        medico_id, consultorio_id, especialidad_id,
        detalle
    )

    # Mapear código a HTTP
    if codigo == 1:
        http = 200
        status = True
    elif codigo == -1:
        http = 409  # conflicto por validación/regla de negocio
        status = False
    else:
        http = 500
        status = False

    return jsonify({'data': None, 'status': status, 'message': mensaje}), http
