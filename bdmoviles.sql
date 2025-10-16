CREATE TABLE PACIENTE (id int(10) NOT NULL AUTO_INCREMENT, DNI char(8) NOT NULL, nombres varchar(255) NOT NULL, ape_paterno varchar(255) NOT NULL, ape_materno varchar(255) NOT NULL, f_nacimiento date NOT NULL, telefono char(9) NOT NULL, email varchar(255) NOT NULL, clave varchar(255) NOT NULL, foto_perfil varchar(255), nombre_emergencia varchar(255), numero_emergencia char(9), relacion_emergencia varchar(255), PRIMARY KEY (id));
CREATE TABLE CONSULTORIO (id int(10) NOT NULL AUTO_INCREMENT, nombre varchar(255) NOT NULL, estado char(1) NOT NULL, id_centro_salud int(10) NOT NULL, PRIMARY KEY (id));
CREATE TABLE NOTIFICACION (id int(10) NOT NULL AUTO_INCREMENT, id_tipo_notificacion int(10) NOT NULL, id_destinatario int(10), tipo_destinatario int(10), titulo int(10), mensaje int(10), fecha_creacion int(10), PRIMARY KEY (id));
CREATE TABLE PERSONAL (id int(10) NOT NULL AUTO_INCREMENT, DNI char(8) NOT NULL, nombre varchar(255) NOT NULL, ape_paterno varchar(255) NOT NULL, ape_materno varchar(255) NOT NULL, email varchar(255) NOT NULL, clave varchar(255) NOT NULL, foto_perfil varchar(255) NOT NULL, telefono char(9) NOT NULL, ROLid int(10) NOT NULL, estado BOOLEAN NOT NULL, PRIMARY KEY (id));
CREATE TABLE MEDICO (id int(10) NOT NULL AUTO_INCREMENT, nombres varchar(255) NOT NULL, ape_paterno varchar(255) NOT NULL, ape_materno varchar(255) NOT NULL, DNI char(8) NOT NULL UNIQUE, email varchar(255) NOT NULL, telefono char(9) NOT NULL, estado char(1) NOT NULL, id_personal_validado int(10), PRIMARY KEY (id));
CREATE TABLE ESPECIALIDAD (id int(10) NOT NULL AUTO_INCREMENT, nombre varchar(255) NOT NULL, descripcion varchar(255), PRIMARY KEY (id));
CREATE TABLE CENTRO_SALUD (id int(10) NOT NULL AUTO_INCREMENT, nombre varchar(255) NOT NULL, direccion varchar(255) NOT NULL, telefono char(9) NOT NULL, PRIMARY KEY (id));
CREATE TABLE CITA (id int(10) NOT NULL AUTO_INCREMENT, id_paciente int(10) NOT NULL, tipo_atencion char(1) NOT NULL comment 'P->Presencial
D->Domicilio', direccion_domicilio varchar(255) NOT NULL, estado char(1) NOT NULL comment 'P-> Pendiente
C->Cancelada
A->Atendida', codigo_qr varchar(255) NOT NULL comment 'direccion de la imagen del codigo qr generado para una cita', fecha_creacion timestamp NOT NULL, TURNOid int(10) NOT NULL, PRIMARY KEY (id));
CREATE TABLE CALIFICACION_CITA (id_cita int(10) NOT NULL, puntuacion int(10), comentarion text, fecha_creacion timestamp NULL, PRIMARY KEY (id_cita));
CREATE TABLE CHAT (id int(10) NOT NULL AUTO_INCREMENT, id_paciente int(10) NOT NULL, id_medico int(10) NOT NULL, fecha_creacion int(10), PRIMARY KEY (id));
CREATE TABLE MENSAJES_CHAT (id int(10), id_chat int(10) NOT NULL, id_emisor int(10), tipo_emisor int(10), contenido int(10), fecha_hora int(10), visto int(10), PRIMARY KEY (id));
CREATE TABLE TIPO_NOTIFICACION (id int(10) NOT NULL AUTO_INCREMENT, nombre int(10), PRIMARY KEY (id));
CREATE TABLE PROGRAMACION (id int(10) NOT NULL AUTO_INCREMENT, fecha_inicial int(10), fecha_final int(10), MEDICOid int(10) NOT NULL, CONSULTORIOid int(10) NOT NULL, ESPECIALIDADid int(10) NOT NULL, PRIMARY KEY (id));
CREATE TABLE HORARIO (id int(10) NOT NULL AUTO_INCREMENT, hora_inicial time NOT NULL, hora_final time NOT NULL, dia_semana varchar(10) NOT NULL comment 'Lunes
Martes
Miercoles
Jueves
Viernes
Sabado
Domingo', PROGRAMACIONid int(10) NOT NULL, PRIMARY KEY (id));
CREATE TABLE TURNO (id int(10) NOT NULL AUTO_INCREMENT, hora_inicio time NOT NULL, hora_fin time NOT NULL, estado char(1) NOT NULL comment 'D=Disponible
O=Ocupado', HORARIOid int(10) NOT NULL, PRIMARY KEY (id));
CREATE TABLE ROL (id int(10) NOT NULL AUTO_INCREMENT, nombre VARCHAR(255), PRIMARY KEY (id));
CREATE TABLE DOMICILIO (id int(11) NOT NULL AUTO_INCREMENT, nombre varchar(255) NOT NULL, direccion varchar(255) NOT NULL, PACIENTEid int(10) NOT NULL, PRIMARY KEY (id));
ALTER TABLE MENSAJES_CHAT ADD CONSTRAINT FKMENSAJES_C709446 FOREIGN KEY (id_chat) REFERENCES CHAT (id);
ALTER TABLE CITA ADD CONSTRAINT FKCITA698044 FOREIGN KEY (id_paciente) REFERENCES PACIENTE (id);
ALTER TABLE CONSULTORIO ADD CONSTRAINT FKCONSULTORI355879 FOREIGN KEY (id_centro_salud) REFERENCES CENTRO_SALUD (id);
ALTER TABLE NOTIFICACION ADD CONSTRAINT FKNOTIFICACI981960 FOREIGN KEY (id_tipo_notificacion) REFERENCES TIPO_NOTIFICACION (id);
ALTER TABLE CALIFICACION_CITA ADD CONSTRAINT FKCALIFICACI795793 FOREIGN KEY (id_cita) REFERENCES CITA (id);
ALTER TABLE PROGRAMACION ADD CONSTRAINT FKPROGRAMACI111763 FOREIGN KEY (MEDICOid) REFERENCES MEDICO (id);
ALTER TABLE PROGRAMACION ADD CONSTRAINT FKPROGRAMACI440360 FOREIGN KEY (CONSULTORIOid) REFERENCES CONSULTORIO (id);
ALTER TABLE PROGRAMACION ADD CONSTRAINT FKPROGRAMACI76479 FOREIGN KEY (ESPECIALIDADid) REFERENCES ESPECIALIDAD (id);
ALTER TABLE HORARIO ADD CONSTRAINT FKHORARIO54009 FOREIGN KEY (PROGRAMACIONid) REFERENCES PROGRAMACION (id);
ALTER TABLE TURNO ADD CONSTRAINT FKTURNO475684 FOREIGN KEY (HORARIOid) REFERENCES HORARIO (id);
ALTER TABLE CITA ADD CONSTRAINT FKCITA231288 FOREIGN KEY (TURNOid) REFERENCES TURNO (id);
ALTER TABLE PERSONAL ADD CONSTRAINT FKPERSONAL35628 FOREIGN KEY (ROLid) REFERENCES ROL (id);
ALTER TABLE DOMICILIO ADD CONSTRAINT FKDOMICILIO767250 FOREIGN KEY (PACIENTEid) REFERENCES PACIENTE (id);


-- PA --

-- Procedimientos almacenados para la tabla ROL --

DELIMITER $$
CREATE PROCEDURE InsertarRol(IN p_nombre VARCHAR(255))
BEGIN
    IF EXISTS (SELECT 1 FROM ROL WHERE nombre = p_nombre) THEN
        SELECT 'El rol ya existe' AS mensaje;
    ELSE
        INSERT INTO ROL (nombre) VALUES (p_nombre);
        SELECT 'Rol insertado correctamente' AS mensaje;
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE EliminarRol(IN p_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ROL WHERE id = p_id) THEN
        SELECT 'El rol no existe' AS mensaje;
    ELSEIF EXISTS (SELECT 1 FROM PERSONAL WHERE ROLid = p_id) THEN
        SELECT 'El rol está asignado a un personal y no puede eliminarse' AS mensaje;
    ELSE
        DELETE FROM ROL WHERE id = p_id;
        SELECT 'Rol eliminado correctamente' AS mensaje;
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ActualizarRol(IN p_id INT, IN p_nombre VARCHAR(255))
BEGIN
    IF EXISTS (SELECT 1 FROM ROL WHERE id = p_id) THEN
        UPDATE ROL SET nombre = p_nombre WHERE id = p_id;
        SELECT 'Rol actualizado correctamente' AS mensaje;
    ELSE
        SELECT 'El rol no existe' AS mensaje;
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE DarDeBajaRol(IN p_id INT)
BEGIN
    IF EXISTS (SELECT 1 FROM ROL WHERE id = p_id) THEN
        UPDATE ROL SET estado = 'B' WHERE id = p_id;
        SELECT 'Rol dado de baja correctamente' AS mensaje;
    ELSE
        SELECT 'El rol no existe' AS mensaje;
    END IF;
END $$
DELIMITER ;

-- Fin procedimientos almacenados para la tabla ROL --

-- Procedimientos almacenados para la tabla PERSONAL --
DELIMITER $$
CREATE PROCEDURE insertarPersonal(
    IN p_DNI CHAR(8),
    IN p_nombre VARCHAR(255),
    IN p_ape_paterno VARCHAR(255),
    IN p_ape_materno VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_clave VARCHAR(255),
    IN p_foto_perfil VARCHAR(255),
    IN p_telefono CHAR(9),
    IN p_ROLid INT)
BEGIN
    IF EXISTS (SELECT 1 FROM PERSONAL WHERE DNI = p_DNI) THEN
        SELECT 'El DNI ya existe' AS mensaje;
    ELSEIF NOT EXISTS (SELECT 1 FROM ROL WHERE id = p_ROLid) THEN
        SELECT 'El rol no existe' AS mensaje;
    ELSE
        INSERT INTO PERSONAL (DNI, nombre, ape_paterno, ape_materno, email, clave, foto_perfil, telefono, ROLid, estado)
        VALUES (p_DNI, p_nombre, p_ape_paterno, p_ape_materno, p_email, p_clave, p_foto_perfil, p_telefono, p_ROLid, TRUE);
        SELECT 'Personal insertado correctamente' AS mensaje;
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE EliminarPersonal(IN p_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PERSONAL WHERE ID = p_id) THEN
        SELECT 'El personal que intenta eliminar no existe' AS mensaje;
    ELSE
        DELETE FROM PERSONAL WHERE ID = P_id;
        SELECT 'Personal eliminado correctamente' AS mensaje;
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ActualizarPersonal(
    IN p_id INT,
    IN p_DNI CHAR(8),
    IN p_nombre VARCHAR(255),
    IN p_ape_paterno VARCHAR(255),
    IN p_ape_materno VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_clave VARCHAR(255),
    IN p_foto_perfil VARCHAR(255),
    IN p_telefono CHAR(9),
    IN p_ROLid INT,
    IN p_estado BOOLEAN)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PERSONAL WHERE ID = p_id) THEN
        SELECT 'El personal que intenta actualizar no existe' AS mensaje;
    ELSE
        UPDATE PERSONAL SET DNI = p_DNI, NOMBRE = p_nombre, ape_paterno = p_ape_materno, ape_materno = p_ape_materno, email = p_email, clave = p_clave, foto_perfil = p_foto_perfil, telefono = p_telefono, ROLid = p_ROLid, estado = p_estado
        WHERE ID = p_id;
        SELECT 'El personal ha sido actualizado correctamente' AS mensaje;
    END IF;
END $$
DELIMITER;

DELIMITER $$
CREATE PROCEDURE DarDeBajaPersonal(IN p_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PERSONAL WHERE ID = p_id) THEN
        SELECT 'El personal que intenta dar de baja no existe' AS mensaje;
    ELSEIF (SELECT 1 FROM PERSONAL WHERE ID = p_id and estado = TRUE) THEN
        SELECT 'El personal ya se encuentra dado de baja' AS mensaje;
    ELSE
        UPDATE PERSONAL SET estado = FALSE WHERE ID = p_id;
        SELECT 'El personal se dio de baja correctamente' AS mensaje;
    END IF;
END $$
DELIMITER ;
-- Fin procedimientos almacenados para la tabla PERSONAL --


-- Procedimientos almacenados para la tabla DOMICILO --

DELIMITER $$
CREATE PROCEDURE InsertarDomicilio(IN p_nombre VARCHAR(255), p_direccion varchar(255), p_paciente_id INT)
BEGIN
    IF EXISTS (SELECT 1 FROM DOMICILIO WHERE direccion = p_direccion and PACIENTEid = p_paciente_id ) THEN
        SELECT 'El Este domicilio ya ha sido registrado anteriormente' AS mensaje;
    ELSE
        INSERT INTO DOMICILIO (nombre, direccion, PACIENTEid) VALUES (p_nombre, p_direccion,p_paciente_id);
        SELECT 'Domicilio insertado correctamente' AS mensaje;
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE EliminarDomicilio(IN p_docimicilio INT)
BEGIN
        DELETE FROM DOMICILIO WHERE id = p_docimicilio;
        SELECT 'Domicilio eliminado correctamente' AS mensaje;

END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ActualizarDomicilio(IN p_id INT, IN p_nombre VARCHAR(255),  p_direccion varchar(255) )
BEGIN
    IF EXISTS (SELECT 1 FROM DOMICILIO WHERE id = p_id) THEN
        UPDATE DOMICILIO SET nombre = p_nombre, direccion = p_direccion WHERE id = p_id;
        SELECT 'Domicilio actualizado correctamente' AS mensaje;
    ELSE
        SELECT 'El domicilio no existe' AS mensaje;
    END IF;
END $$
DELIMITER ;


-- Fin procedimientos almacenados para la tabla DOMICILIO --

