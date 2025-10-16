from conexionBD import Conexion

class Medico:
    def __init__(self):
        self.db = Conexion().open

    def registrar(self, nombres, ape_paterno, ape_materno, dni, email, telefono, id_personal_validado):
        """
        Registra un nuevo médico en la base de datos.
        """
        try:
            # Se asume que el estado inicial es 'A' (Activo)
            estado = 'A'
            sql = "INSERT INTO MEDICO (nombres, ape_paterno, ape_materno, DNI, email, telefono, estado, id_personal_validado) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
            self.db.execute(sql, (nombres, ape_paterno, ape_materno, dni, email, telefono, estado, id_personal_validado))
            return self.db.last_row_id()
        except Exception as e:
            print(f"Error al registrar médico: {e}")
            return None

    def actualizar(self, id, nombres, ape_paterno, ape_materno, dni, email, telefono):
        """
        Actualiza los datos de un médico existente.
        """
        try:
            sql = "UPDATE MEDICO SET nombres=%s, ape_paterno=%s, ape_materno=%s, DNI=%s, email=%s, telefono=%s WHERE id=%s"
            self.db.execute(sql, (nombres, ape_paterno, ape_materno, dni, email, telefono, id))
            return True
        except Exception as e:
            print(f"Error al actualizar médico: {e}")
            return False

    def darbaja(self, id):
        """
        Cambia el estado de un médico a 'I' (Inactivo).
        """
        try:
            sql = "UPDATE MEDICO SET estado='I' WHERE id=%s"
            self.db.execute(sql, (id,))
            return True
        except Exception as e:
            print(f"Error al dar de baja al médico: {e}")
            return False
            
    def validar_existente(self, email, dni):
        """
        Valida que el email y el DNI no existan en la base de datos.
        """
        try:
            # Validar si el email ya existe
            sql_email = "SELECT id FROM MEDICO WHERE email = %s"
            self.db.execute(sql_email, (email,))
            if self.db.fetchone():
                return False, "El correo electrónico ya está en uso."

            # Validar si el DNI ya existe
            sql_dni = "SELECT id FROM MEDICO WHERE DNI = %s"
            self.db.execute(sql_dni, (dni,))
            if self.db.fetchone():
                return False, "El DNI ya está registrado."

            return True, ""
        except Exception as e:
            return False, str(e)


    def obtener_foto(self, id):
        """
        Obtiene el nombre del archivo de la foto de un médico.
        """
        try:
            sql = "SELECT foto FROM MEDICO WHERE id = %s"
            self.db.execute(sql, (id,))
            return self.db.fetchone()
        except Exception as e:
            print(f"Error al obtener la foto del médico: {e}")
            return None

    def actualizarfoto(self, nombre_foto, id):
        """
        Actualiza la foto de un médico.
        """
        try:
            sql = "UPDATE MEDICO SET foto = %s WHERE id = %s"
            self.db.execute(sql, (nombre_foto, id))
            return True, "Foto actualizada correctamente."
        except Exception as e:
            print(f"Error al actualizar la foto del médico: {e}")
            return False, str(e)