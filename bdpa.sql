

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
    IF NOT EXISTS (SELECT 1 FROM PERSONAL WHERE id = p_id) THEN
        SELECT 'El personal que intenta eliminar no existe' AS mensaje;
    ELSE
        DELETE FROM PERSONAL WHERE id = p_id;
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
        UPDATE PERSONAL SET DNI = p_DNI, NOMBRE = p_nombre, ape_paterno = p_ape_paterno, ape_materno = p_ape_materno, email = p_email, clave = p_clave, foto_perfil = p_foto_perfil, telefono = p_telefono, ROLid = p_ROLid, estado = p_estado
        WHERE ID = p_id;
        SELECT 'El personal ha sido actualizado correctamente' AS mensaje;
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE DarDeBajaPersonal(IN p_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PERSONAL WHERE ID = p_id) THEN
        SELECT 'El personal que intenta dar de baja no existe' AS mensaje;
    ELSEIF (SELECT 1 FROM PERSONAL WHERE ID = p_id and estado = FALSE) THEN
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

    update domicilio 
    SET nombre = v_nombre,
        direccion = v_direccion,
        latitud = v_latitud,
        longitud = v_longitud,
        PACIENTEid = v_PACIENTEid
    where v_id = id;
    set resultado = 1;
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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN 
        SET resultado = 0;
    END;
    
    UPDATE domicilio SET estado = 'I'
	 WHERE v_id = id;
    SET resultado = 1;
END $$
DELIMITER ; 



-- Fin procedimientos almacenados para la tabla DOMICILIO --


-- Inicio procedimeintos almacenados PROGRAMACION
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


