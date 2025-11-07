
-- Drop procedures existentes (para evitar errores al crear) --
DROP PROCEDURE IF EXISTS InsertarRol;
DROP PROCEDURE IF EXISTS ActualizarRol;
DROP PROCEDURE IF EXISTS EliminarRol;
DROP PROCEDURE IF EXISTS DarDeBajaRol;

DROP PROCEDURE IF EXISTS insertarPersonal;
DROP PROCEDURE IF EXISTS ActualizarPersonal;
DROP PROCEDURE IF EXISTS EliminarPersonal;
DROP PROCEDURE IF EXISTS DarDeBajaPersonal;

DROP PROCEDURE IF EXISTS paInsertarDomicilio;
DROP PROCEDURE IF EXISTS PaModificarDomicilio;
DROP PROCEDURE IF EXISTS paEliminarDomicilio;
DROP PROCEDURE IF EXISTS paActualizarEstadoDomicilio;

DROP PROCEDURE IF EXISTS insertarCentroSalud;
DROP PROCEDURE IF EXISTS ActualizarCentroSalud;
DROP PROCEDURE IF EXISTS EliminarCentroSalud;
DROP PROCEDURE IF EXISTS DarDeBajaCentroSalud;

DROP PROCEDURE IF EXISTS insertarConsultorio;
DROP PROCEDURE IF EXISTS ActualizarConsultorio;
DROP PROCEDURE IF EXISTS EliminarConsultorio;
DROP PROCEDURE IF EXISTS DarDeBajaConsultorio;

DROP PROCEDURE IF EXISTS insertarEspecialidad;
DROP PROCEDURE IF EXISTS ActualizarEspecialidad;
DROP PROCEDURE IF EXISTS EliminarEspecialidad;
DROP PROCEDURE IF EXISTS DarDeBajaEspecialidad;

DROP PROCEDURE IF EXISTS insertarMedico;
DROP PROCEDURE IF EXISTS ActualizarMedico;
DROP PROCEDURE IF EXISTS EliminarMedico;
DROP PROCEDURE IF EXISTS DarDeBajaMedico;

DROP PROCEDURE IF EXISTS insertarPaciente;
DROP PROCEDURE IF EXISTS ActualizarPaciente;
DROP PROCEDURE IF EXISTS EliminarPaciente;

DROP PROCEDURE IF EXISTS insertarCalificacionCita;
DROP PROCEDURE IF EXISTS ActualizarCalificacionCita;
DROP PROCEDURE IF EXISTS EliminarCalificacionCita;

DROP PROCEDURE IF EXISTS insertarCita;
DROP PROCEDURE IF EXISTS ActualizarCita;
DROP PROCEDURE IF EXISTS EliminarCita;
DROP PROCEDURE IF EXISTS CancelarCita;

DROP PROCEDURE IF EXISTS sp_crear_programacion_y_horarios;


-- Procedimientos almacenados para la tabla ROL --

DELIMITER $$

CREATE PROCEDURE InsertarRol(
    IN v_nombre VARCHAR(255),
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0; 
    END;

    SELECT COUNT(*) INTO v_existe 
    FROM ROL 
    WHERE LOWER(nombre) = LOWER(v_nombre);

    IF v_existe > 0 THEN
        SET resultado = -1;
    ELSE
        INSERT INTO ROL(nombre, estado)
        VALUES (v_nombre, 'A');
        SET resultado = 1;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE ActualizarRol(
    IN v_id INT,
    IN v_nombre VARCHAR(255),
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0; 
    END;

    SELECT COUNT(*) INTO v_existe FROM ROL WHERE id = v_id;

    IF v_existe = 0 THEN
        SET resultado = -1; 
    ELSE
        UPDATE ROL
        SET nombre = v_nombre
        WHERE id = v_id;
        SET resultado = 1; 
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE EliminarRol(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0; 
    END;

    SELECT COUNT(*) INTO v_existe FROM ROL WHERE id = v_id;

    IF v_existe > 0 THEN
        DELETE FROM ROL WHERE id = v_id;
        SET resultado = 1; 
    ELSE
        SET resultado = -1; 
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE DarDeBajaRol(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_estado CHAR(1) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0; 
    END;

    SELECT COUNT(*), estado INTO v_existe, v_estado FROM ROL WHERE id = v_id;

    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE

        IF v_estado = 'I' THEN
            SET resultado = -1;
        ELSE
            UPDATE ROL SET estado = 'I' WHERE id = v_id;
            SET resultado = 1; 
        END IF;

    END IF;

END $$

DELIMITER ;

-- Fin procedimientos almacenados para la tabla Rol --

-- Procedimientos almacenados para la tabla PERSONAL --

DELIMITER $$
CREATE PROCEDURE insertarPersonal(
    IN v_DNI CHAR(8),
    IN v_nombre VARCHAR(255),
    IN v_ape_paterno VARCHAR(255),
    IN v_ape_materno VARCHAR(255),
    IN v_email VARCHAR(255),
    IN v_clave VARCHAR(255),
    IN v_foto_perfil VARCHAR(255),
    IN v_telefono CHAR(9),
    IN v_ROLid INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE v_rol INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0; 
    END;

 
    SELECT COUNT(*) INTO v_cnt FROM PERSONAL WHERE DNI = v_DNI;
    IF v_cnt > 0 THEN
        SET resultado = -1; 
    ELSE
        
        SELECT COUNT(*) INTO v_rol FROM ROL WHERE id = v_ROLid;
        IF v_rol = 0 THEN
            SET resultado = -1; 
        ELSE
            INSERT INTO PERSONAL(DNI, nombre, ape_paterno, ape_materno, email, clave, foto_perfil, telefono, estado, ROLid)
            VALUES (v_DNI, v_nombre, v_ape_paterno, v_ape_materno, v_email, v_clave, v_foto_perfil, v_telefono, 'A', v_ROLid);
            SET resultado = 1; 
        END IF;
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE ActualizarPersonal(
    IN v_id INT,
    IN v_DNI CHAR(8),
    IN v_nombre VARCHAR(255),
    IN v_ape_paterno VARCHAR(255),
    IN v_ape_materno VARCHAR(255),
    IN v_email VARCHAR(255),
    IN v_clave VARCHAR(255),
    IN v_foto_perfil VARCHAR(255),
    IN v_telefono CHAR(9),
    IN v_ROLid INT,
    IN v_estado BOOLEAN,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_cnt_dni INT DEFAULT 0;
    DECLARE v_rol INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0; 
    END;

    
    SELECT COUNT(*) INTO v_existe FROM PERSONAL WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1; 
    ELSE
 
        SELECT COUNT(*) INTO v_cnt_dni FROM PERSONAL WHERE DNI = v_DNI AND id <> v_id;
        IF v_cnt_dni > 0 THEN
            SET resultado = -1; 
        ELSE
         
            SELECT COUNT(*) INTO v_rol FROM ROL WHERE id = v_ROLid;
            IF v_rol = 0 THEN
                SET resultado = -1; 
            ELSE
                UPDATE PERSONAL
                SET DNI = v_DNI,
                    nombre = v_nombre,
                    ape_paterno = v_ape_paterno,
                    ape_materno = v_ape_materno,
                    email = v_email,
                    clave = v_clave,
                    foto_perfil = v_foto_perfil,
                    telefono = v_telefono,
                    ROLid = v_ROLid,
                    estado = IF(v_estado, 'A', 'I')
                WHERE id = v_id;

                SET resultado = 1; 
            END IF;
        END IF;
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE EliminarPersonal(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0; 
    END;

    SELECT COUNT(*) INTO v_existe FROM PERSONAL WHERE id = v_id;
    IF v_existe > 0 THEN
        DELETE FROM PERSONAL WHERE id = v_id;
        SET resultado = 1; 
    ELSE
        SET resultado = -1; 
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE DarDeBajaPersonal(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_estado CHAR(1) DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0; 
    END;

    SELECT COUNT(*), estado INTO v_existe, v_estado FROM PERSONAL WHERE id = v_id;

    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE
        IF v_estado = 'I' THEN
            SET resultado = -1; 
        ELSE
            UPDATE PERSONAL SET estado = 'I' WHERE id = v_id;
            SET resultado = 1; 
        END IF;
    END IF;
END $$
DELIMITER ;

-- Fin procedimientos almacenados para la tabla PERSONAL --


-- Procedimientos almacenados para la tabla DOMICILO --

DELIMITER $$

CREATE PROCEDURE paInsertarDomicilio (
    IN v_nombre VARCHAR(255),
    IN v_direccion VARCHAR(255),
    IN v_latitud DOUBLE,
    IN v_longitud DOUBLE,
    IN v_PACIENTEid INT,
    OUT resultado INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN 
        SET resultado = 0;
    END;

    INSERT INTO Domicilio(nombre, direccion, estado, latitud, longitud, PACIENTEid)
    VALUES (v_nombre, v_direccion, 'A', v_latitud, v_longitud, v_PACIENTEid);

    SET resultado = 1;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE PaModificarDomicilio (
    in v_id INT,
    IN v_nombre VARCHAR(255),
    IN v_direccion VARCHAR(255),
    IN v_latitud DOUBLE,
    IN v_longitud DOUBLE,
    IN v_PACIENTEid INT,
    OUT resultado INT
)

BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN 
        SET resultado = 0;
    END;
    UPDATE domicilio 
    SET nombre = v_nombre,
        direccion = v_direccion,
        latitud = v_latitud,
        longitud = v_longitud,
        PACIENTEid = v_PACIENTEid
    WHERE id = v_id;
    SET resultado = 1;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE paEliminarDomicilio(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
	 DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN 
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe 
    FROM domicilio
    WHERE id = v_id;

    IF v_existe > 0 THEN
        DELETE FROM domicilio
        WHERE id = v_id;
        SET resultado = 1; 
    ELSE
        SET resultado = -1; 
    END IF;

END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE paActualizarEstadoDomicilio(
    in v_id INT,
    OUT resultado int
)

BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_estado CHAR(1) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN 
        SET resultado = 0;
    END;

    SELECT COUNT(*), estado INTO v_existe, v_estado FROM domicilio WHERE id = v_id;

    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE
        IF v_estado = 'I' THEN
            SET resultado = -1;
        ELSE
            UPDATE domicilio SET estado = 'I' WHERE id = v_id;
            SET resultado = 1;
        END IF;
    END IF;

END $$
DELIMITER ; 



-- Fin procedimientos almacenados para la tabla DOMICILIO --

-- Procedimientos almacenados para CENTRO_SALUD --

DELIMITER $$
CREATE PROCEDURE insertarCentroSalud(
    IN v_nombre VARCHAR(255),
    IN v_direccion VARCHAR(255),
    IN v_telefono CHAR(9),
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0; 
    END;
 
        SELECT COUNT(*) INTO v_existe
        FROM CENTRO_SALUD
        WHERE (LOWER(nombre) = LOWER(v_nombre)
               OR LOWER(direccion) = LOWER(v_direccion)
               OR telefono = v_telefono);

        IF v_existe > 0 THEN
            SET resultado = -1; 
        ELSE
            INSERT INTO CENTRO_SALUD(nombre, direccion, telefono, estado)
            VALUES (v_nombre, v_direccion, v_telefono, 'A');
            SET resultado = 1;
        END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE ActualizarCentroSalud(
    IN v_id INT,
    IN v_nombre VARCHAR(255),
    IN v_direccion VARCHAR(255),
    IN v_telefono CHAR(9),
    IN v_estado BOOLEAN,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_duplicado INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM CENTRO_SALUD WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1; 
    ELSE

            SELECT COUNT(*) INTO v_duplicado
            FROM CENTRO_SALUD
            WHERE (LOWER(nombre) = LOWER(v_nombre)
                   OR LOWER(direccion) = LOWER(v_direccion)
                   OR telefono = v_telefono)
              AND id <> v_id;

            IF v_duplicado > 0 THEN
                SET resultado = -1; 
            ELSE
                UPDATE CENTRO_SALUD
                SET nombre = v_nombre,
                    direccion = v_direccion,
                    telefono = v_telefono,
                    estado = IF(v_estado, 'A', 'I')
                WHERE id = v_id;
                SET resultado = 1;
        END IF;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE EliminarCentroSalud(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM CENTRO_SALUD WHERE id = v_id;
    IF v_existe > 0 THEN
        DELETE FROM CENTRO_SALUD WHERE id = v_id;
        SET resultado = 1;
    ELSE
        SET resultado = -1;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE DarDeBajaCentroSalud(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_estado CHAR(1) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*), estado INTO v_existe, v_estado FROM CENTRO_SALUD WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE
        IF v_estado = 'I' THEN
            SET resultado = -1; 
        ELSE
            UPDATE CENTRO_SALUD SET estado = 'I' WHERE id = v_id;
            SET resultado = 1;
        END IF;
    END IF;
END $$

DELIMITER ;


-- Procedimientos almacenados para CONSULTORIO
DELIMITER $$
CREATE PROCEDURE insertarConsultorio(
    IN v_nombre VARCHAR(255),
    IN v_CENTRO_SALUDid INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_centro INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_centro FROM CENTRO_SALUD WHERE id = v_CENTRO_SALUDid;
    IF v_centro = 0 THEN
        SET resultado = -1; 
    ELSE
        INSERT INTO CONSULTORIO(nombre, estado, id_centro_salud)
        VALUES (v_nombre, 'A', v_CENTRO_SALUDid);
        SET resultado = 1;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE ActualizarConsultorio(
    IN v_id INT,
    IN v_nombre VARCHAR(255),
    IN v_CENTRO_SALUDid INT,
    IN v_estado BOOLEAN,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_centro INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM CONSULTORIO WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE
        SELECT COUNT(*) INTO v_centro FROM CENTRO_SALUD WHERE id = v_CENTRO_SALUDid;
        IF v_centro = 0 THEN
            SET resultado = -1; 
        ELSE
            UPDATE CONSULTORIO
            SET nombre = v_nombre,
                id_centro_salud = v_CENTRO_SALUDid,
                estado = IF(v_estado, 'A', 'I')
            WHERE id = v_id;
            SET resultado = 1;
        END IF;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE EliminarConsultorio(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM CONSULTORIO WHERE id = v_id;
    IF v_existe > 0 THEN
        DELETE FROM CONSULTORIO WHERE id = v_id;
        SET resultado = 1;
    ELSE
        SET resultado = -1;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE DarDeBajaConsultorio(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_estado CHAR(1) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*), estado INTO v_existe, v_estado FROM CONSULTORIO WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE
        IF v_estado = 'I' THEN
            SET resultado = -1;
        ELSE
            UPDATE CONSULTORIO SET estado = 'I' WHERE id = v_id;
            SET resultado = 1;
        END IF;
    END IF;
END $$

DELIMITER ;

---Fin de Procedimientos almacenados para CONSULTORIO 

-- Procedimientos almacenados para ESPECIALIDAD
DELIMITER $$
CREATE PROCEDURE insertarEspecialidad(
    IN v_nombre VARCHAR(255),
    IN v_descripcion VARCHAR(255),
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM ESPECIALIDAD WHERE LOWER(nombre) = LOWER(v_nombre);
    IF v_existe > 0 THEN
        SET resultado = -1; 
    ELSE
        INSERT INTO ESPECIALIDAD(nombre, estado, descripcion)
        VALUES (v_nombre, 'A', v_descripcion);
        SET resultado = 1;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE ActualizarEspecialidad(
    IN v_id INT,
    IN v_nombre VARCHAR(255),
    IN v_descripcion VARCHAR(255),
    IN v_estado BOOLEAN,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_otra INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM ESPECIALIDAD WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE
        SELECT COUNT(*) INTO v_otra FROM ESPECIALIDAD WHERE LOWER(nombre) = LOWER(v_nombre) AND id <> v_id;
        IF v_otra > 0 THEN
            SET resultado = -1;
        ELSE
            UPDATE ESPECIALIDAD
            SET nombre = v_nombre,
                descripcion = v_descripcion,
                estado = IF(v_estado, 'A', 'I')
            WHERE id = v_id;
            SET resultado = 1;
        END IF;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE EliminarEspecialidad(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM ESPECIALIDAD WHERE id = v_id;
    IF v_existe > 0 THEN
        DELETE FROM ESPECIALIDAD WHERE id = v_id;
        SET resultado = 1;
    ELSE
        SET resultado = -1;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE DarDeBajaEspecialidad(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_estado CHAR(1) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*), estado INTO v_existe, v_estado FROM ESPECIALIDAD WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE
        IF v_estado = 'I' THEN
            SET resultado = -1;
        ELSE
            UPDATE ESPECIALIDAD SET estado = 'I' WHERE id = v_id;
            SET resultado = 1;
        END IF;
    END IF;
END $$

DELIMITER ;


-- Procedimientos almacenados para MEDICO
DELIMITER $$
CREATE PROCEDURE insertarMedico(
    IN v_nombres VARCHAR(255),
    IN v_ape_paterno VARCHAR(255),
    IN v_ape_materno VARCHAR(255),
    IN v_DNI CHAR(8),
    IN v_email VARCHAR(255),
    IN v_telefono CHAR(9),
    IN v_id_personal_validado INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_cnt FROM MEDICO WHERE DNI = v_DNI;
    IF v_cnt > 0 THEN
        SET resultado = -1; 
    ELSE
        INSERT INTO MEDICO(nombres, ape_paterno, ape_materno, DNI, email, telefono, estado, id_personal_validado)
        VALUES (v_nombres, v_ape_paterno, v_ape_materno, v_DNI, v_email, v_telefono, 'A', v_id_personal_validado);
        SET resultado = 1;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE ActualizarMedico(
    IN v_id INT,
    IN v_nombres VARCHAR(255),
    IN v_ape_paterno VARCHAR(255),
    IN v_ape_materno VARCHAR(255),
    IN v_DNI CHAR(8),
    IN v_email VARCHAR(255),
    IN v_telefono CHAR(9),
    IN v_estado BOOLEAN,
    IN v_id_personal_validado INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM MEDICO WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE
        SELECT COUNT(*) INTO v_cnt FROM MEDICO WHERE DNI = v_DNI AND id <> v_id;
        IF v_cnt > 0 THEN
            SET resultado = -1; 
        ELSE
            UPDATE MEDICO
            SET nombres = v_nombres,
                ape_paterno = v_ape_paterno,
                ape_materno = v_ape_materno,
                DNI = v_DNI,
                email = v_email,
                telefono = v_telefono,
                estado = IF(v_estado, 'A', 'I'),
                id_personal_validado = v_id_personal_validado
            WHERE id = v_id;
            SET resultado = 1;
        END IF;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE EliminarMedico(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM MEDICO WHERE id = v_id;
    IF v_existe > 0 THEN
        DELETE FROM MEDICO WHERE id = v_id;
        SET resultado = 1;
    ELSE
        SET resultado = -1;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE DarDeBajaMedico(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_estado CHAR(1) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*), estado INTO v_existe, v_estado FROM MEDICO WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE
        IF v_estado = 'I' THEN
            SET resultado = -1;
        ELSE
            UPDATE MEDICO SET estado = 'I' WHERE id = v_id;
            SET resultado = 1;
        END IF;
    END IF;
END $$

DELIMITER ;
---fin de Procedimientos almacenados para MEDICO

-- Procedimientos almacenados para PACIENTE 
DELIMITER $$
CREATE PROCEDURE insertarPaciente(
    IN v_DNI CHAR(8),
    IN v_nombres VARCHAR(255),
    IN v_ape_paterno VARCHAR(255),
    IN v_ape_materno VARCHAR(255),
    IN v_f_nacimiento DATE,
    IN v_telefono CHAR(9),
    IN v_email VARCHAR(255),
    IN v_clave VARCHAR(255),
    IN v_foto_perfil VARCHAR(255),
    IN v_nombre_emergencia VARCHAR(255),
    IN v_numero_emergencia CHAR(9),
    IN v_relacion_emergencia VARCHAR(255),
    OUT resultado INT
)
BEGIN
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_cnt FROM PACIENTE WHERE DNI = v_DNI;
    IF v_cnt > 0 THEN
        SET resultado = -1;
    ELSE
        INSERT INTO PACIENTE(DNI, nombres, ape_paterno, ape_materno, f_nacimiento, telefono, email, clave, foto_perfil, nombre_emergencia, numero_emergencia, relacion_emergencia)
        VALUES (v_DNI, v_nombres, v_ape_paterno, v_ape_materno, v_f_nacimiento, v_telefono, v_email, v_clave, v_foto_perfil, v_nombre_emergencia, v_numero_emergencia, v_relacion_emergencia);
        SET resultado = 1;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE ActualizarPaciente(
    IN v_id INT,
    IN v_DNI CHAR(8),
    IN v_nombres VARCHAR(255),
    IN v_ape_paterno VARCHAR(255),
    IN v_ape_materno VARCHAR(255),
    IN v_f_nacimiento DATE,
    IN v_telefono CHAR(9),
    IN v_email VARCHAR(255),
    IN v_clave VARCHAR(255),
    IN v_foto_perfil VARCHAR(255),
    IN v_nombre_emergencia VARCHAR(255),
    IN v_numero_emergencia CHAR(9),
    IN v_relacion_emergencia VARCHAR(255),
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM PACIENTE WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE
        SELECT COUNT(*) INTO v_cnt FROM PACIENTE WHERE DNI = v_DNI AND id <> v_id;
        IF v_cnt > 0 THEN
            SET resultado = -1; 
        ELSE
            UPDATE PACIENTE
            SET DNI = v_DNI,
                nombres = v_nombres,
                ape_paterno = v_ape_paterno,
                ape_materno = v_ape_materno,
                f_nacimiento = v_f_nacimiento,
                telefono = v_telefono,
                email = v_email,
                clave = v_clave,
                foto_perfil = v_foto_perfil,
                nombre_emergencia = v_nombre_emergencia,
                numero_emergencia = v_numero_emergencia,
                relacion_emergencia = v_relacion_emergencia
            WHERE id = v_id;
            SET resultado = 1;
        END IF;
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE EliminarPaciente(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM PACIENTE WHERE id = v_id;
    IF v_existe > 0 THEN
        DELETE FROM PACIENTE WHERE id = v_id;
        SET resultado = 1;
    ELSE
        SET resultado = -1;
    END IF;
END $$

DELIMITER ;

-- Fin procedimientos almacenados para PACIENTE --

-- Inserto procedimientos para CALIFICACION_CITA

DELIMITER $$
CREATE PROCEDURE insertarCalificacionCita(
    IN v_id_cita INT,
    IN v_puntuacion INT,
    IN v_comentario TEXT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_ya INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM CITA WHERE id = v_id_cita;
    IF v_existe = 0 THEN
        SET resultado = -1; 
    ELSE
        SELECT COUNT(*) INTO v_ya FROM CALIFICACION_CITA WHERE id_cita = v_id_cita;
        IF v_ya > 0 THEN
            SET resultado = -1; 

        ELSE
            INSERT INTO CALIFICACION_CITA(id_cita, puntuacion, comentarion, fecha_creacion)
            VALUES (v_id_cita, v_puntuacion, v_comentario, NOW());
            SET resultado = 1;
        END IF;
    END IF;
END $$

DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ActualizarCalificacionCita(
    IN v_id_cita INT,
    IN v_puntuacion INT,
    IN v_comentario TEXT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM CALIFICACION_CITA WHERE id_cita = v_id_cita;
    IF v_existe = 0 THEN
        SET resultado = -1; 

    ELSE
        UPDATE CALIFICACION_CITA
        SET puntuacion = v_puntuacion,
            comentarion = v_comentario,
            fecha_creacion = NOW()
        WHERE id_cita = v_id_cita;
        SET resultado = 1;
    END IF;
END $$

DELIMITER ;

DELIMITER $$
CREATE PROCEDURE EliminarCalificacionCita(
    IN v_id_cita INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM CALIFICACION_CITA WHERE id_cita = v_id_cita;
    IF v_existe = 0 THEN
        SET resultado = -1; 
    ELSE
        DELETE FROM CALIFICACION_CITA WHERE id_cita = v_id_cita;
        SET resultado = 1;
    END IF;
END $$

DELIMITER ;



-- Fin procedimientos CALIFICACION_CITA

-- Procedimientos almacenados para la tabla CITA

DELIMITER $$

CREATE PROCEDURE insertarCita(
    IN v_id_paciente INT,
    IN v_tipo_atencion CHAR(1),
    IN v_direccion_domicilio VARCHAR(255),
    IN v_TURNOid INT,
    OUT resultado INT
)
insertarCita: BEGIN  
    DECLARE v_paciente INT DEFAULT 0;
    DECLARE v_turno INT DEFAULT 0;
    DECLARE v_turno_estado CHAR(1) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_paciente FROM PACIENTE WHERE id = v_id_paciente;
    IF v_paciente = 0 THEN
        SET resultado = -1; 
        LEAVE insertarCita;
    END IF;

    SELECT COUNT(*), estado INTO v_turno, v_turno_estado FROM TURNO WHERE id = v_TURNOid;
    IF v_turno = 0 THEN
        SET resultado = -1; 
        LEAVE insertarCita;
    END IF;

    IF v_turno_estado <> 'D' THEN
        SET resultado = -1; 
        LEAVE insertarCita;
    END IF;

    INSERT INTO CITA(id_paciente, tipo_atencion, direccion_domicilio, estado, codigo_qr, fecha_creacion, TURNOid)
    VALUES (v_id_paciente, v_tipo_atencion, v_direccion_domicilio, 'P', '', NOW(), v_TURNOid);

    SET resultado = 1;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE ActualizarCita(
    IN v_id INT,
    IN v_id_paciente INT,
    IN v_tipo_atencion CHAR(1),
    IN v_direccion_domicilio VARCHAR(255),
    IN v_TURNOid INT,
    OUT resultado INT
)
ActualizarCita: BEGIN  
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_turno INT DEFAULT 0;
    DECLARE v_turno_estado CHAR(1) DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM CITA WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1; 
        LEAVE ActualizarCita;
    END IF;

    IF v_TURNOid IS NOT NULL THEN
        SELECT COUNT(*), estado INTO v_turno, v_turno_estado FROM TURNO WHERE id = v_TURNOid;
        IF v_turno = 0 THEN
            SET resultado = -1; 
            LEAVE ActualizarCita;
        END IF;

        IF v_turno_estado <> 'D' THEN
            SET resultado = -1; 
            LEAVE ActualizarCita;
        END IF;
    END IF;

    UPDATE CITA
    SET id_paciente = v_id_paciente,
        tipo_atencion = v_tipo_atencion,
        direccion_domicilio = v_direccion_domicilio,
        TURNOid = v_TURNOid
    WHERE id = v_id;

    SET resultado = 1;
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE EliminarCita(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*) INTO v_existe FROM CITA WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE
        DELETE FROM CITA WHERE id = v_id;
        SET resultado = 1;
    END IF;
END $$

DELIMITER ;

DELIMITER $$
CREATE PROCEDURE CancelarCita(
    IN v_id INT,
    OUT resultado INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_estado CHAR(1) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET resultado = 0;
    END;

    SELECT COUNT(*), estado INTO v_existe, v_estado FROM CITA WHERE id = v_id;
    IF v_existe = 0 THEN
        SET resultado = -1;
    ELSE
        IF v_estado = 'C' THEN
            SET resultado = -1; 
        ELSE
            UPDATE CITA SET estado = 'C' WHERE id = v_id;
            SET resultado = 1;
        END IF;
    END IF;
END $$

DELIMITER ;



-- Fin procedimientos almacenados para la tabla CITA

-- cREAT PROGRAMACION Y HORARIOS
DELIMITER $$
CREATE PROCEDURE sp_crear_programacion_y_horarios(
    IN  p_fecha_inicial DATE,
    IN  p_fecha_final   DATE,
    IN  p_MEDICOid      INT,
    IN  p_CONSULTORIOid INT,
    IN  p_ESPECIALIDADid INT,
    IN  p_detalle JSON,          -- arreglo JSON con los días y horas
    OUT p_codigo INT             -- 1 éxito, -1 error usuario, 0 error sistema
)
proc:BEGIN
    DECLARE v_prog_id INT;
    DECLARE v_today DATE;
    DECLARE v_len INT;
    DECLARE v_i INT;

    -- Variables por item JSON
    DECLARE v_dia_semana VARCHAR(20);
    DECLARE v_hora_ini TIME;
    DECLARE v_hora_fin TIME;
    DECLARE v_duracion INT;
    DECLARE v_dia_num INT;  -- 0=Mon ... 6=Sun (como WEEKDAY())

    -- Manejadores de error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_codigo = 0; -- error de sistema
    END;

    START TRANSACTION;

    -- Validaciones de usuario
    IF p_fecha_inicial IS NULL OR p_fecha_final IS NULL
       OR p_MEDICOid IS NULL OR p_CONSULTORIOid IS NULL OR p_ESPECIALIDADid IS NULL
    THEN
        SET p_codigo = -1; ROLLBACK; LEAVE proc;
    END IF;

    IF p_fecha_final < p_fecha_inicial THEN
        SET p_codigo = -1; ROLLBACK; LEAVE proc;
    END IF;

    -- Existen llaves foráneas?
    IF (SELECT COUNT(*) FROM MEDICO WHERE id = p_MEDICOid) = 0
       OR (SELECT COUNT(*) FROM CONSULTORIO WHERE id = p_CONSULTORIOid) = 0
       OR (SELECT COUNT(*) FROM ESPECIALIDAD WHERE id = p_ESPECIALIDADid) = 0
    THEN
        SET p_codigo = -1; ROLLBACK; LEAVE proc;
    END IF;

    -- Validar JSON
    IF p_detalle IS NULL OR JSON_TYPE(p_detalle) <> 'ARRAY' OR JSON_LENGTH(p_detalle) = 0 THEN
        SET p_codigo = -1; ROLLBACK; LEAVE proc;
    END IF;

    -- Crear la PROGRAMACION (estado activo = 'A')
    INSERT INTO PROGRAMACION(fecha_inicial, fecha_final, estado, MEDICOid, CONSULTORIOid, ESPECIALIDADid)
    VALUES (p_fecha_inicial, p_fecha_final, 'A', p_MEDICOid, p_CONSULTORIOid, p_ESPECIALIDADid);

    SET v_prog_id = LAST_INSERT_ID();

    -- Recorremos todas las fechas
    SET v_today = p_fecha_inicial;

    WHILE v_today <= p_fecha_final DO
        -- WEEKDAY(): 0=Monday ... 6=Sunday
        SET v_dia_num = WEEKDAY(v_today);

        -- Recorremos cada item del JSON y si coincide el día, insertamos un HORARIO para esa fecha
        SET v_len = JSON_LENGTH(p_detalle);
        SET v_i = 0;
        WHILE v_i < v_len DO
            SET v_dia_semana = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_i, '].dia_semana')));
            SET v_hora_ini   = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_i, '].hora_inicial')));
            SET v_hora_fin   = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_i, '].hora_final')));
            SET v_duracion   = JSON_EXTRACT(p_detalle,  CONCAT('$[', v_i, '].duracion_minutos'));

            IF v_duracion IS NULL OR v_duracion <= 0 THEN
                SET v_duracion = 60; -- por defecto 60 minutos
            END IF;

            -- Validación de horas
            IF v_hora_ini IS NULL OR v_hora_fin IS NULL OR v_hora_ini >= v_hora_fin THEN
                SET p_codigo = -1; ROLLBACK; LEAVE proc;
            END IF;

            -- Mapear texto español a número estilo WEEKDAY()
            -- 0=Lunes, 1=Martes, 2=Miércoles, 3=Jueves, 4=Viernes, 5=Sábado, 6=Domingo
            CASE UPPER(v_dia_semana)
                WHEN 'LUNES'      THEN SET @need = 0;
                WHEN 'MARTES'     THEN SET @need = 1;
                WHEN 'MIERCOLES'  THEN SET @need = 2;
                WHEN 'MIÉRCOLES'  THEN SET @need = 2;
                WHEN 'JUEVES'     THEN SET @need = 3;
                WHEN 'VIERNES'    THEN SET @need = 4;
                WHEN 'SABADO'     THEN SET @need = 5;
                WHEN 'SÁBADO'     THEN SET @need = 5;
                WHEN 'DOMINGO'    THEN SET @need = 6;
                ELSE SET @need = -9; -- inválido
            END CASE;

            IF @need = -9 THEN
                SET p_codigo = -1; ROLLBACK; LEAVE proc; -- día inválido en JSON
            END IF;

            -- Si el día coincide con la fecha actual, insertamos el HORARIO (uno por fecha)
            IF v_dia_num = @need THEN
                INSERT INTO HORARIO(hora_inicial, hora_final, dia_semana, estado, PROGRAMACIONid, fecha, duracion_minutos)
                VALUES (v_hora_ini, v_hora_fin, v_dia_semana, 'A', v_prog_id, v_today, v_duracion);
                -- Los TURNO(s) se crean automáticamente por el trigger
            END IF;

            SET v_i = v_i + 1;
        END WHILE;

        SET v_today = DATE_ADD(v_today, INTERVAL 1 DAY);
    END WHILE;

    COMMIT;
    SET p_codigo = 1; -- éxito
END$$
DELIMITER ;

-- TRIGGER TURNOS LUEGO DE INSERTAR EN HORARIO
DELIMITER $$
CREATE TRIGGER trg_horario_after_insert
AFTER INSERT ON HORARIO
FOR EACH ROW
BEGIN
    DECLARE slot_ini TIME;
    DECLARE slot_fin TIME;
    DECLARE paso_sec INT;

    SET paso_sec = NEW.duracion_minutos * 60;
    SET slot_ini = NEW.hora_inicial;

    WHILE slot_ini < NEW.hora_final DO
        SET slot_fin = ADDTIME(slot_ini, SEC_TO_TIME(paso_sec));
        IF slot_fin > NEW.hora_final THEN
            SET slot_fin = NEW.hora_final;
        END IF;

        INSERT INTO TURNO (hora_inicio, hora_fin, estado, HORARIOid)
        VALUES (slot_ini, slot_fin, 'D', NEW.id);

        SET slot_ini = slot_fin;
    END WHILE;
END$$
DELIMITER ;


