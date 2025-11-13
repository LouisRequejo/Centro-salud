from conexionBD import Conexion
import qrcode
import os
from datetime import datetime

class Cita:
    def __init__(self):
        self.qr_directory = os.path.join('static', 'qr')
        os.makedirs(self.qr_directory, exist_ok=True)

    def _generar_codigo_qr(self, cita_id, paciente_id, turno_id):
        try:
            # Contenido del QR: información de la cita en formato JSON
            qr_data = f"CITA_ID:{cita_id}|PACIENTE:{paciente_id}|TURNO:{turno_id}|FECHA:{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
            
            qr = qrcode.QRCode(
                version=1,
                error_correction=qrcode.constants.ERROR_CORRECT_L,
                box_size=10,
                border=4,
            )
            qr.add_data(qr_data)
            qr.make(fit=True)
            
            img = qr.make_image(fill_color="black", back_color="white")
            
            filename = f"qr_cita_{cita_id}.png"
            filepath = os.path.join(self.qr_directory, filename)
            
            img.save(filepath)
            
            # Retornar la ruta relativa para guardar en BD
            return f"qr/{filename}"
            
        except Exception as e:
            print(f"Error al generar código QR: {e}")
            return None

    def reservar_cita(self, paciente_id, tipo_atencion, direccion_domicilio, turno_id):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            
            con.begin()
            
            sql_verificar = "SELECT estado FROM TURNO WHERE id = %s FOR UPDATE"
            cursor.execute(sql_verificar, (turno_id,))
            resultado = cursor.fetchone()
            
            if not resultado:
                con.rollback()
                return False, "El turno no existe"
            
            estado_turno = resultado['estado']
            
            if estado_turno != 'D':
                con.rollback()
                return False, "El turno no está disponible"
            
            sql_actualizar_turno = "UPDATE TURNO SET estado = 'O' WHERE id = %s"
            cursor.execute(sql_actualizar_turno, (turno_id,))
            
            sql_insertar_cita = """
                INSERT INTO CITA 
                (id_paciente, tipo_atencion, direccion_domicilio, estado, codigo_qr, fecha_creacion, TURNOid) 
                VALUES (%s, %s, %s, 'P', '', NOW(), %s)
            """
            cursor.execute(sql_insertar_cita, (
                paciente_id, 
                tipo_atencion, 
                direccion_domicilio, 
                turno_id
            ))
            
            cita_id = cursor.lastrowid
            
            qr_ruta = self._generar_codigo_qr(cita_id, paciente_id, turno_id)
            
            if not qr_ruta:
                con.rollback()
                return False, "Error al generar el código QR"
            
            sql_actualizar_qr = "UPDATE CITA SET codigo_qr = %s WHERE id = %s"
            cursor.execute(sql_actualizar_qr, (qr_ruta, cita_id))
            
            con.commit()
            return True, cita_id
            
        except Exception as e:
            print(f"Error al reservar cita: {e}")
            if con:
                con.rollback()
            return False, f"Error del sistema: {str(e)}"
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()

    def obtener_cita_detalle(self, cita_id):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            
            sql = """
                SELECT 
                    c.id,
                    c.tipo_atencion,
                    c.direccion_domicilio,
                    c.estado,
                    c.codigo_qr,
                    c.fecha_creacion,
                    c.id_paciente,
                    t.hora_inicio,
                    t.hora_fin,
                    h.fecha,
                    h.dia_semana,
                    m.id as medico_id,
                    m.nombres as medico_nombres,
                    m.ape_paterno as medico_ape_paterno,
                    m.ape_materno as medico_ape_materno,
                    m.email as medico_email,
                    m.telefono as medico_telefono,
                    e.id as especialidad_id,
                    e.nombre as especialidad,
                    CONCAT(p_pac.nombres, ' ', p_pac.ape_paterno, ' ', p_pac.ape_materno) as paciente_completo,
                    p_pac.DNI as paciente_dni,
                    p_pac.email as paciente_email,
                    p_pac.telefono as paciente_telefono,
                    cons.id as consultorio_id,
                    cons.nombre as consultorio_nombre,
                    cs.id as centro_salud_id,
                    cs.nombre as centro_salud_nombre,
                    cs.direccion as centro_salud_direccion,
                    cs.telefono as centro_salud_telefono
                FROM CITA c
                INNER JOIN TURNO t ON c.TURNOid = t.id
                INNER JOIN HORARIO h ON t.HORARIOid = h.id
                INNER JOIN PROGRAMACION p ON h.PROGRAMACIONid = p.id
                INNER JOIN MEDICO m ON p.MEDICOid = m.id
                INNER JOIN ESPECIALIDAD e ON p.ESPECIALIDADid = e.id
                INNER JOIN PACIENTE p_pac ON c.id_paciente = p_pac.id
                INNER JOIN CONSULTORIO cons ON p.CONSULTORIOid = cons.id
                INNER JOIN CENTRO_SALUD cs ON cons.id_centro_salud = cs.id
                WHERE c.id = %s
            """
            cursor.execute(sql, (cita_id,))
            resultado = cursor.fetchone()
            
            return resultado
            
        except Exception as e:
            return False, f"Error al obtener detalle de la cita: {str(e)}"
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()
                
                
def listar_todas_citas_web():
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            
            sql = """
            SELECT 
                C.id,
                C.tipo_atencion,
                C.direccion_domicilio,
                C.estado,
                C.codigo_qr,
                C.fecha_creacion,
                H.fecha,
                T.hora_inicio,
                P.nombres AS paciente_nombres,
                P.ape_paterno AS paciente_ape_paterno,
                P.ape_materno AS paciente_ape_materno,
                M.nombres AS medico_nombres,
                M.ape_paterno AS medico_ape_paterno,
                M.ape_materno AS medico_ape_materno,
                E.nombre AS especialidad
            FROM CITA C
            INNER JOIN PACIENTE P ON C.id_paciente = P.id
            INNER JOIN TURNO T ON C.TURNOid = T.id
            INNER JOIN HORARIO H ON T.HORARIOid = H.id
            INNER JOIN PROGRAMACION PR ON H.PROGRAMACIONid = PR.id
            INNER JOIN MEDICO M ON PR.MEDICOid = M.id
            INNER JOIN ESPECIALIDAD E ON PR.ESPECIALIDADid = E.id
            ORDER BY H.fecha, T.hora_inicio
            """
            cursor.execute(sql)
            resultado = cursor.fetchall()
            
            citas = []
            for row in resultado:
                cita = {
                    'id': row['id'],
                    'tipo_atencion': row['tipo_atencion'],
                    'direccion_domicilio': row['direccion_domicilio'],
                    'estado': row['estado'],
                    'codigo_qr': row['codigo_qr'],
                    'fecha_creacion': row['fecha_creacion'],
                    'fecha': row['fecha'],
                    'hora_inicio': row['hora_inicio'],
                    'paciente_nombres': row['paciente_nombres'],
                    'paciente_ape_paterno': row['paciente_ape_paterno'],
                    'paciente_ape_materno': row['paciente_ape_materno'],
                    'medico_nombres': row['medico_nombres'],
                    'medico_ape_paterno': row['medico_ape_paterno'],
                    'medico_ape_materno': row['medico_ape_materno'],
                    'especialidad': row['especialidad']
                }
                citas.append(cita)
            
            return citas
        except Exception as e:
            print(f"Error al listar citas: {e}")
            return []
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()
                
                
def filtrar_citas(medico_id=None, especialidad_id=None, estado=None, fecha=None):
    """
    Filtra las citas según los criterios proporcionados
    
    Args:
        medico_id: ID del médico (None para todos)
        especialidad_id: ID de la especialidad (None para todas)
        estado: Estado de la cita ('A', 'P', 'C' o None para todos)
        fecha: Fecha en formato 'YYYY-MM-DD' (None para todas)
    
    Returns:
        Lista de citas filtradas
    """
    con = None
    cursor = None
    try:
        con = Conexion().open
        cursor = con.cursor()
        
        # Query base
        sql = """
        SELECT 
            C.id,
            C.tipo_atencion,
            C.direccion_domicilio,
            C.estado,
            C.codigo_qr,
            C.fecha_creacion,
            H.fecha,
            T.hora_inicio,
            P.nombres AS paciente_nombres,
            P.ape_paterno AS paciente_ape_paterno,
            P.ape_materno AS paciente_ape_materno,
            M.id AS medico_id,
            M.nombres AS medico_nombres,
            M.ape_paterno AS medico_ape_paterno,
            M.ape_materno AS medico_ape_materno,
            E.id AS especialidad_id,
            E.nombre AS especialidad
        FROM CITA C
        INNER JOIN PACIENTE P ON C.id_paciente = P.id
        INNER JOIN TURNO T ON C.TURNOid = T.id
        INNER JOIN HORARIO H ON T.HORARIOid = H.id
        INNER JOIN PROGRAMACION PR ON H.PROGRAMACIONid = PR.id
        INNER JOIN MEDICO M ON PR.MEDICOid = M.id
        INNER JOIN ESPECIALIDAD E ON PR.ESPECIALIDADid = E.id
        WHERE 1=1
        """
        
        # Lista para los parámetros
        params = []
        
        # Agregar filtros dinámicamente
        if medico_id and medico_id != 'all':
            sql += " AND M.id = %s"
            params.append(medico_id)
        
        if especialidad_id and especialidad_id != 'all':
            sql += " AND E.id = %s"
            params.append(especialidad_id)
        
        if estado and estado != 'all':
            # Mapear estados desde el filtro al valor en BD
            estado_map = {
                'confirmado': 'A',
                'pendiente': 'P',
                'cancelado': 'C'
            }
            estado_bd = estado_map.get(estado.lower(), estado)
            sql += " AND C.estado = %s"
            params.append(estado_bd)
        
        if fecha:
            sql += " AND H.fecha = %s"
            params.append(fecha)
        
        # Ordenar resultados
        sql += " ORDER BY H.fecha, T.hora_inicio"
        
        cursor.execute(sql, tuple(params))
        resultado = cursor.fetchall()
        
        citas = []
        for row in resultado:
            cita = {
                'id': row['id'],
                'tipo_atencion': row['tipo_atencion'],
                'direccion_domicilio': row['direccion_domicilio'],
                'estado': row['estado'],
                'codigo_qr': row['codigo_qr'],
                'fecha_creacion': row['fecha_creacion'],
                'fecha': row['fecha'].strftime('%Y-%m-%d') if hasattr(row['fecha'], 'strftime') else str(row['fecha']),
                'hora_inicio': str(row['hora_inicio']),
                'paciente_nombres': row['paciente_nombres'],
                'paciente_ape_paterno': row['paciente_ape_paterno'],
                'paciente_ape_materno': row['paciente_ape_materno'],
                'medico_id': row['medico_id'],
                'medico_nombres': row['medico_nombres'],
                'medico_ape_paterno': row['medico_ape_paterno'],
                'medico_ape_materno': row['medico_ape_materno'],
                'especialidad_id': row['especialidad_id'],
                'especialidad': row['especialidad']
            }
            citas.append(cita)
        
        return citas
        
    except Exception as e:
        print(f"Error al filtrar citas: {e}")
        return []
    finally:
        if cursor:
            cursor.close()
        if con:
            con.close()


def obtener_estadisticas_citas(medico_id=None, especialidad_id=None, fecha_inicio=None, fecha_fin=None):
    """
    Obtiene estadísticas de las citas para el dashboard
    
    Returns:
        Diccionario con estadísticas
    """
    con = None
    cursor = None
    try:
        con = Conexion().open
        cursor = con.cursor()
        
        sql_base = """
        SELECT 
            COUNT(*) as total,
            SUM(CASE WHEN C.estado = 'A' THEN 1 ELSE 0 END) as confirmadas,
            SUM(CASE WHEN C.estado = 'P' THEN 1 ELSE 0 END) as pendientes,
            SUM(CASE WHEN C.estado = 'C' THEN 1 ELSE 0 END) as canceladas
        FROM CITA C
        INNER JOIN TURNO T ON C.TURNOid = T.id
        INNER JOIN HORARIO H ON T.HORARIOid = H.id
        INNER JOIN PROGRAMACION PR ON H.PROGRAMACIONid = PR.id
        WHERE 1=1
        """
        
        params = []
        
        if medico_id and medico_id != 'all':
            sql_base += " AND PR.MEDICOid = %s"
            params.append(medico_id)
        
        if especialidad_id and especialidad_id != 'all':
            sql_base += " AND PR.ESPECIALIDADid = %s"
            params.append(especialidad_id)
        
        if fecha_inicio:
            sql_base += " AND H.fecha >= %s"
            params.append(fecha_inicio)
        
        if fecha_fin:
            sql_base += " AND H.fecha <= %s"
            params.append(fecha_fin)
        
        cursor.execute(sql_base, tuple(params))
        resultado = cursor.fetchone()
        
        return {
            'total': resultado['total'] or 0,
            'confirmadas': resultado['confirmadas'] or 0,
            'pendientes': resultado['pendientes'] or 0,
            'canceladas': resultado['canceladas'] or 0
        }
        
    except Exception as e:
        print(f"Error al obtener estadísticas: {e}")
        return {
            'total': 0,
            'confirmadas': 0,
            'pendientes': 0,
            'canceladas': 0
        }
    finally:
        if cursor:
            cursor.close()
        if con:
            con.close()