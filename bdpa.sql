

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
