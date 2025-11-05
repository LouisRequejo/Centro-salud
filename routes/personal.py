# webservices/personal.py
from flask import Blueprint, request, jsonify
from models.personal import Personal
from tools.jwt_utils import generar_token

ws_personal = Blueprint('ws_personal', __name__)
personal = Personal()

def _resp(data=None, ok=True, message='', code=200):
    return jsonify({'data': data, 'status': ok, 'message': message}), code

@ws_personal.route('/personal/register', methods=['POST'])
def crear_personal():
    data = request.get_json(silent=True) or {}

    DNI         = (data.get('DNI') or '').strip()
    nombre      = (data.get('nombre') or '').strip()
    ape_paterno = (data.get('ape_paterno') or '').strip()
    ape_materno = (data.get('ape_materno') or '').strip()
    email       = (data.get('email') or '').strip()
    clave       = (data.get('clave') or '').strip()          # ya hasheada si corresponde
    foto_perfil = (data.get('foto_perfil') or '').strip()
    telefono    = (data.get('telefono') or '').strip()
    ROLid       = data.get('ROLid')

    if not (DNI and len(DNI) == 8 and DNI.isdigit()):
        return _resp(None, False, 'DNI inválido (8 dígitos)', 400)
    for campo, val in [('nombre',nombre), ('ape_paterno',ape_paterno), ('ape_materno',ape_materno),
                       ('email',email), ('clave',clave), ('foto_perfil',foto_perfil)]:
        if not val:
            return _resp(None, False, f'Debe proporcionar {campo}', 400)
    if not (telefono and len(telefono) == 9 and telefono.isdigit()):
        return _resp(None, False, 'Teléfono inválido (9 dígitos)', 400)
    if ROLid is None:
        return _resp(None, False, 'Debe proporcionar ROLid', 400)

    mensaje = personal.registrar(DNI, nombre, ape_paterno, ape_materno, email, clave, foto_perfil, telefono, ROLid)
    if mensaje is None:
        return _resp(None, False, 'Error al registrar personal', 500)

    low = mensaje.lower()
    if low.startswith('personal insertado'):
        return _resp(None, True, mensaje, 201)
    if low == 'el dni ya existe':
        return _resp(None, False, mensaje, 409)
    if low == 'el rol no existe':
        return _resp(None, False, mensaje, 404)
    return _resp(None, False, mensaje, 400)

@ws_personal.route('/personal/<int:personal_id>', methods=['DELETE'])
def eliminar_personal(personal_id):
    mensaje = personal.eliminar(personal_id)
    if mensaje is None:
        return _resp(None, False, 'Error interno', 500)

    low = mensaje.lower()
    if low.startswith('personal eliminado'):
        return _resp(None, True, mensaje, 200)
    if low == 'el personal que intenta eliminar no existe':
        return _resp(None, False, mensaje, 404)
    return _resp(None, False, mensaje, 400)

@ws_personal.route('/personal/<int:personal_id>', methods=['PUT'])
def actualizar_personal(personal_id):
    data = request.get_json(silent=True) or {}

    DNI         = (data.get('DNI') or '').strip()
    nombre      = (data.get('nombre') or '').strip()
    ape_paterno = (data.get('ape_paterno') or '').strip()
    ape_materno = (data.get('ape_materno') or '').strip()
    email       = (data.get('email') or '').strip()
    clave       = (data.get('clave') or '').strip()
    foto_perfil = (data.get('foto_perfil') or '').strip()
    telefono    = (data.get('telefono') or '').strip()
    ROLid       = data.get('ROLid')
    estado      = data.get('estado')

    if not (DNI and len(DNI) == 8 and DNI.isdigit()):
        return _resp(None, False, 'DNI inválido (8 dígitos)', 400)
    for campo, val in [('nombre',nombre), ('ape_paterno',ape_paterno), ('ape_materno',ape_materno),
                       ('email',email), ('clave',clave), ('foto_perfil',foto_perfil)]:
        if not val:
            return _resp(None, False, f'Debe proporcionar {campo}', 400)
    if not (telefono and len(telefono) == 9 and telefono.isdigit()):
        return _resp(None, False, 'Teléfono inválido (9 dígitos)', 400)
    if ROLid is None:
        return _resp(None, False, 'Debe proporcionar ROLid', 400)
    if estado is None:
        return _resp(None, False, 'Debe proporcionar estado (true/false)', 400)

    mensaje = personal.actualizar(personal_id, DNI, nombre, ape_paterno, ape_materno, email, clave, foto_perfil, telefono, ROLid, bool(estado))
    if mensaje is None:
        return _resp(None, False, 'Error interno', 500)

    low = mensaje.lower()
    if low.startswith('el personal ha sido actualizado correctamente'):
        return _resp(None, True, mensaje, 200)
    if low == 'el personal que intenta actualizar no existe':
        return _resp(None, False, mensaje, 404)
    if low == 'el rol no existe':
        return _resp(None, False, mensaje, 404)
    return _resp(None, False, mensaje, 400)

@ws_personal.route('/personal/<int:personal_id>/baja', methods=['PATCH'])
def dar_baja_personal(personal_id):
    mensaje = personal.dar_de_baja(personal_id)
    if mensaje is None:
        return _resp(None, False, 'Error interno', 500)

    low = mensaje.lower()
    if low.startswith('el personal se dio de baja correctamente'):
        return _resp(None, True, mensaje, 200)
    if low == 'el personal ya se encuentra dado de baja':
        return _resp(None, False, mensaje, 409)
    if low == 'el personal que intenta dar de baja no existe':
        return _resp(None, False, mensaje, 404)
    return _resp(None, False, mensaje, 400)

@ws_personal.route('/loginPersonal', methods=['POST'])
def login_personal():
    try:
        data = request.get_json(silent=True) or {}
        
        email = data.get('email', '').strip()
        password = data.get('password', '').strip()
        
        if not email or not password:
            return _resp(None, False, 'Email y contraseña son requeridos', 400)
        
        usuario = personal.login(email, password)
        
        if usuario:
            # Generar token JWT
            token = generar_token({
                'id': usuario['id'],
                'email': usuario['email'],
                'nombre': usuario['nombre']
            })
            
            return jsonify({
                'status': True,
                'message': 'Login exitoso',
                'token': token,
                'data': {
                    'id': usuario['id'],
                    'nombre': usuario['nombre'],
                    'email': usuario['email']
                },
                'redirect': '/dashboard'
            }), 200
        else:
            return _resp(None, False, 'Correo o contraseña incorrectos', 401)
            
    except Exception as e:
        print(f"Error en login: {e}")
        return _resp(None, False, 'Error interno del servidor', 500)
