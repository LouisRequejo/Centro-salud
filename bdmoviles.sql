CREATE TABLE PACIENTE (id int(10) NOT NULL AUTO_INCREMENT, DNI char(8) NOT NULL, nombres varchar(255) NOT NULL, ape_paterno varchar(255) NOT NULL, ape_materno varchar(255) NOT NULL, f_nacimiento date NOT NULL, telefono char(9) NOT NULL, email varchar(255) NOT NULL, clave varchar(255) NOT NULL, foto_perfil varchar(255), nombre_emergencia varchar(255), numero_emergencia char(9), relacion_emergencia varchar(255), PRIMARY KEY (id));
CREATE TABLE CONSULTORIO (id int(10) NOT NULL AUTO_INCREMENT, nombre varchar(255) NOT NULL, estado char(1) NOT NULL, id_centro_salud int(10) NOT NULL, PRIMARY KEY (id));
CREATE TABLE NOTIFICACION (id int(10) NOT NULL AUTO_INCREMENT, id_tipo_notificacion int(10) NOT NULL, id_destinatario int(10), tipo_destinatario int(10), titulo int(10), mensaje int(10), fecha_creacion int(10), PRIMARY KEY (id));
CREATE TABLE PERSONAL (id int(10) NOT NULL AUTO_INCREMENT, DNI char(8) NOT NULL, nombre varchar(255) NOT NULL, ape_paterno varchar(255) NOT NULL, ape_materno varchar(255) NOT NULL, email varchar(255) NOT NULL, clave varchar(255) NOT NULL, foto_perfil varchar(255) NOT NULL, telefono char(9) NOT NULL, ROLid int(10) NOT NULL, PRIMARY KEY (id));
CREATE TABLE MEDICO (id int(10) NOT NULL AUTO_INCREMENT, nombres varchar(255) NOT NULL, ape_paterno varchar(255) NOT NULL, ape_materno varchar(255) NOT NULL, DNI char(8) NOT NULL UNIQUE, email varchar(255) NOT NULL, telefono char(9) NOT NULL, estado char(1) NOT NULL, id_personal_validado int(10), PRIMARY KEY (id));
CREATE TABLE ESPECIALIDAD (id int(10) NOT NULL AUTO_INCREMENT, nombre varchar(255) NOT NULL, descripcion varchar(255), PRIMARY KEY (id));
CREATE TABLE CENTRO_SALUD (id int(10) NOT NULL AUTO_INCREMENT, nombre varchar(255) NOT NULL, direccion varchar(255) NOT NULL, telefono char(9) NOT NULL, PRIMARY KEY (id));
CREATE TABLE CITA (id int(10) NOT NULL AUTO_INCREMENT, id_paciente int(10) NOT NULL, tipo_atencion char(1) NOT NULL comment 'P->Presencial
D->Domicilio', direccion_domicilio varchar(255) NOT NULL, estado char(1) NOT NULL comment 'P-> Pendiente
C->Cancelada
A->Atendida', codigo_qr varchar(255) NOT NULL comment 'direccion de la imagen del codigo qr generado para una cita', fecha_creacion timestamp NOT NULL, TURNOid int(10) NOT NULL, PRIMARY KEY (id));
CREATE TABLE CALIFICACION_CITA (id_cita int(10) NOT NULL, puntuacion int(10), comentarion text, fecha_creacion timestamp NULL, PRIMARY KEY (id_cita));
CREATE TABLE CHAT (id int(10) NOT NULL AUTO_INCREMENT, id_paciente int(10) NOT NULL, id_medico int(10) NOT NULL, fecha_creacion int(10), PRIMARY KEY (id));
CREATE TABLE MENSAJES_CHAT (id int(10), id_chat int(10) NOT NULL, id_emisor int(10), tipo_emisor int(10), contenido int(10), fecha_hora int(10), visto int(10));
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
CREATE TABLE ROL (id int(10) NOT NULL AUTO_INCREMENT, nombre int(10), PRIMARY KEY (id));
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

-- END PA --
