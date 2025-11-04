from conexionBD import Conexion
import json

class Programacion:
    def __init__(self):
        pass

    def registrar(self, fecha_inicial, fecha_final, medico_id, consultorio_id, especialidad_id, detalle):
        """
        detalle: list[dict] con items como:
            {
              "dia_semana": "Lunes",
              "hora_inicial": "08:00:00",
              "hora_final": "18:00:00",
              "duracion_minutos": 60   # opcional (default en SP = 60)
            }
        Retorna (codigo, mensaje) donde:
            1 = éxito, -1 = error del usuario, 0 = error del sistema
        """
        con = None
        cursor = None
        try:
            # Conexión
            con = Conexion().open
            cursor = con.cursor()

            # El SP recibe JSON, lo convertimos a string
            detalle_json = json.dumps(detalle, ensure_ascii=False)

            # Llamada con parámetro OUT usando variable de sesión
            # CALL sp(..., @p_codigo)
            sql_call = """
                CALL sp_crear_programacion_y_horarios(
                    %s, %s, %s, %s, %s, %s, @p_codigo
                )
            """
            params = (
                fecha_inicial,      # DATE 'YYYY-MM-DD'
                fecha_final,        # DATE 'YYYY-MM-DD'
                medico_id,
                consultorio_id,
                especialidad_id,
                detalle_json
            )
            cursor.execute(sql_call, params)

            # Consumir posibles resultsets residuales del CALL
            try:
                while cursor.nextset():
                    cursor.fetchall()
            except Exception:
                pass

            # Recuperar el OUT
            cursor.execute("SELECT @p_codigo AS codigo;")
            row = cursor.fetchone()
            codigo = (row.get("codigo") if isinstance(row, dict) else row[0]) if row else None

            # Normalizar mensaje
            if codigo == 1:
                mensaje = "Programación registrada con éxito."
            elif codigo == -1:
                mensaje = "Error de validación: revise las fechas, IDs o el detalle de horarios."
            elif codigo == 0:
                mensaje = "Error del sistema al registrar la programación."
            else:
                mensaje = "Resultado desconocido del procedimiento."

            con.commit()
            return codigo, mensaje

        except Exception as e:
            # Limpiar resultsets si quedara alguno abierto
            try:
                if cursor:
                    while cursor.nextset():
                        cursor.fetchall()
            except Exception:
                pass
            if con:
                con.rollback()
            print("EL VERDADERO ERROR ES:", e)
            return 0, "Error del sistema al registrar la programación."
        finally:
            if cursor:
                cursor.close()
            if con:
                con.close()
