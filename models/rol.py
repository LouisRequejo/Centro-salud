from conexionBD import Conexion

class Rol:
    def __init__(self):
        pass

    def registrar(self, nombre):
        con = None  # Inicializamos las variables fuera del 'try' para que existan en el 'finally'
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            sql = "CALL InsertarRol(%s)"
            
            cursor.execute(sql, (nombre,))
            
            # 1. Lee el resultado del SELECT que devuelve el procedimiento
            resultado_tupla = cursor.fetchone()
            
            # 2. Guarda los cambios permanentemente en la base de datos
            con.commit()
            
            # 3. Limpia cualquier otro resultado pendiente para sincronizar la conexión
            cursor.nextset()
            
            # 4. Devuelve el mensaje de forma segura
            if resultado_tupla:
                return resultado_tupla[0]
            else:
                return "El procedimiento no devolvió un mensaje." # O puedes devolver None

        except Exception as e:
            print("Error en registrar rol:", e) # Esto imprimirá el TypeError si ocurre
            if con:
                con.rollback() # Deshace los cambios si algo falló
            return None
        finally:
            # 5. Cierra todo en el orden correcto y de forma segura
            # ¡Siempre cierra el cursor ANTES que la conexión!
            if cursor:
                cursor.close()
            if con:
                con.close()
