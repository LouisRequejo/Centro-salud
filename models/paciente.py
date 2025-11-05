# models/paciente.py
from conexionBD import Conexion
from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError

class Paciente:
    def __init__(self):
        self.ph = PasswordHasher()

    def listar_todos(self):
        """Lista todos los pacientes con su información básica"""
        con = None
        cursor = None
        try:
            con = Conexion().open
            cursor = con.cursor()
            
            sql = """
            SELECT 
                id, 
                DNI,
                concat(nombres, ' ', ape_paterno, ' ', ape_materno) as nombre_completo,
                nombres,
                ape_paterno,
                ape_materno,
                email,
                telefono,
                f_nacimiento
            FROM PACIENTE
            ORDER BY nombres, ape_paterno
            """
            cursor.execute(sql)
            resultado = cursor.fetchall()
            
            return resultado
        except Exception as e:
            print(f"Error al listar pacientes: {e}")
            return []
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
            sql = "SELECT id, concat(nombres, ' ', ape_paterno, ' ', ape_materno) as nombre, email, clave FROM PACIENTE WHERE email = %s"
            cursor.execute(sql, (email,))
            
            result = cursor.fetchone()
            
            if result:
                # Verificar la contraseña
                try:
                    print("[DEBUG] 11. Intentando verificar contraseña con Argon2...")
                    self.ph.verify(result['clave'], clave)
                    print("[DEBUG] 12. ✅ Contraseña verificada correctamente!")
                    return {
                        'id': result['id'],
                        'nombre': result['nombre'],
                        'email': result['email']
                    }
                except VerifyMismatchError as e:
                    return None
                except Exception as e:
                    return None
            else:
                return None
        except Exception as e:
            print(f"[ERROR] Exception general en login(): {type(e).__name__} - {str(e)}")
            import traceback
            traceback.print_exc()
            return None
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()
        
