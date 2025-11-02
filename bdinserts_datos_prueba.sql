-- LIMPIAR TABLAS
DELETE FROM CALIFICACION_CITA;
DELETE FROM CITA;
DELETE FROM TURNO;
DELETE FROM HORARIO;
DELETE FROM PROGRAMACION;
DELETE FROM DOMICILIO;
DELETE FROM PACIENTE;
DELETE FROM MEDICO;
DELETE FROM CONSULTORIO;
DELETE FROM CENTRO_SALUD;
DELETE FROM ESPECIALIDAD;
DELETE FROM PERSONAL;
DELETE FROM ROL;

-- INSERTAR ROLES
INSERT INTO ROL (nombre) VALUES
('Administrador'),
('Supervisor'),
('Recepcionista'),
('Enfermero'),
('Contador');

-- INSERTAR PERSONAL
INSERT INTO PERSONAL (DNI, nombre, ape_paterno, ape_materno, email, clave, foto_perfil, telefono, ROLid) VALUES
('74985581', 'Louis', 'Requejo', 'Chirinos', 'louis@ccss.com', 'usat', 'foto1.jpg', '987654321', 1),
('45678912', 'María', 'García', 'López', 'maria.garcia@clinicaham.com', 'usat', 'foto_maria.jpg', '987123456', 2),
('78945612', 'Carlos', 'Martínez', 'Ruiz', 'carlos.martinez@clinicaham.com', 'usat', 'foto_carlos.jpg', '987456123', 1),
('65432178', 'Ana', 'López', 'Fernández', 'ana.lopez@clinicaham.com', 'usat', 'foto_ana.jpg', '987789456', 3),
('12345678', 'Roberto', 'Díaz', 'Morales', 'roberto.diaz@clinicaham.com', 'usat', 'foto_roberto.jpg', '987321654', 4),
('98765432', 'Sofía', 'Hernández', 'Castro', 'sofia.hernandez@clinicaham.com', 'usat', 'foto_sofia.jpg', '987654987', 5);

-- INSERTAR ESPECIALIDADES
INSERT INTO ESPECIALIDAD (nombre, estado, descripcion) VALUES
('Cardiología', 'A', 'Especialidad médica que se ocupa de las enfermedades del corazón y del aparato circulatorio'),
('Pediatría', 'A', 'Rama de la medicina que se especializa en la salud y las enfermedades de los niños'),
('Medicina General', 'A', 'Atención médica general para diagnóstico, tratamiento y prevención de enfermedades'),
('Traumatología', 'A', 'Especialidad quirúrgica que se dedica al estudio de las lesiones del aparato locomotor'),
('Dermatología', 'A', 'Especialidad médica que se encarga del estudio, diagnóstico y tratamiento de enfermedades de la piel'),
('Ginecología', 'A', 'Especialidad médica que trata las enfermedades del sistema reproductor femenino'),
('Oftalmología', 'A', 'Especialidad médica que estudia las enfermedades del ojo y su tratamiento'),
('Neurología', 'A', 'Especialidad médica que trata los trastornos del sistema nervioso');

-- INSERTAR MEDICOS
INSERT INTO MEDICO (nombres, ape_paterno, ape_materno, DNI, email, telefono, estado, id_personal_validado) VALUES
('Alejandro', 'Gómez', 'Silva', '40123456', 'alejandro.gomez@clinicaham.com', '987001234', 'A', 1),
('María', 'García', 'Ruiz', '40234567', 'maria.garcia.med@clinicaham.com', '987002345', 'A', 2),
('Carlos', 'Martínez', 'López', '40345678', 'carlos.martinez.med@clinicaham.com', '987003456', 'A', 3),
('Luis', 'Rodríguez', 'Torres', '40456789', 'luis.rodriguez@clinicaham.com', '987004567', 'A', 4),
('Ana', 'López', 'Fernández', '40567890', 'ana.lopez.med@clinicaham.com', '987005678', 'A', 5),
('Sofía', 'Hernández', 'Castro', '40678901', 'sofia.hernandez.med@clinicaham.com', '987006789', 'A', 6),
('Jorge', 'Ramírez', 'Vargas', '40789012', 'jorge.ramirez@clinicaham.com', '987007890', 'D', NULL),
('Laura', 'Pérez', 'Mendoza', '40890123', 'laura.perez@clinicaham.com', '987008901', 'A', 8),
('Diego', 'Sánchez', 'Ortiz', '40901234', 'diego.sanchez@clinicaham.com', '987009012', 'V', 9),
('Isabel', 'Vargas', 'Delgado', '41012345', 'isabel.vargas.med@clinicaham.com', '987010123', 'A', 10);

-- INSERTAR CENTROS DE SALUD
INSERT INTO CENTRO_SALUD (nombre, direccion, telefono, estado) VALUES
('Clínica Ham - Sede Principal Centro', 'Cra 7 # 32-45, Bogotá', '601234567', 'A'),
('Clínica Ham - Sede Norte', 'Calle 127 # 52-30, Bogotá', '601234568', 'A'),
('Clínica Ham - Sede Sur', 'Autopista Sur # 45-23, Bogotá', '601234569', 'A'),
('Clínica Ham - Sede Chapinero', 'Cra 13 # 54-38, Bogotá', '601234570', 'A'),
('Clínica Ham - Sede Suba', 'Calle 145 # 103-20, Bogotá', '601234571', 'A'),
('Clínica Ham - Sede Kennedy', 'Calle 38 Sur # 78F-45, Bogotá', '601234572', 'A');

-- INSERTAR CONSULTORIOS
INSERT INTO CONSULTORIO (nombre, estado, id_centro_salud) VALUES
('Consultorio 101', 'A', 1),
('Consultorio 102', 'A', 1),
('Consultorio 103', 'A', 1),
('Consultorio 201', 'A', 2),
('Consultorio 202', 'A', 2),
('Consultorio 301', 'A', 3),
('Consultorio 302', 'A', 3),
('Consultorio 401', 'A', 4),
('Consultorio 402', 'A', 4),
('Consultorio 501', 'A', 5),
('Consultorio 601', 'A', 6),
('Consultorio 602', 'A', 6);

-- INSERTAR PACIENTES
INSERT INTO PACIENTE (DNI, nombres, ape_paterno, ape_materno, f_nacimiento, telefono, email, clave, foto_perfil, nombre_emergencia, numero_emergencia, relacion_emergencia) VALUES
('50123456', 'Ana María', 'Torres', 'Gutiérrez', '1990-05-15', '987100001', 'ana.torres@email.com', 'usat', 'foto_paciente1.jpg', 'Pedro Torres', '987100002', 'Esposo'),
('50234567', 'Luis Alberto', 'Morales', 'Ríos', '1985-08-22', '987200001', 'luis.morales@email.com', 'usat', 'foto_paciente2.jpg', 'Carmen Ríos', '987200002', 'Madre'),
('50345678', 'Carmen Rosa', 'Ruiz', 'Paredes', '1992-03-10', '987300001', 'carmen.ruiz@email.com', 'usat', 'foto_paciente3.jpg', 'José Ruiz', '987300002', 'Padre');

-- INSERTAR DOMICILIOS
INSERT INTO DOMICILIO (nombre, direccion, estado, PACIENTEid) VALUES
('Casa', 'Calle 45 # 23-12, Bogotá', 'A', 1),
('Trabajo', 'Carrera 7 # 80-50, Bogotá', 'A', 1),
('Casa', 'Calle 100 # 15-20, Bogotá', 'A', 2),
('Casa', 'Avenida 68 # 45-30, Bogotá', 'A', 3);

-- INSERTAR PROGRAMACION
INSERT INTO PROGRAMACION (fecha_inicial, fecha_final, estado, MEDICOid, CONSULTORIOid, ESPECIALIDADid) VALUES
('2025-10-01', '2025-12-31', 'A', 1, 1, 1),
('2025-10-01', '2025-12-31', 'A', 2, 2, 2),
('2025-10-01', '2025-12-31', 'A', 3, 3, 3);

-- INSERTAR HORARIOS
INSERT INTO HORARIO (hora_inicial, hora_final, dia_semana, estado, PROGRAMACIONid) VALUES
('08:00:00', '12:00:00', 'Lunes', 'A', 1),
('08:00:00', '12:00:00', 'Martes', 'A', 1),
('09:00:00', '13:00:00', 'Lunes', 'A', 2),
('09:00:00', '13:00:00', 'Martes', 'A', 2),
('10:00:00', '14:00:00', 'Miércoles', 'A', 3);

-- INSERTAR TURNOS
INSERT INTO TURNO (hora_inicio, hora_fin, estado, HORARIOid) VALUES
('08:00:00', '08:30:00', 'A', 1),
('08:30:00', '09:00:00', 'A', 1),
('09:00:00', '09:30:00', 'A', 2),
('09:30:00', '10:00:00', 'A', 2),
('10:00:00', '10:30:00', 'A', 3);

-- INSERTAR CITAS COMPLETAS
INSERT INTO CITA (id_paciente, tipo_atencion, direccion_domicilio, estado, codigo_qr, fecha_creacion, TURNOid) VALUES
(1, 'P', NULL, 'P', 'qr_cita_001.png', '2025-11-05 09:00:00', 1),
(2, 'P', NULL, 'C', 'qr_cita_002.png', '2025-11-06 10:30:00', 2),
(3, 'P', NULL, 'A', 'qr_cita_003.png', '2025-11-07 14:15:00', 3);


-- INSERTAR CALIFICACIONES COMPLETAS
INSERT INTO CALIFICACION_CITA  (id_cita, puntuacion, comentarion, fecha_creacion) VALUES
(1, 5, 'Excelente atención, muy profesional y amable.', NOW()),
(2, 4, 'Buena atención, pero el tiempo de espera fue un poco largo.', NOW()),
(3, 5, 'Muy satisfecho con el servicio, lo recomiendo ampliamente.', NOW());

