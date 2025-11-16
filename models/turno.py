from conexionBD import Conexion

class Turno:
    def __init__(self):
        pass    

    def listarTurnosPorMedico(self, medicoId):
        con = Conexion().open
        cursor = con.cursor()
        try:
            sql = """
                SELECT 
                    T.id,
                    H.fecha,
                    T.hora_inicio as hora_inicio,
                    T.hora_fin as hora_fin,
                    T.estado,
                    H.dia_semana
                FROM TURNO T
                INNER JOIN HORARIO H ON T.HORARIOid = H.id
                INNER JOIN PROGRAMACION P ON H.PROGRAMACIONid = P.id
                WHERE P.MEDICOid = %s
                AND H.fecha >= CURDATE()
                AND T.estado = 'D'
                ORDER BY H.fecha, H.hora_inicial
            """
            cursor.execute(sql, (medicoId,))
            return cursor.fetchall()
        except Exception as e:
            print(f"Error al listar turnos por médico: {e}")
            return []