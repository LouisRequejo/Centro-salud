from conexionBD import Conexion

class Especialidad:
    def __init__(self):
        self.db = Conexion()

    def registrar(self, nombre, descripcion):
        """
        Registra una nueva especialidad en la base de datos.
        """
        try:
            sql = "INSERT INTO ESPECIALIDAD (nombre, descripcion) VALUES (%s, %s)"
            self.db.execute(sql, (nombre, descripcion))
            return self.db.last_row_id()
        except Exception as e:
            print(f"Error al registrar especialidad: {e}")
            return None
        
    def actualizar(self, id, nombre, descripcion):
        """
        Actualiza los datos de una especialidad existente.
        """
        try:
            sql = "UPDATE ESPECIALIDAD SET nombre=%s, descripcion=%s WHERE id=%s"
            self.db.execute(sql, (nombre, descripcion, id))
            return True
        except Exception as e:
            print(f"Error al actualizar especialidad: {e}")
            return False

    def darbaja (self, id):
        """
        Cambia el estado de una especialidad a 'I' (Inactivo).
        """
        try:
            sql = "UPDATE ESPECIALIDAD SET estado='I' WHERE id=%s"
            self.db.execute(sql, (id,))
            return True
        except Exception as e:
            print(f"Error al dar de baja la especialidad: {e}")
            return False
        
    def validar_existente(self, nombre):
        """
        Valida que el nombre de la especialidad no exista en la base de datos.
        """
        try:
            sql_nombre = "SELECT id FROM ESPECIALIDAD WHERE nombre = %s"
            self.db.execute(sql_nombre, (nombre,))
            if self.db.fetchone():
                return False, "El nombre de la especialidad ya está en uso."
            return True, ""
        except Exception as e:
            print(f"Error al validar especialidad: {e}")
            return False, "Error al validar especialidad."
    
    def listar(self):
        """
        Lista todas las especialidades activas.
        """
        try:
            sql = "SELECT id, nombre, descripcion FROM ESPECIALIDAD WHERE estado='A'"
            self.db.execute(sql)
            return self.db.fetchall()
        except Exception as e:
            print(f"Error al listar especialidades: {e}")
            return []





        
