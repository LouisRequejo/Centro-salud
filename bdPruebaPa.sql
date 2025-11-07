-- Archivo de prueba: CALLs para validar los procedimientos almacenados (bdpa.sql)
-- Ejecuta este script después de haber cargado bdpa.sql en la base de datos de prueba.

-- Variables de salida usadas en los CALLs
SET @res = NULL;
SET @codigo = NULL;

CALL InsertarRol('Administrador', @res); SELECT 'InsertarRol' AS pa, @res AS resultado;
CALL ActualizarRol(1, 'Recepcionista', @res); SELECT 'ActualizarRol' AS pa, @res AS resultado;
CALL EliminarRol(2, @res); SELECT 'EliminarRol' AS pa, @res AS resultado;
CALL DarDeBajaRol(3, @res); SELECT 'DarDeBajaRol' AS pa, @res AS resultado;

CALL insertarPersonal('12345678','Juan','Perez','Lopez','juan@example.com','clave123','foto.jpg','999888777',1,@res); SELECT 'insertarPersonal' AS pa, @res AS resultado;
CALL ActualizarPersonal(1,'12345678','Juan','Perez','Lopez','juan2@example.com','clave123','foto2.jpg','999888777',1,1,@res); SELECT 'ActualizarPersonal' AS pa, @res AS resultado;
CALL EliminarPersonal(5,@res); SELECT 'EliminarPersonal' AS pa, @res AS resultado;
CALL DarDeBajaPersonal(5,@res); SELECT 'DarDeBajaPersonal' AS pa, @res AS resultado;

CALL paInsertarDomicilio('Casa','Av. Ejemplo 123', -12.045, -77.03, 1, @res); SELECT 'paInsertarDomicilio' AS pa, @res AS resultado;
CALL PaModificarDomicilio(1,'Trabajo','Calle Falsa 45', -12.046, -77.04, 1, @res); SELECT 'PaModificarDomicilio' AS pa, @res AS resultado;
CALL paEliminarDomicilio(1, @res); SELECT 'paEliminarDomicilio' AS pa, @res AS resultado;
CALL paActualizarEstadoDomicilio(1, @res); SELECT 'paActualizarEstadoDomicilio' AS pa, @res AS resultado;

CALL insertarCentroSalud('Centro A','Av. Central 100','987654321', @res); SELECT 'insertarCentroSalud' AS pa, @res AS resultado;
CALL ActualizarCentroSalud(1, 'Centro A Mod', 'Av. Central 101', '987654322', 1, @res); SELECT 'ActualizarCentroSalud' AS pa, @res AS resultado;
CALL EliminarCentroSalud(2, @res); SELECT 'EliminarCentroSalud' AS pa, @res AS resultado;
CALL DarDeBajaCentroSalud(2, @res); SELECT 'DarDeBajaCentroSalud' AS pa, @res AS resultado;

CALL insertarConsultorio('Consultorio 1', 1, @res); SELECT 'insertarConsultorio' AS pa, @res AS resultado;
CALL ActualizarConsultorio(1, 'Consultorio 1B', 1, 1, @res); SELECT 'ActualizarConsultorio' AS pa, @res AS resultado;
CALL EliminarConsultorio(3, @res); SELECT 'EliminarConsultorio' AS pa, @res AS resultado;
CALL DarDeBajaConsultorio(3, @res); SELECT 'DarDeBajaConsultorio' AS pa, @res AS resultado;

CALL insertarEspecialidad('Cardiologia','Atención cardiológica', @res); SELECT 'insertarEspecialidad' AS pa, @res AS resultado;
CALL ActualizarEspecialidad(1,'Cardiología','Cardio desc',1, @res); SELECT 'ActualizarEspecialidad' AS pa, @res AS resultado;
CALL EliminarEspecialidad(4, @res); SELECT 'EliminarEspecialidad' AS pa, @res AS resultado;
CALL DarDeBajaEspecialidad(4, @res); SELECT 'DarDeBajaEspecialidad' AS pa, @res AS resultado;

CALL insertarMedico('Ana','Gomez','Soto','87654321','ana@example.com','987654321', 2, @res); SELECT 'insertarMedico' AS pa, @res AS resultado;
CALL ActualizarMedico(1,'Ana','Gomez','Soto','87654321','ana2@example.com','987654322',1,2,@res); SELECT 'ActualizarMedico' AS pa, @res AS resultado;
CALL EliminarMedico(5, @res); SELECT 'EliminarMedico' AS pa, @res AS resultado;
CALL DarDeBajaMedico(5, @res); SELECT 'DarDeBajaMedico' AS pa, @res AS resultado;

CALL insertarPaciente('87654321','Carlos','Diaz','Mora','1990-01-01','987654321','carlos@example.com','pass123','foto.jpg','Maria','999111222','hermana', @res); SELECT 'insertarPaciente' AS pa, @res AS resultado;
CALL ActualizarPaciente(1,'87654321','Carlos','Diaz','Mora','1990-01-01','987654321','carlos2@example.com','pass123','foto2.jpg','Maria','999111222','hermana', @res); SELECT 'ActualizarPaciente' AS pa, @res AS resultado;
CALL EliminarPaciente(2, @res); SELECT 'EliminarPaciente' AS pa, @res AS resultado;

CALL insertarCalificacionCita(1, 5, 'Excelente servicio', @res); SELECT 'insertarCalificacionCita' AS pa, @res AS resultado;
CALL ActualizarCalificacionCita(1, 4, 'Buena atención', @res); SELECT 'ActualizarCalificacionCita' AS pa, @res AS resultado;
CALL EliminarCalificacionCita(1, @res); SELECT 'EliminarCalificacionCita' AS pa, @res AS resultado;

CALL insertarCita(1, 'P', 'Av. Cliente 10', 10, @res); SELECT 'insertarCita' AS pa, @res AS resultado;
CALL ActualizarCita(1, 1, 'P', 'Av. Cliente 10', 11, @res); SELECT 'ActualizarCita' AS pa, @res AS resultado;
CALL EliminarCita(3, @res); SELECT 'EliminarCita' AS pa, @res AS resultado;
CALL CancelarCita(1, @res); SELECT 'CancelarCita' AS pa, @res AS resultado;

SET @detalle = JSON_ARRAY(
    JSON_OBJECT('dia_semana','LUNES','hora_inicial','08:00:00','hora_final','12:00:00','duracion_minutos',60),
    JSON_OBJECT('dia_semana','MARTES','hora_inicial','13:00:00','hora_final','17:00:00','duracion_minutos',30)
);
CALL sp_crear_programacion_y_horarios('2025-11-10','2025-11-16', 1, 1, 1, @detalle, @codigo); SELECT 'sp_crear_programacion_y_horarios' AS sp, @codigo AS resultado;

-- Fin script de pruebas
