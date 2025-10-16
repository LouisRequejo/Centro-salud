from conexionBD import Conexion

class Rol:
    def __init__(self):
        pass

    def registrar(self, nombre):
            con = None
            cursor = None
            try:
                con = Conexion().open 
                cursor = con.cursor()

                cursor.execute("CALL InsertarRol(%s)", (nombre,))

                rows = cursor.fetchall()
                mensaje = rows[0]["mensaje"] if rows else None

                while cursor.nextset():
                    cursor.fetchall()

                con.commit()
                return mensaje  

            except Exception as e:
                try:
                    if cursor:
                        while cursor.nextset():
                            cursor.fetchall()
                except Exception:
                    pass
                if con:
                    con.rollback()
                print("EL VERDADERO ERROR ES:", e)
                return None
            finally:
                if cursor:
                    cursor.close()
                if con:
                    con.close()

    def eliminar(self, rol_id):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()

            sql = "CALL EliminarRol(%s)"
            cursor.execute(sql, (rol_id,))

            # 1) Lee el primer result set (mensaje)
            rows = cursor.fetchall()
            mensaje = rows[0]['mensaje'] if rows else None

            # 2) Drena cualquier result set pendiente
            while cursor.nextset():
                cursor.fetchall()

            # 3) Commit
            con.commit()

            # 4) Devuelve mensaje seguro
            return mensaje or "El procedimiento no devolvió un mensaje."
        except Exception as e:
            print("ERROR eliminar():", e)
            # drenar antes de rollback para evitar 'Commands out of sync'
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
    def actualizar(self, rol_id, nombre):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()

            sql = "CALL ActualizarRol(%s, %s)"
            cursor.execute(sql, (rol_id, nombre))

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
    def dar_de_baja(self, rol_id):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()

            sql = "CALL DarDeBajaRol(%s)"
            cursor.execute(sql, (rol_id,))

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

    def listar(self):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()

            sql = "CALL ListarRoles()"
            cursor.execute(sql)

            rows = cursor.fetchall()
            roles = [{'id': row['id'], 'nombre': row['nombre'], 'estado': row['estado']} for row in rows]

            while cursor.nextset():
                cursor.fetchall()

            return roles
        except Exception as e:
            print("ERROR listar():", e)
            try:
                if cursor:
                    while cursor.nextset():
                        cursor.fetchall()
            except Exception:
                pass
            return None
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()