from conexionBD import Conexion

class Medico:
    def __init__(self):
        pass

    def registrar(self, nombres, ape_paterno, ape_materno, dni, email, telefono, id_personal_validado):
        """
        Registra un nuevo médico en la base de datos.
        """
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            
            # Se asume que el estado inicial es 'A' (Activo)
            estado = 'A'
            sql = "INSERT INTO MEDICO (nombres, ape_paterno, ape_materno, DNI, email, telefono, estado, id_personal_validado) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
            cursor.execute(sql, (nombres, ape_paterno, ape_materno, dni, email, telefono, estado, id_personal_validado))
            con.commit()
            
            medico_id = cursor.lastrowid
            return medico_id
        except Exception as e:
            print(f"Error al registrar médico: {e}")
            if con:
                con.rollback()
            return None
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()

    def actualizar(self, id, nombres, ape_paterno, ape_materno, dni, email, telefono):
        """
        Actualiza los datos de un médico existente.
        """
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            
            sql = "UPDATE MEDICO SET nombres=%s, ape_paterno=%s, ape_materno=%s, DNI=%s, email=%s, telefono=%s WHERE id=%s"
            cursor.execute(sql, (nombres, ape_paterno, ape_materno, dni, email, telefono, id))
            con.commit()
            return True
        except Exception as e:
            print(f"Error al actualizar médico: {e}")
            if con:
                con.rollback()
            return False
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()

    def darbaja(self, id):
        """
        Cambia el estado de un médico a 'I' (Inactivo).
        """
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            
            sql = "UPDATE MEDICO SET estado='I' WHERE id=%s"
            cursor.execute(sql, (id,))
            con.commit()
            return True
        except Exception as e:
            print(f"Error al dar de baja al médico: {e}")
            if con:
                con.rollback()
            return False
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()
            
    def validar_existente(self, email, dni):
        """
        Valida que el email y el DNI no existan en la base de datos.
        """
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            
            # Validar si el email ya existe
            sql_email = "SELECT id FROM MEDICO WHERE email = %s"
            cursor.execute(sql_email, (email,))
            if cursor.fetchone():
                return False, "El correo electrónico ya está en uso."

            # Validar si el DNI ya existe
            sql_dni = "SELECT id FROM MEDICO WHERE DNI = %s"
            cursor.execute(sql_dni, (dni,))
            if cursor.fetchone():
                return False, "El DNI ya está registrado."

            return True, ""
        except Exception as e:
            return False, str(e)
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()

    def obtener_foto(self, id):
        """
        Obtiene el nombre del archivo de la foto de un médico.
        """
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            
            sql = "SELECT foto FROM MEDICO WHERE id = %s"
            cursor.execute(sql, (id,))
            result = cursor.fetchone()
            return result
        except Exception as e:
            print(f"Error al obtener la foto del médico: {e}")
            return None
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()

    def actualizarfoto(self, nombre_foto, id):
        """
        Actualiza la foto de un médico.
        """
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            
            sql = "UPDATE MEDICO SET foto = %s WHERE id = %s"
            cursor.execute(sql, (nombre_foto, id))
            con.commit()
            return True, "Foto actualizada correctamente."
        except Exception as e:
            print(f"Error al actualizar la foto del médico: {e}")
            if con:
                con.rollback()
            return False, str(e)
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()
        
    def listar_todos(self):
        """
        Lista todos los médicos activos con sus especialidades.
        """
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            
            sql = """
            SELECT DISTINCT
                M.id,
                M.nombres,
                M.ape_paterno,
                M.ape_materno,
                M.DNI,
                M.email,
                M.telefono,
                M.estado,
                M.id_personal_validado,
                E.nombre AS especialidad
            FROM MEDICO M
            LEFT JOIN PROGRAMACION P ON M.id = P.MEDICOid
            LEFT JOIN ESPECIALIDAD E ON P.ESPECIALIDADid = E.id
            WHERE M.estado != 'I'
            ORDER BY M.nombres, M.ape_paterno
            """
            cursor.execute(sql)
            resultado = cursor.fetchall()
            
            medicos = []
            for row in resultado:
                medico = {
                    'id': row['id'],
                    'nombres': row['nombres'],
                    'ape_paterno': row['ape_paterno'],
                    'ape_materno': row['ape_materno'],
                    'DNI': row['DNI'],
                    'email': row['email'],
                    'telefono': row['telefono'],
                    'estado': row['estado'],
                    'id_personal_validado': row['id_personal_validado'],
                    'especialidad': row['especialidad'] if row['especialidad'] else 'Sin Especialidad'
                }
                medicos.append(medico)
            
            return medicos
        except Exception as e:
            print(f"Error al listar médicos: {e}")
            return []
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()