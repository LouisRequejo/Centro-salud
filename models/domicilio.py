from conexionBD import Conexion

class Domicilio:
    def __init__(self):
        pass

    # ----- INSERTAR -----
    def registrar(self, nombre, direccion, paciente_id):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()

            sql = "CALL InsertarDomicilio(%s, %s, %s)"
            cursor.execute(sql, (nombre, direccion, paciente_id))

            rows = cursor.fetchall()
            mensaje = rows[0]['mensaje'] if rows else None

            # Drenar cualquier conjunto de resultados restante
            while cursor.nextset():
                cursor.fetchall()

            con.commit()
            return mensaje or "El procedimiento no devolvió un mensaje."
        except Exception as e:
            print("ERROR registrar():", e)
            try:
                if cursor:
                    while cursor.nextset():
                        cursor.fetchall()
            except Exception:
                pass
            if con:
                con.rollback()
            return None
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()

    # ----- ELIMINAR -----
    def eliminar(self, domicilio_id):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()

            sql = "CALL EliminarDomicilio(%s)"
            cursor.execute(sql, (domicilio_id,))

            rows = cursor.fetchall()
            mensaje = rows[0]['mensaje'] if rows else None

            while cursor.nextset():
                cursor.fetchall()

            con.commit()
            return mensaje or "El procedimiento no devolvió un mensaje."
        except Exception as e:
            print("ERROR eliminar():", e)
            try:
                if cursor:
                    while cursor.nextset():
                        cursor.fetchall()
            except Exception:
                pass
            if con:
                con.rollback()
            return None
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()

    # ----- ACTUALIZAR -----
    def actualizar(self, domicilio_id, nombre, direccion):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()

            sql = "CALL ActualizarDomicilio(%s, %s, %s)"
            cursor.execute(sql, (domicilio_id, nombre, direccion))

            rows = cursor.fetchall()
            mensaje = rows[0]['mensaje'] if rows else None

            while cursor.nextset():
                cursor.fetchall()

            con.commit()
            return mensaje or "El procedimiento no devolvió un mensaje."
        except Exception as e:
            print("ERROR actualizar():", e)
            try:
                if cursor:
                    while cursor.nextset():
                        cursor.fetchall()
            except Exception:
                pass
            if con:
                con.rollback()
            return None
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()
