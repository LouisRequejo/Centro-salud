# models/personal.py
from conexionBD import Conexion
from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError

class Personal:
    def __init__(self):
        self.ph = PasswordHasher()

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
    
    def login(self, email, clave):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            sql = "SELECT id, concat(nombre, ' ', ape_paterno, ' ', ape_materno) as nombre, email, clave, estado FROM PERSONAL WHERE email = %s"
            cursor.execute(sql, (email,))
            
            result = cursor.fetchone()
            
            if result:
                # Verificar si el usuario está activo
                if result['estado'] == 0:
                    return None
                
                # Verificar la contraseña
                try:
                    self.ph.verify(result['clave'], clave)
                    return {
                        'id': result['id'],
                        'nombre': result['nombre'],
                        'email': result['email']
                    }
                except VerifyMismatchError:
                    return None
            else:
                return None
        except Exception as e:
            print("ERROR login():", e)
            return None
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()
        
