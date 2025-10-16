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
            resultado = cursor.fetchone()
            return resultado
        except Exception as e:
            print("Error:", e)
        finally:
            con.close()