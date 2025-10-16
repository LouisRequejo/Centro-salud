# models/personal.py
from conexionBD import Conexion

class Personal:
    def __init__(self):
        pass

    # ----- INSERTAR -----
    def registrar(self, DNI, nombre, ape_paterno, ape_materno, email, clave, foto_perfil, telefono, ROLid):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()

            sql = "CALL insertarPersonal(%s,%s,%s,%s,%s,%s,%s,%s,%s)"
            params = (DNI, nombre, ape_paterno, ape_materno, email, clave, foto_perfil, telefono, ROLid)
            cursor.execute(sql, params)

            rows = cursor.fetchall()
            mensaje = rows[0]['mensaje'] if rows else None

            while cursor.nextset():
                cursor.fetchall()

            con.commit()
            return mensaje
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
    def eliminar(self, personal_id):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()

            sql = "CALL EliminarPersonal(%s)"
            cursor.execute(sql, (personal_id,))

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
    def actualizar(self, personal_id, DNI, nombre, ape_paterno, ape_materno, email, clave, foto_perfil, telefono, ROLid, estado):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()  # <- OJO: con paréntesis (tu modelo Rol tenía un pequeño bug aquí)

            sql = "CALL ActualizarPersonal(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
            params = (personal_id, DNI, nombre, ape_paterno, ape_materno, email, clave, foto_perfil, telefono, ROLid, estado)
            cursor.execute(sql, params)

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

    # ----- DAR DE BAJA -----
    def dar_de_baja(self, personal_id):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()

            sql = "CALL DarDeBajaPersonal(%s)"
            cursor.execute(sql, (personal_id,))

            rows = cursor.fetchall()
            mensaje = rows[0]['mensaje'] if rows else None

            while cursor.nextset():
                cursor.fetchall()

            con.commit()
            return mensaje or "El procedimiento no devolvió un mensaje."
        except Exception as e:
            print("ERROR dar_de_baja():", e)
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
