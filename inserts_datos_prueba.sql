-- =========================================
-- INSERTS DE DATOS DE PRUEBA
-- Centro de Salud - Clínica Ham
-- =========================================

-- Limpiar datos existentes (opcional)
-- DELETE FROM CALIFICACION_CITA;
-- DELETE FROM CITA;
-- DELETE FROM TURNO;
-- DELETE FROM HORARIO;
-- DELETE FROM PROGRAMACION;
-- DELETE FROM DOMICILIO;
-- DELETE FROM MEDICO;
-- DELETE FROM ESPECIALIDAD;
-- DELETE FROM CONSULTORIO;
-- DELETE FROM CENTRO_SALUD;
-- DELETE FROM PACIENTE;
-- DELETE FROM PERSONAL WHERE id > 1;
-- DELETE FROM ROL WHERE id > 2;

-- =========================================
-- 1. ROL (Ya existen Administrador y Supervisor)
-- =========================================
INSERT INTO ROL (nombre) VALUES 
('Recepcionista'),
('Enfermero'),
('Contador');

-- =========================================
-- 2. PERSONAL (Personal administrativo)
-- =========================================
-- Clave: admin123 (hasheada con Argon2)
INSERT INTO PERSONAL (DNI, nombre, ape_paterno, ape_materno, email, clave, foto_perfil, telefono, ROLid, estado) VALUES 
('45678912', 'María', 'García', 'López', 'maria.garcia@clinicaham.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_maria.jpg', '987123456', 2, 1),
('78945612', 'Carlos', 'Martínez', 'Ruiz', 'carlos.martinez@clinicaham.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_carlos.jpg', '987456123', 1, 1),
('65432178', 'Ana', 'López', 'Fernández', 'ana.lopez@clinicaham.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_ana.jpg', '987789456', 3, 1),
('12345678', 'Roberto', 'Díaz', 'Morales', 'roberto.diaz@clinicaham.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_roberto.jpg', '987321654', 4, 1),
('98765432', 'Sofía', 'Hernández', 'Castro', 'sofia.hernandez@clinicaham.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_sofia.jpg', '987654987', 5, 1);

-- =========================================
-- 3. ESPECIALIDAD
-- =========================================
INSERT INTO ESPECIALIDAD (nombre, descripcion) VALUES 
('Cardiología', 'Especialidad médica que se ocupa de las enfermedades del corazón y del aparato circulatorio'),
('Pediatría', 'Rama de la medicina que se especializa en la salud y las enfermedades de los niños'),
('Medicina General', 'Atención médica general para diagnóstico, tratamiento y prevención de enfermedades'),
('Traumatología', 'Especialidad quirúrgica que se dedica al estudio de las lesiones del aparato locomotor'),
('Dermatología', 'Especialidad médica que se encarga del estudio, diagnóstico y tratamiento de enfermedades de la piel'),
('Ginecología', 'Especialidad médica que trata las enfermedades del sistema reproductor femenino'),
('Oftalmología', 'Especialidad médica que estudia las enfermedades del ojo y su tratamiento'),
('Neurología', 'Especialidad médica que trata los trastornos del sistema nervioso');

-- =========================================
-- 4. MÉDICOS
-- =========================================
INSERT INTO MEDICO (nombres, ape_paterno, ape_materno, DNI, email, telefono, estado, id_personal_validado) VALUES 
('Alejandro', 'Gómez', 'Silva', '40123456', 'alejandro.gomez@clinicaham.com', '987001234', 'A', 1),
('María', 'García', 'Ruiz', '40234567', 'maria.garcia.med@clinicaham.com', '987002345', 'A', 1),
('Carlos', 'Martínez', 'López', '40345678', 'carlos.martinez.med@clinicaham.com', '987003456', 'A', 2),
('Luis', 'Rodríguez', 'Torres', '40456789', 'luis.rodriguez@clinicaham.com', '987004567', 'A', 1),
('Ana', 'López', 'Fernández', '40567890', 'ana.lopez.med@clinicaham.com', '987005678', 'A', 2),
('Sofía', 'Hernández', 'Castro', '40678901', 'sofia.hernandez.med@clinicaham.com', '987006789', 'A', 1),
('Jorge', 'Ramírez', 'Vargas', '40789012', 'jorge.ramirez@clinicaham.com', '987007890', 'P', NULL),
('Laura', 'Pérez', 'Mendoza', '40890123', 'laura.perez@clinicaham.com', '987008901', 'A', 2),
('Diego', 'Sánchez', 'Ortiz', '40901234', 'diego.sanchez@clinicaham.com', '987009012', 'V', 1),
('Isabel', 'Vargas', 'Delgado', '41012345', 'isabel.vargas@clinicaham.com', '987010123', 'A', 1);

-- =========================================
-- 5. CENTRO DE SALUD
-- =========================================
INSERT INTO CENTRO_SALUD (nombre, direccion, telefono) VALUES 
('Clínica Ham - Sede Principal Centro', 'Cra 7 # 32-45, Bogotá', '601234567'),
('Clínica Ham - Sede Norte', 'Calle 127 # 52-30, Bogotá', '601234568'),
('Clínica Ham - Sede Sur', 'Autopista Sur # 45-23, Bogotá', '601234569'),
('Clínica Ham - Sede Chapinero', 'Cra 13 # 54-38, Bogotá', '601234570'),
('Clínica Ham - Sede Suba', 'Calle 145 # 103-20, Bogotá', '601234571'),
('Clínica Ham - Sede Kennedy', 'Calle 38 Sur # 78F-45, Bogotá', '601234572');

-- =========================================
-- 6. CONSULTORIOS
-- =========================================
-- Sede Principal Centro (3 consultorios)
INSERT INTO CONSULTORIO (nombre, estado, id_centro_salud) VALUES 
('Consultorio 101', '1', 1),
('Consultorio 102', '1', 1),
('Consultorio 103', '1', 1),
-- Sede Norte (2 consultorios)
('Consultorio 201', '1', 2),
('Consultorio 202', '1', 2),
-- Sede Sur (2 consultorios)
('Consultorio 301', '1', 3),
('Consultorio 302', '1', 3),
-- Sede Chapinero (2 consultorios)
('Consultorio 401', '1', 4),
('Consultorio 402', '1', 4),
-- Sede Suba (1 consultorio)
('Consultorio 501', '1', 5),
-- Sede Kennedy (2 consultorios)
('Consultorio 601', '1', 6),
('Consultorio 602', '1', 6);

-- =========================================
-- 7. PACIENTES
-- =========================================
-- Clave: paciente123 (hasheada)
INSERT INTO PACIENTE (DNI, nombres, ape_paterno, ape_materno, f_nacimiento, telefono, email, clave, foto_perfil, nombre_emergencia, numero_emergencia, relacion_emergencia) VALUES 
('50123456', 'Ana María', 'Torres', 'Gutiérrez', '1990-05-15', '987100001', 'ana.torres@email.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_paciente1.jpg', 'Pedro Torres', '987100002', 'Esposo'),
('50234567', 'Luis Alberto', 'Morales', 'Ríos', '1985-08-22', '987200001', 'luis.morales@email.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_paciente2.jpg', 'Carmen Ríos', '987200002', 'Madre'),
('50345678', 'Carmen Rosa', 'Ruiz', 'Paredes', '1992-03-10', '987300001', 'carmen.ruiz@email.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_paciente3.jpg', 'José Ruiz', '987300002', 'Padre'),
('50456789', 'Pedro Javier', 'Sánchez', 'Vega', '1988-11-28', '987400001', 'pedro.sanchez@email.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_paciente4.jpg', 'Laura Vega', '987400002', 'Esposa'),
('50567890', 'María Fernanda', 'Fernández', 'Díaz', '1995-06-18', '987500001', 'maria.fernandez@email.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_paciente5.jpg', 'Roberto Fernández', '987500002', 'Hermano'),
('50678901', 'Jorge Andrés', 'Ramírez', 'Castro', '1983-09-05', '987600001', 'jorge.ramirez.pac@email.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_paciente6.jpg', 'Ana Castro', '987600002', 'Esposa'),
('50789012', 'Isabel Patricia', 'Vargas', 'Rojas', '1991-12-14', '987700001', 'isabel.vargas.pac@email.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_paciente7.jpg', 'Carlos Vargas', '987700002', 'Padre'),
('50890123', 'Roberto Carlos', 'Díaz', 'Núñez', '1987-04-20', '987800001', 'roberto.diaz.pac@email.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_paciente8.jpg', 'Diana Núñez', '987800002', 'Esposa'),
('50901234', 'Laura Jimena', 'Silva', 'Mendoza', '1994-07-30', '987900001', 'laura.silva@email.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_paciente9.jpg', 'Miguel Silva', '987900002', 'Hermano'),
('51012345', 'Diego Fernando', 'Ortiz', 'Herrera', '1989-02-08', '988000001', 'diego.ortiz@email.com', '$argon2id$v=19$m=65536,t=3,p=4$DhuQucaekZr1yu11XfTSzQ$+72Neob1Licd0LMxPmTp9DdVMdVGbsNIwigVp73uIxo', 'foto_paciente10.jpg', 'Carla Herrera', '988000002', 'Esposa');

-- =========================================
-- 8. DOMICILIOS DE PACIENTES
-- =========================================
INSERT INTO DOMICILIO (nombre, direccion, PACIENTEid) VALUES 
('Casa', 'Calle 45 # 23-12, Bogotá', 1),
('Trabajo', 'Carrera 7 # 80-50, Bogotá', 1),
('Casa', 'Calle 100 # 15-20, Bogotá', 2),
('Casa', 'Avenida 68 # 45-30, Bogotá', 3),
('Casa', 'Calle 127 # 52-40, Bogotá', 4),
('Casa', 'Carrera 30 # 65-15, Bogotá', 5),
('Casa', 'Calle 170 # 60-25, Bogotá', 6),
('Casa', 'Autopista Sur # 38-10, Bogotá', 7),
('Trabajo', 'Calle 72 # 10-20, Bogotá', 7),
('Casa', 'Calle 26 # 69-40, Bogotá', 8),
('Casa', 'Carrera 50 # 127-30, Bogotá', 9),
('Casa', 'Calle 13 # 82-15, Bogotá', 10);

-- =========================================
-- 9. PROGRAMACIÓN (Médicos asignados a consultorios)
-- =========================================
-- Dr. Alejandro Gómez - Cardiología - Consultorio 101 - Sede Centro
INSERT INTO PROGRAMACION (fecha_inicial, fecha_final, MEDICOid, CONSULTORIOid, ESPECIALIDADid) VALUES 
(20251001, 20251231, 1, 1, 1),
-- Dra. María García - Pediatría - Consultorio 102 - Sede Centro
(20251001, 20251231, 2, 2, 2),
-- Dr. Carlos Martínez - Medicina General - Consultorio 103 - Sede Centro
(20251001, 20251231, 3, 3, 3),
-- Dr. Luis Rodríguez - Cardiología - Consultorio 201 - Sede Norte
(20251001, 20251231, 4, 4, 1),
-- Dra. Ana López - Traumatología - Consultorio 202 - Sede Norte
(20251001, 20251231, 5, 5, 4),
-- Dra. Sofía Hernández - Pediatría - Consultorio 301 - Sede Sur
(20251001, 20251231, 6, 6, 2),
-- Dra. Laura Pérez - Ginecología - Consultorio 302 - Sede Sur
(20251001, 20251231, 8, 7, 6),
-- Dra. Isabel Vargas - Dermatología - Consultorio 401 - Sede Chapinero
(20251001, 20251231, 10, 8, 5);

-- =========================================
-- 10. HORARIOS (Días y horas de atención)
-- =========================================
-- Dr. Alejandro Gómez - Lunes a Viernes
INSERT INTO HORARIO (hora_inicial, hora_final, dia_semana, PROGRAMACIONid) VALUES 
('08:00:00', '12:00:00', 'Lunes', 1),
('08:00:00', '12:00:00', 'Martes', 1),
('08:00:00', '12:00:00', 'Miercoles', 1),
('08:00:00', '12:00:00', 'Jueves', 1),
('08:00:00', '12:00:00', 'Viernes', 1),

-- Dra. María García - Lunes a Sábado
('09:00:00', '13:00:00', 'Lunes', 2),
('09:00:00', '13:00:00', 'Martes', 2),
('09:00:00', '13:00:00', 'Miercoles', 2),
('09:00:00', '13:00:00', 'Jueves', 2),
('09:00:00', '13:00:00', 'Viernes', 2),
('09:00:00', '12:00:00', 'Sabado', 2),

-- Dr. Carlos Martínez - Lunes a Viernes
('14:00:00', '18:00:00', 'Lunes', 3),
('14:00:00', '18:00:00', 'Martes', 3),
('14:00:00', '18:00:00', 'Miercoles', 3),
('14:00:00', '18:00:00', 'Jueves', 3),
('14:00:00', '18:00:00', 'Viernes', 3),

-- Dr. Luis Rodríguez - Lunes, Miércoles, Viernes
('10:00:00', '14:00:00', 'Lunes', 4),
('10:00:00', '14:00:00', 'Miercoles', 4),
('10:00:00', '14:00:00', 'Viernes', 4),

-- Dra. Ana López - Martes y Jueves
('15:00:00', '19:00:00', 'Martes', 5),
('15:00:00', '19:00:00', 'Jueves', 5),

-- Dra. Sofía Hernández - Lunes a Viernes
('08:30:00', '12:30:00', 'Lunes', 6),
('08:30:00', '12:30:00', 'Martes', 6),
('08:30:00', '12:30:00', 'Miercoles', 6),
('08:30:00', '12:30:00', 'Jueves', 6),
('08:30:00', '12:30:00', 'Viernes', 6),

-- Dra. Laura Pérez - Lunes, Miércoles, Viernes
('14:00:00', '17:00:00', 'Lunes', 7),
('14:00:00', '17:00:00', 'Miercoles', 7),
('14:00:00', '17:00:00', 'Viernes', 7),

-- Dra. Isabel Vargas - Martes y Jueves
('09:00:00', '13:00:00', 'Martes', 8),
('09:00:00', '13:00:00', 'Jueves', 8);

-- =========================================
-- 11. TURNOS (Slots de 30 minutos)
-- =========================================
-- Dr. Alejandro Gómez - Lunes (8 turnos de 30 min)
INSERT INTO TURNO (hora_inicio, hora_fin, estado, HORARIOid) VALUES 
('08:00:00', '08:30:00', 'O', 1),
('08:30:00', '09:00:00', 'O', 1),
('09:00:00', '09:30:00', 'D', 1),
('09:30:00', '10:00:00', 'D', 1),
('10:00:00', '10:30:00', 'D', 1),
('10:30:00', '11:00:00', 'D', 1),
('11:00:00', '11:30:00', 'D', 1),
('11:30:00', '12:00:00', 'D', 1),

-- Dr. Alejandro Gómez - Martes
('08:00:00', '08:30:00', 'D', 2),
('08:30:00', '09:00:00', 'D', 2),
('09:00:00', '09:30:00', 'D', 2),
('09:30:00', '10:00:00', 'D', 2),
('10:00:00', '10:30:00', 'O', 2),
('10:30:00', '11:00:00', 'D', 2),
('11:00:00', '11:30:00', 'D', 2),
('11:30:00', '12:00:00', 'D', 2),

-- Dra. María García - Lunes (8 turnos de 30 min)
('09:00:00', '09:30:00', 'D', 6),
('09:30:00', '10:00:00', 'O', 6),
('10:00:00', '10:30:00', 'D', 6),
('10:30:00', '11:00:00', 'D', 6),
('11:00:00', '11:30:00', 'D', 6),
('11:30:00', '12:00:00', 'D', 6),
('12:00:00', '12:30:00', 'D', 6),
('12:30:00', '13:00:00', 'D', 6),

-- Dr. Carlos Martínez - Lunes (8 turnos de 30 min)
('14:00:00', '14:30:00', 'D', 11),
('14:30:00', '15:00:00', 'D', 11),
('15:00:00', '15:30:00', 'O', 11),
('15:30:00', '16:00:00', 'D', 11),
('16:00:00', '16:30:00', 'D', 11),
('16:30:00', '17:00:00', 'D', 11),
('17:00:00', '17:30:00', 'D', 11),
('17:30:00', '18:00:00', 'D', 11);

-- =========================================
-- 12. CITAS
-- =========================================
-- Citas confirmadas
INSERT INTO CITA (id_paciente, tipo_atencion, direccion_domicilio, estado, codigo_qr, fecha_creacion, TURNOid) VALUES 
(1, 'P', NULL, 'P', 'qr_cita_001.png', '2025-10-15 10:30:00', 1),
(2, 'P', NULL, 'P', 'qr_cita_002.png', '2025-10-16 14:20:00', 2),
(3, 'P', NULL, 'A', 'qr_cita_003.png', '2025-10-10 09:15:00', 13),
(4, 'P', NULL, 'A', 'qr_cita_004.png', '2025-10-11 11:45:00', 18),
(5, 'D', 'Carrera 30 # 65-15, Bogotá', 'P', 'qr_cita_005.png', '2025-10-17 08:00:00', 25),
(6, 'P', NULL, 'C', 'qr_cita_006.png', '2025-10-12 16:30:00', 27),
(7, 'P', NULL, 'A', 'qr_cita_007.png', '2025-10-13 10:00:00', 1),
(8, 'P', NULL, 'A', 'qr_cita_008.png', '2025-10-14 15:30:00', 29);

-- =========================================
-- 13. CALIFICACIONES DE CITAS
-- =========================================
-- Solo para citas atendidas
INSERT INTO CALIFICACION_CITA (id_cita, puntuacion, comentarion, fecha_creacion) VALUES 
(3, 5, 'Excelente atención, muy profesional y amable. El doctor se tomó el tiempo necesario para explicar todo.', '2025-10-10 12:00:00'),
(4, 4, 'Buena atención, pero el tiempo de espera fue un poco largo.', '2025-10-11 14:00:00'),
(7, 5, 'Muy satisfecho con el servicio, lo recomiendo ampliamente.', '2025-10-13 12:30:00'),
(8, 4, 'El médico fue muy atento, el consultorio estaba limpio y ordenado.', '2025-10-14 17:00:00');

-- =========================================
-- FIN DE INSERTS
-- =========================================

-- Verificar datos insertados
SELECT 'ROL' as Tabla, COUNT(*) as Total FROM ROL
UNION ALL
SELECT 'PERSONAL', COUNT(*) FROM PERSONAL
UNION ALL
SELECT 'ESPECIALIDAD', COUNT(*) FROM ESPECIALIDAD
UNION ALL
SELECT 'MEDICO', COUNT(*) FROM MEDICO
UNION ALL
SELECT 'CENTRO_SALUD', COUNT(*) FROM CENTRO_SALUD
UNION ALL
SELECT 'CONSULTORIO', COUNT(*) FROM CONSULTORIO
UNION ALL
SELECT 'PACIENTE', COUNT(*) FROM PACIENTE
UNION ALL
SELECT 'DOMICILIO', COUNT(*) FROM DOMICILIO
UNION ALL
SELECT 'PROGRAMACION', COUNT(*) FROM PROGRAMACION
UNION ALL
SELECT 'HORARIO', COUNT(*) FROM HORARIO
UNION ALL
SELECT 'TURNO', COUNT(*) FROM TURNO
UNION ALL
SELECT 'CITA', COUNT(*) FROM CITA
UNION ALL
SELECT 'CALIFICACION_CITA', COUNT(*) FROM CALIFICACION_CITA;
