from conexionBD import Conexion

class Rol:
    def __init__(self):
        pass

    def registrar(self, nombre):
        con = Conexion().open
        cursor = con.cursor()
        sql = "CALL InsertarRol(%s)"
        try:
            cursor.execute(sql, (nombre,))
            con.commit()
            cursor.nextset()
            resultado_tupla = cursor.fetchone()        
            return resultado_tupla[0] if resultado_tupla else None
        except Exception as e:
            con.rollback()
            return None
        finally:
            con.close()