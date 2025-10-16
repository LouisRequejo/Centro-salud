from conexionBD import Conexion

class Rol:
    def __init__(self):
        pass

    def registrar(self, nombre):
        con = None  # Inicializa las variables fuera del 'try'
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            sql = "CALL InsertarRol(%s)"
            
            cursor.execute(sql, (nombre,))
            
            # 1. Lee el resultado PRIMERO
            resultado_tupla = cursor.fetchone()
            
            # 2. Guarda los cambios
            con.commit()
            
            # 3. Limpia el cursor para sincronizar
            cursor.nextset()
            
            # 4. Devuelve el resultado de forma SEGURA
            if resultado_tupla:
                return resultado_tupla[0]
            else:
                # Esto puede pasar si el procedimiento no devuelve nada
                return "El procedimiento no devolvió un mensaje."

        except Exception as e:
            print("EL VERDADERO ERROR ES:", e) # Esto te mostrará el TypeError
            if con:
                con.rollback()
            return None
        finally:
            # 5. Cierra todo en el orden correcto
            # ¡Siempre el cursor ANTES que la conexión!
            if cursor:
                cursor.close()
            if con:
                con.close()