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
        print("=" * 60)
        print("[DEBUG] ========== INICIO LOGIN PACIENTE ==========")
        print(f"[DEBUG] 1. Email recibido: '{email}'")
        print(f"[DEBUG] 2. Clave recibida: '{clave}'")
        print(f"[DEBUG] 3. Longitud clave: {len(clave)} caracteres")
        
        con = None
        cursor = None
        try:
            print("[DEBUG] 4. Abriendo conexión a BD...")
            con = Conexion().open
            cursor = con.cursor()
            print("[DEBUG] 5. Conexión establecida")
            
            sql = "SELECT id, concat(nombres, ' ', ape_paterno, ' ', ape_materno) as nombre, email, clave FROM PACIENTE WHERE email = %s"
            print(f"[DEBUG] 6. Ejecutando query con email: {email}")
            cursor.execute(sql, (email,))
            
            result = cursor.fetchone()
            print(f"[DEBUG] 7. Resultado de query: {result is not None}")
            
            if result:
                print(f"[DEBUG] 8. Usuario encontrado - ID: {result['id']}, Nombre: {result['nombre']}")
                print(f"[DEBUG] 9. Hash almacenado en BD:")
                print(f"[DEBUG]    {result['clave'][:50]}..." if len(result['clave']) > 50 else f"[DEBUG]    {result['clave']}")
                print(f"[DEBUG] 10. Longitud del hash: {len(result['clave'])} caracteres")
                
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
                    print(f"[DEBUG] 12. ❌ Error al verificar contraseña: {str(e)}")
                    print("[DEBUG] 13. La contraseña no coincide con el hash")
                    return None
                except Exception as e:
                    print(f"[DEBUG] 12. ❌ Error inesperado en verificación: {type(e).__name__} - {str(e)}")
                    return None
            else:
                print("[DEBUG] 8. ❌ Usuario NO encontrado en la base de datos")
                print(f"[DEBUG] 9. Verificar que el email '{email}' existe en la tabla PACIENTE")
                return None
        except Exception as e:
            print(f"[ERROR] Exception general en login(): {type(e).__name__} - {str(e)}")
            import traceback
            traceback.print_exc()
            return None
        finally:
            if cursor:
                cursor.close()
                print("[DEBUG] Cursor cerrado")
            if con:
                con.close()
                print("[DEBUG] Conexión cerrada")
            print("[DEBUG] ========== FIN LOGIN PACIENTE ==========")
            print("=" * 60)
        
