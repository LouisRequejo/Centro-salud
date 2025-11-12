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



