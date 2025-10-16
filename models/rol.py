from conexionBD import Conexion

class Rol:
    def __init__(self):
        pass

    def registrar(self, nombre):
            con = None
            cursor = None
            try:
                # Asegúrate que .open sea un MÉTODO que retorna la conexión
                con = Conexion().open   # <-- paréntesis
                cursor = con.cursor()

                cursor.execute("CALL InsertarRol(%s)", (nombre,))

                # Lee el primer result set (tu SELECT '... AS mensaje')
                rows = cursor.fetchall()
                mensaje = rows[0]["mensaje"] if rows else None

                # Drena cualquier result set adicional que deje el CALL
                while cursor.nextset():
                    cursor.fetchall()

                con.commit()
                return mensaje  # devuelve el mensaje del SP

            except Exception as e:
                # Intenta drenar antes de hacer rollback, para evitar el 2014
                try:
                    if cursor:
                        while cursor.nextset():
                            cursor.fetchall()
                except Exception:
                    pass
                if con:
                    con.rollback()
                # Loguea y propaga o devuelve None según tu estilo
                print("EL VERDADERO ERROR ES:", e)
                return None

            finally:
                if cursor:
                    cursor.close()
                if con:
                    con.close()