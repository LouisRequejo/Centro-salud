# models/personal.py
from conexionBD import Conexion
from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError

class Paciente:
    def __init__(self):
        self.ph = PasswordHasher()

def login(self, email, clave):
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            sql = "SELECT id, concat(nombre, ' ', ape_paterno, ' ', ape_materno) as nombre, email, clave, estado FROM PACIENTE WHERE email = %s"
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
        
