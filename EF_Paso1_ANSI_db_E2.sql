/********************************************** DDL **********************************************/
-- Validando Creación de Base de Datos (En caso de no existir)
DROP DATABASE IF EXISTS ansi_db;
CREATE DATABASE IF NOT EXISTS ansi_db;
USE ansi_db;

/** Creación de las Tablas **/
-- CÓDIGO POSTAL
CREATE TABLE codigo_postal (
id_codigo_postal INT NOT NULL AUTO_INCREMENT,
cp VARCHAR(7) NOT NULL,
c_estado VARCHAR(10) NOT NULL,
c_municipio VARCHAR(500) NOT NULL,
id_pais INT NOT NULL,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_codigo_postal),
KEY (cp)
);
-- DOMICILIO
CREATE TABLE domicilio (
id_domicilio INT NOT NULL AUTO_INCREMENT,
cp VARCHAR(7) NOT NULL,
colonia VARCHAR(50) NOT NULL,
calle VARCHAR(150) NOT NULL,
no_ext VARCHAR(50) NOT NULL,
no_int VARCHAR(50) NOT NULL,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_domicilio),
FOREIGN KEY (cp) REFERENCES codigo_postal(cp)
);
-- BENEFICIARIO
CREATE TABLE beneficiarios (
id_beneficiario INT NOT NULL AUTO_INCREMENT,
id_domicilio INT NOT NULL,
ap_paterno VARCHAR(50) NOT NULL,
ap_materno VARCHAR(50) NOT NULL,
nombre VARCHAR(100) NOT NULL,
fecha_nac DATE NOT NULL,
id_genero TINYINT NOT NULL,
id_tipo_seguro TINYINT NOT NULL,
no_afiliacion VARCHAR(15) NOT NULL,
clave_mem VARCHAR(25) NOT NULL,
fecha_ingreso DATE NOT NULL,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_beneficiario),
FOREIGN KEY (id_domicilio) REFERENCES domicilio(id_domicilio)
);
CREATE UNIQUE INDEX idx_clave_mem ON beneficiarios(clave_mem);
-- TUTORES
CREATE TABLE tutores (
id_tutor INT NOT NULL AUTO_INCREMENT,
id_beneficiario INT NOT NULL,
id_domicilio INT NOT NULL,
id_prioridad INT NOT NULL,
ap_paterno VARCHAR(50) NOT NULL,
ap_materno VARCHAR(50) NOT NULL,
nombre VARCHAR(100) NOT NULL,
id_parentesco TINYINT NOT NULL,
no_tel_1 VARCHAR(20) NOT NULL,
no_tel_2 VARCHAR(20) NOT NULL,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_tutor),
FOREIGN KEY (id_beneficiario) REFERENCES beneficiarios(id_beneficiario),
FOREIGN KEY (id_domicilio) REFERENCES domicilio(id_domicilio)
);
-- DISTRITO
CREATE TABLE distrito (
id_distrito INT NOT NULL AUTO_INCREMENT,
id_estatus TINYINT NOT NULL,
descripcion VARCHAR(50) NOT NULL,
abreviatura VARCHAR(10) NOT NULL,
fecha_fundacion DATE NOT NULL,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_distrito)
);
-- GRUPO
CREATE TABLE grupo (
id_grupo INT NOT NULL AUTO_INCREMENT,
id_distrito INT NOT NULL,
id_estatus TINYINT NOT NULL,
nombre VARCHAR(100) NOT NULL,
numero INT NOT NULL,
id_domicilio INT NOT NULL,
fecha_fundacion DATE NOT NULL,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_grupo),
FOREIGN KEY (id_distrito) REFERENCES distrito(id_distrito),
FOREIGN KEY (id_domicilio) REFERENCES domicilio(id_domicilio)
);
-- SECCION
CREATE TABLE seccion (
id_seccion INT NOT NULL AUTO_INCREMENT,
edad_inicial INT NOT NULL,
edad_final INT NOT NULL,
nombre VARCHAR(50) NOT NULL,
id_seccion_anterior INT NOT NULL,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_seccion)
);
-- ADELANTOS
CREATE TABLE adelantos (
id_adelantos INT NOT NULL AUTO_INCREMENT,
id_seccion INT NOT NULL,
descripcion VARCHAR(50) NOT NULL,
id_adelanto_anterior INT NOT NULL,
adelanto_terminal BIT NOT NULL,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_adelantos),
FOREIGN KEY (id_seccion) REFERENCES seccion(id_seccion)
);
-- RETOS
CREATE TABLE retos (
id_reto INT NOT NULL AUTO_INCREMENT,
id_adelantos INT NOT NULL,
id_categoria INT NOT NULL,
id_reto_anterior INT NOT NULL,
descripcion VARCHAR(500) NOT NULL,
predeterminado BIT NOT NULL,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_reto),
FOREIGN KEY (id_adelantos) REFERENCES adelantos(id_adelantos)
);
-- REGISTRO
CREATE TABLE registro (
id_registro INT NOT NULL AUTO_INCREMENT,
id_beneficiario INT NOT NULL,
id_distrito INT NOT NULL,
id_grupo INT NOT NULL,
id_estatus TINYINT NOT NULL,
id_seccion INT NOT NULL,
año INT NOT NULL,
fecha_inicio DATE NULL,
fecha_termino DATE NULL,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_registro),
FOREIGN KEY (id_beneficiario) REFERENCES beneficiarios(id_beneficiario),
FOREIGN KEY (id_distrito) REFERENCES distrito(id_distrito),
FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo),
FOREIGN KEY (id_seccion) REFERENCES seccion(id_seccion)
);
-- ADELANTO PROGRESIVO
CREATE TABLE adelanto_progresivo (
id_adelanto_progresivo INT NOT NULL AUTO_INCREMENT,
id_registro INT,
id_adelantos INT,
id_estatus TINYINT,
fecha_propuesta DATE,
fecha_real DATE,
observaciones VARCHAR(200),
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_adelanto_progresivo),
FOREIGN KEY (id_registro) REFERENCES registro(id_registro),
FOREIGN KEY (id_adelantos) REFERENCES adelantos(id_adelantos)
);
-- ADELANTO PROGRESIVO DETALLE
CREATE TABLE adelanto_progresivo_detalle (
id_detalles_adelanto INT NOT NULL AUTO_INCREMENT,
id_adelanto_progresivo INT,
id_reto INT,
completado BIT,
fecha_realizado DATE,
detalles VARCHAR(200),
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_detalles_adelanto),
FOREIGN KEY (id_adelanto_progresivo) REFERENCES adelanto_progresivo(id_adelanto_progresivo),
FOREIGN KEY (id_reto) REFERENCES retos(id_reto)
);
-- TABLAS
CREATE TABLE tablas (
id_tabla INT NOT NULL AUTO_INCREMENT,
nombre_tabla VARCHAR(50),
id_tipo TINYINT,
alias_tabla VARCHAR(50),
descripcion VARCHAR(500),
campo_llave VARCHAR(50),
PRIMARY KEY (id_tabla)
);
-- BITACORA TIPO
CREATE TABLE bitacora_tipo (
id_bitacora_tipo INT NOT NULL AUTO_INCREMENT,
id_tabla INT,
descripcion VARCHAR(200),
id_clasificacion TINYINT,
PRIMARY KEY (id_bitacora_tipo),
FOREIGN KEY (id_tabla) REFERENCES tablas(id_tabla)
);
-- CATALOGO TIPO
CREATE TABLE catalogo_tipo (
id_catalogo_tipo INT NOT NULL AUTO_INCREMENT,
id_tabla INT,
descripcion VARCHAR(50),
id_tipo_superior INT,
PRIMARY KEY (id_catalogo_tipo),
FOREIGN KEY (id_tabla) REFERENCES tablas(id_tabla)
);
-- CATALOGO
CREATE TABLE catalogo (
id_catalogo INT NOT NULL AUTO_INCREMENT,
id_catalogo_tipo INT,
id_catalogo_superior INT,
id_valor INT,
descripcion VARCHAR(50),
valor_alternativo VARCHAR(50),
PRIMARY KEY (id_catalogo),
FOREIGN KEY (id_catalogo_tipo) REFERENCES catalogo_tipo(id_catalogo_tipo)
);
-- USUARIO
CREATE TABLE usuario (
id_usuario INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(100),
email VARCHAR(100),
no_telefono VARCHAR(15),
clave_acceso VARCHAR(100),
sesiones_disponibles INT,
fecha_registro DATE,
duracion_sesion INT,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_usuario)
);
-- SESIÓN USUARIO
CREATE TABLE sesion_usuario (
id_sesion INT NOT NULL AUTO_INCREMENT,
id_usuario INT,
id_estatus_sesion TINYINT,
id_tipo_dispositivo TINYINT,
fecha_inicio DATETIME,
duracion_min INT,
nombre_disp VARCHAR(50),
PRIMARY KEY (id_sesion),
FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);
-- BITACORA
CREATE TABLE bitacora (
id_bitacora BIGINT NOT NULL AUTO_INCREMENT,
id_bitacora_tipo INT,
id_tabla INT,
id_registro INT,
fecha_bitacora DATETIME,
detalles VARCHAR(150),
id_sesion INT,
PRIMARY KEY (id_bitacora),
FOREIGN KEY (id_bitacora_tipo) REFERENCES bitacora_tipo(id_bitacora_tipo),
FOREIGN KEY (id_tabla) REFERENCES tablas(id_tabla)
);
-- PERFIL
CREATE TABLE perfil (
id_perfil INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(50),
detalles VARCHAR(150),
administrador BIT,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_perfil)
);
-- PERFIL USUARIO
CREATE TABLE perfil_usuario (
id_perfil_usuario INT NOT NULL AUTO_INCREMENT,
id_usuario INT,
id_perfil INT,
perfil_activo BIT,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_perfil_usuario),
FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil)
);
-- PERFIL ACCIONES
CREATE TABLE perfil_acciones (
id_perfil_acciones INT NOT NULL AUTO_INCREMENT,
id_perfil INT,
id_accion INT,
permitir BIT,
id_sesion_registro INT NOT NULL,
PRIMARY KEY (id_perfil_acciones),
FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil)
);

/********************************************** DML **********************************************/
-- Tablas Catalogo sin dependencia
DELIMITER %%
CREATE	PROCEDURE sp_bitacora
(tipo INT, p_id_bitacora BIGINT, p_id_bitacora_tipo INT, p_id_tabla INT, p_id_registro INT, 
 p_fecha_bitacora DATETIME, p_detalles VARCHAR(150), p_id_sesion INT)
BEGIN
	-- Validando Tipos
	IF tipo = 1
	THEN
		INSERT	INTO	bitacora
        (id_bitacora, id_bitacora_tipo, id_tabla, id_registro, fecha_bitacora, detalles, id_sesion)
        VALUES
        (NULL, p_id_bitacora_tipo, p_id_tabla, p_id_registro, p_fecha_bitacora, p_detalles, p_id_sesion);
	END IF;
END
%%
CREATE PROCEDURE sp_catalogo_tipo(tipo INT, p_id_catalogo_tipo INT, p_id_tabla INT, p_descripcion VARCHAR(50), 
p_id_tipo_superior INT)
BEGIN
	-- Validando Tipos
	IF tipo = 1
	THEN
		INSERT	INTO	catalogo_tipo
		(id_catalogo_tipo, id_tabla, descripcion, id_tipo_superior)
		VALUES
		(NULL, p_id_tabla, p_descripcion, p_id_tipo_superior);
	ELSEIF tipo = 2
    THEN
		UPDATE catalogo_tipo
        SET	id_tabla = p_id_tabla, 
			descripcion = p_descripcion, 
            id_tipo_superior = p_id_tipo_superior
		WHERE	id_catalogo_tipo = p_id_catalogo_tipo;
	ELSEIF tipo = 3
    THEN
		SELECT	id_catalogo_tipo, id_tabla, descripcion, id_tipo_superior
        FROM	catalogo_tipo
		WHERE	id_catalogo_tipo = p_id_catalogo_tipo;
	END IF;
END
%%
CREATE PROCEDURE sp_catalogo(tipo INT, p_id_catalogo INT, p_id_catalogo_tipo INT, p_id_catalogo_superior INT, 
p_id_valor INT, p_descripcion VARCHAR(50), p_valor_alternativo VARCHAR(50))
BEGIN
	-- Validando Tipos
	IF tipo = 1
	THEN
		INSERT	INTO	catalogo
		(id_catalogo, id_catalogo_tipo, id_catalogo_superior, id_valor, descripcion, valor_alternativo)
		VALUES
		(NULL, p_id_catalogo_tipo, p_id_catalogo_superior, p_id_valor, p_descripcion, p_valor_alternativo);
	ELSEIF tipo = 2
    THEN
		UPDATE catalogo
        SET	id_catalogo_tipo = p_id_catalogo_tipo, 
			id_catalogo_superior = p_id_catalogo_superior, 
            id_valor = p_id_valor, 
            descripcion = p_descripcion, 
            valor_alternativo = p_valor_alternativo
		WHERE	id_catalogo = p_id_catalogo;
	ELSEIF tipo = 3
    THEN
		SELECT	id_catalogo, id_catalogo_tipo, id_catalogo_superior, id_valor, descripcion, valor_alternativo
        FROM	catalogo
		WHERE	id_catalogo = p_id_catalogo;
	END IF;
END
%%
CREATE PROCEDURE sp_usuario(tipo INT, p_id_usuario INT, p_nombre VARCHAR(100), p_email VARCHAR(100), 
p_no_telefono VARCHAR(15), p_clave_acceso VARCHAR(100), p_sesiones_disponibles INT, p_fecha_registro DATE, 
p_duracion_sesion INT, p_id_sesion_registro INT)
BEGIN
	-- Validando Tipos
	IF tipo = 1
	THEN
		INSERT	INTO	usuario
		(id_usuario, nombre, email, no_telefono, clave_acceso, sesiones_disponibles, fecha_registro, 
         duracion_sesion, id_sesion_registro)
		VALUES
		(NULL, p_nombre, p_email, p_no_telefono, p_clave_acceso, p_sesiones_disponibles, p_fecha_registro, 
         p_duracion_sesion, p_id_sesion_registro);
	ELSEIF tipo = 2
    THEN
		UPDATE usuario
        SET	nombre = p_nombre, 
			email = p_email, 
            no_telefono = p_no_telefono, 
            clave_acceso = p_clave_acceso, 
            sesiones_disponibles = p_sesiones_disponibles, 
            fecha_registro = p_fecha_registro, 
			duracion_sesion = p_duracion_sesion, 
            id_sesion_registro = p_id_sesion_registro
		WHERE	id_usuario = p_id_usuario;
	ELSEIF tipo = 3
    THEN
		SELECT	id_usuario, nombre, email, no_telefono, clave_acceso, sesiones_disponibles, fecha_registro, duracion_sesion, id_sesion_registro
        FROM	usuario
		WHERE	id_usuario = p_id_usuario;
	END IF;
END
%%
CREATE TRIGGER t_ai_usuario BEFORE INSERT ON usuario FOR EACH ROW
BEGIN
	DECLARE conteo_registros INT;
    -- Validando Duplicidad de registros
    SELECT COUNT(*)
    INTO	conteo_registros
    FROM	usuario
	WHERE	email = NEW.email
    AND nombre = NEW.nombre;
    -- Validando # encontrados
    IF conteo_registros > 0
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El Usuario ya se encuentra dado de alta.';
    END IF;
END
%%
CREATE TRIGGER t_di_usuario AFTER INSERT ON usuario FOR EACH ROW
BEGIN
	CALL sp_bitacora(1, 0, 17, 17, NEW.id_usuario, CURRENT_TIMESTAMP(), '', NEW.id_sesion_registro);
END
%%
CREATE PROCEDURE sp_sesion_usuario(tipo INT, p_id_sesion INT, p_id_usuario INT, p_id_estatus_sesion TINYINT, 
p_id_tipo_dispositivo TINYINT, p_fecha_inicio DATETIME, p_duracion_min INT, p_nombre_disp VARCHAR(50))
BEGIN
	-- Validando Tipos
	IF tipo = 1
	THEN
		INSERT	INTO	sesion_usuario
		(id_sesion, id_usuario, id_estatus_sesion, id_tipo_dispositivo, fecha_inicio, 
         duracion_min, nombre_disp)
		VALUES
		(NULL, p_id_usuario, p_id_estatus_sesion, p_id_tipo_dispositivo, p_fecha_inicio, 
         p_duracion_min, p_nombre_disp);
	ELSEIF tipo = 2
    THEN
		UPDATE sesion_usuario
        SET	id_usuario = p_id_usuario, 
			id_estatus_sesion = p_id_estatus_sesion, 
            id_tipo_dispositivo = p_id_tipo_dispositivo, 
            fecha_inicio = p_fecha_inicio, 
			duracion_min = p_duracion_min, 
            nombre_disp = p_nombre_disp
		WHERE	id_sesion = p_id_sesion;
	ELSEIF tipo = 3
    THEN
		SELECT	id_sesion, id_usuario, id_estatus_sesion, id_tipo_dispositivo, fecha_inicio, duracion_min, nombre_disp
        FROM	sesion_usuario
		WHERE	id_sesion = p_id_sesion;
	END IF;
END
%%
CREATE PROCEDURE sp_distrito
(tipo INT, p_id_distrito INT, p_id_estatus TINYINT, p_descripcion VARCHAR(50), 
 p_abreviatura VARCHAR(10), p_fecha_fundacion DATE, p_id_sesion_registro INT)
BEGIN
	-- Validando Tipos
	IF tipo = 1
	THEN
		INSERT	INTO	distrito
		(id_distrito, id_estatus, descripcion, abreviatura, fecha_fundacion, id_sesion_registro)
		VALUES
		(NULL, p_id_estatus, p_descripcion, p_abreviatura, p_fecha_fundacion, p_id_sesion_registro);
	ELSEIF tipo = 2
    THEN
		UPDATE distrito
        SET	id_estatus = p_id_estatus, 
			descripcion = p_descripcion, 
            abreviatura = p_abreviatura, 
            fecha_fundacion = p_fecha_fundacion,
            id_sesion_registro = p_id_sesion_registro
		WHERE	id_distrito = p_id_distrito;
	ELSEIF tipo = 3
    THEN
		SELECT	id_distrito, id_estatus, descripcion, abreviatura, fecha_fundacion, id_sesion_registro
        FROM	distrito
		WHERE	id_distrito = p_id_distrito;
	END IF;
END
%%
CREATE TRIGGER t_ai_distrito BEFORE INSERT ON distrito FOR EACH ROW
BEGIN
	DECLARE conteo_registros INT;
    -- Validando Duplicidad de registros
    SELECT COUNT(*)
    INTO	conteo_registros
    FROM	distrito
	WHERE	descripcion = NEW.descripcion
    AND abreviatura = NEW.descripcion;
    -- Validando # encontrados
    IF conteo_registros > 0
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El Distrito ya se encuentra dado de alta.';
    END IF;
END
%%
CREATE TRIGGER t_di_distrito AFTER INSERT ON distrito FOR EACH ROW
BEGIN
	CALL sp_bitacora(1, 0, 6, 6, NEW.id_distrito, CURRENT_TIMESTAMP(), '', NEW.id_sesion_registro);
END
%%
CREATE PROCEDURE sp_domicilio(tipo INT, p_id_domicilio INT, p_cp VARCHAR(7), p_colonia VARCHAR(150), 
p_calle VARCHAR(150), p_no_ext VARCHAR(50), p_no_int VARCHAR(50), p_id_sesion_registro INT)
BEGIN
	-- Validando Tipos
	IF tipo = 1
	THEN
		INSERT	INTO	domicilio
		(id_domicilio, cp, colonia, calle, no_ext, no_int, id_sesion_registro)
		VALUES
		(NULL, p_cp, p_colonia, p_calle, p_no_ext, p_no_int, p_id_sesion_registro);
	ELSEIF tipo = 2
    THEN
		UPDATE domicilio
        SET	cp = p_cp, 
			colonia = p_colonia, 
			cale = p_calle, 
            no_ext = p_no_ext, 
            no_int = p_no_int,
            id_sesion_registro = p_id_sesion_registro
		WHERE	id_domicilio = p_id_domicilio;
	ELSEIF tipo = 3
    THEN
		SELECT	id_domicilio, cp, colonia, calle, no_ext, no_int, id_sesion_registro
        FROM	domicilio
		WHERE	id_domicilio = p_id_domicilio;
	END IF;
END
%%
CREATE TRIGGER t_di_domicilio AFTER INSERT ON domicilio FOR EACH ROW
BEGIN
	CALL sp_bitacora(1, 0, 7, 7, NEW.id_domicilio, CURRENT_TIMESTAMP(), '', NEW.id_sesion_registro);
END
%%
CREATE PROCEDURE sp_codigo_postal(tipo INT, p_id_codigo_postal INT, p_cp VARCHAR(7), p_c_estado VARCHAR(7), 
p_c_municipio VARCHAR(500), p_id_pais INT, p_id_sesion_registro INT)
BEGIN
	-- Validando Tipos
	IF tipo = 1
	THEN
		INSERT	INTO	codigo_postal
		(id_codigo_postal, cp, c_estado, c_municipio, id_pais, id_sesion_registro)
		VALUES
		(NULL, p_cp, p_c_estado, p_c_municipio, p_id_pais, p_id_sesion_registro);
	ELSEIF tipo = 2
    THEN
		UPDATE codigo_postal
        SET	cp = p_cp, 
			c_estado = p_c_estado, 
            c_municipio = p_c_municipio, 
            id_pais = p_id_pais,
            id_sesion_registro = p_id_sesion_registro
		WHERE	id_codigo_postal = p_id_codigo_postal;
	ELSEIF tipo = 3
    THEN
		SELECT	id_codigo_postal, cp, c_estado, c_municipio, id_pais, id_sesion_registro
        FROM	codigo_postal
		WHERE	id_codigo_postal = p_id_codigo_postal;
	END IF;
END
%%
CREATE TRIGGER t_di_codigo_postal AFTER INSERT ON codigo_postal FOR EACH ROW
BEGIN
	CALL sp_bitacora(1, 0, 5, 5, NEW.id_codigo_postal, CURRENT_TIMESTAMP(), '', NEW.id_sesion_registro);
END
%%
CREATE PROCEDURE sp_grupo(tipo INT, p_id_grupo INT, p_id_distrito INT, p_id_estatus TINYINT, p_nombre VARCHAR(100), 
p_numero INT, p_id_domicilio INT, p_fecha_fundacion DATE, p_id_sesion_registro INT)
BEGIN
	-- Validando Tipos
	IF tipo = 1
	THEN
		INSERT	INTO	grupo
		(id_grupo, id_distrito, id_estatus, nombre, numero, id_domicilio, fecha_fundacion, id_sesion_registro)
		VALUES
		(NULL, p_id_distrito, p_id_estatus, p_nombre, p_numero, p_id_domicilio, p_fecha_fundacion, p_id_sesion_registro);
	ELSEIF tipo = 2
    THEN
		UPDATE grupo
        SET	id_distrito = p_id_distrito, 
			id_estatus = p_id_estatus, 
            nombre = p_nombre, 
            numero = p_numero, 
            id_domicilio = p_id_domicilio, 
            fecha_fundacion = p_fecha_fundacion,
            id_sesion_registro = p_id_sesion_registro
		WHERE	id_grupo = p_id_grupo;
	ELSEIF tipo = 3
    THEN
		SELECT	id_grupo, id_distrito, id_estatus, nombre, numero, id_domicilio, fecha_fundacion, id_sesion_registro
        FROM	grupo
		WHERE	id_grupo = p_id_grupo;
	END IF;
END
%%
CREATE TRIGGER t_ai_grupo BEFORE INSERT ON grupo FOR EACH ROW
BEGIN
	DECLARE conteo_registros INT;
    -- Validando Duplicidad de registros
    SELECT COUNT(*)
    INTO	conteo_registros
    FROM	grupo
	WHERE	id_distrito = NEW.id_distrito
    AND numero = NEW.numero;
    -- Validando # encontrados
    IF conteo_registros > 0
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El Grupo ya se encuentra dado de alta.';
    END IF;
END
%%
CREATE TRIGGER t_di_grupo AFTER INSERT ON grupo FOR EACH ROW
BEGIN
	CALL sp_bitacora(1, 0, 8, 8, NEW.id_grupo, CURRENT_TIMESTAMP(), '', NEW.id_sesion_registro);
END
%%
CREATE PROCEDURE sp_seccion(tipo INT, p_id_seccion INT, p_edad_inicial INT, p_edad_final INT, p_nombre VARCHAR(50), 
p_id_seccion_anterior INT, p_id_sesion_registro INT)
BEGIN
	-- Validando Tipos
	IF tipo = 1
	THEN
		INSERT	INTO	seccion
		(id_seccion, edad_inicial, edad_final, nombre, id_seccion_anterior, id_sesion_registro)
		VALUES
		(NULL, p_edad_inicial, p_edad_final, p_nombre, p_id_seccion_anterior, p_id_sesion_registro);
	ELSEIF tipo = 2
    THEN
		UPDATE seccion
        SET	edad_inicial = p_edad_inicial, 
			edad_final = p_edad_final, 
            nombre = p_nombre, 
            id_seccion_anterior = p_id_seccion_anterior, 
            id_sesion_registro = p_id_sesion_registro
		WHERE	id_seccion = p_id_seccion;
	ELSEIF tipo = 3
    THEN
		SELECT	id_seccion, edad_inicial, edad_final, nombre, id_seccion_anterior, id_sesion_registro
        FROM	seccion
		WHERE	id_seccion = p_id_seccion;
	END IF;
END
%%
CREATE TRIGGER t_ai_seccion BEFORE INSERT ON seccion FOR EACH ROW
BEGIN
	DECLARE conteo_registros INT;
    -- Validando Duplicidad de registros
    SELECT COUNT(*)
    INTO	conteo_registros
    FROM	seccion
	WHERE	nombre = NEW.nombre
    AND ((edad_inicial BETWEEN NEW.edad_inicial AND NEW.edad_final) OR
		 (edad_final BETWEEN NEW.edad_inicial AND NEW.edad_final));
    -- Validando # encontrados
    IF conteo_registros > 0
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La Sección ya se encuentra dado de alta o interfiere en los rangos de edad de otra sección.';
    END IF;
END
%%
CREATE TRIGGER t_di_seccion AFTER INSERT ON seccion FOR EACH ROW
BEGIN
	CALL sp_bitacora(1, 0, 14, 14, NEW.id_seccion, CURRENT_TIMESTAMP(), '', NEW.id_sesion_registro);
END
%%
CREATE PROCEDURE sp_adelantos(tipo INT, p_id_adelantos INT, p_id_seccion INT, p_descripcion VARCHAR(50), 
p_id_adelanto_anterior INT, p_adelanto_terminal BIT, p_id_sesion_registro INT)
BEGIN
	-- Validando Tipos
	IF tipo = 1
	THEN
		INSERT	INTO	adelantos
		(id_adelantos, id_seccion, descripcion, id_adelanto_anterior, adelanto_terminal, id_sesion_registro)
		VALUES
		(NULL, p_id_seccion, p_descripcion, p_id_adelanto_anterior, p_adelanto_terminal, p_id_sesion_registro);
	ELSEIF tipo = 2
    THEN
		UPDATE adelantos
        SET	id_seccion = p_id_seccion, 
			descripcion = p_descripcion, 
            id_adelanto_anterior = p_id_adelanto_anterior, 
            adelanto_terminal = p_adelanto_terminal, 
            id_sesion_registro = p_id_sesion_registro
		WHERE	id_adelantos = p_id_adelantos;
	ELSEIF tipo = 3
    THEN
		SELECT	id_adelantos, id_seccion, descripcion, id_adelanto_anterior, adelanto_terminal, id_sesion_registro
        FROM	adelantos
		WHERE	id_adelantos = p_id_adelantos;
	END IF;
END
%%
CREATE TRIGGER t_ai_adelantos BEFORE INSERT ON adelantos FOR EACH ROW
BEGIN
	DECLARE conteo_registros INT;
    -- Validando Duplicidad de registros
    SELECT COUNT(*)
    INTO	conteo_registros
    FROM	adelantos
	WHERE	descripcion = NEW.descripcion
    AND id_seccion = NEW.id_seccion;
    -- Validando # encontrados
    IF conteo_registros > 0
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El adelanto ya se encuentra dado de alta para la misma sección.';
    END IF;
END
%%
CREATE TRIGGER t_di_adelantos AFTER INSERT ON adelantos FOR EACH ROW
BEGIN
	CALL sp_bitacora(1, 0, 3, 3, NEW.id_adelantos, CURRENT_TIMESTAMP(), '', NEW.id_sesion_registro);
END
%%
DELIMITER %%
CREATE PROCEDURE sp_beneficiarios(tipo INT, p_id_beneficiario INT, p_id_domicilio INT, p_ap_paterno VARCHAR(50), 
p_ap_materno VARCHAR(50), p_nombre VARCHAR(100), p_fecha_nac DATE, p_id_genero TINYINT, p_id_tipo_seguro TINYINT, 
p_no_afiliacion VARCHAR(15), p_clave_mem VARCHAR(25), p_fecha_ingreso DATE, p_id_sesion_registro INT)
BEGIN
	DECLARE clave_calculada VARCHAR(25);
    -- Validando Tipos
	IF tipo = 1
	THEN
		-- Calculando Clave de Membresia
        SELECT	CONCAT('MEX', UPPER(LEFT(p_ap_paterno, 2)), UPPER(LEFT(p_ap_materno, 1)), UPPER(LEFT(p_nombre, 1)), DATE_FORMAT(p_fecha_nac, '%Y%m%d'),'-', CASE WHEN p_id_genero = 1 THEN 'H' ELSE 'M' END, DATE_FORMAT(CURRENT_TIMESTAMP(),'%y'))
        INTO clave_calculada;
        -- Insertando Clave Calculada al Beneficiario
        INSERT	INTO	beneficiarios
		(id_beneficiario, id_domicilio, ap_paterno, ap_materno, nombre, fecha_nac, id_genero, id_tipo_seguro, 
         no_afiliacion, clave_mem, fecha_ingreso, id_sesion_registro)
		VALUES
		(NULL, p_id_domicilio, p_ap_paterno, p_ap_materno, p_nombre, p_fecha_nac, p_id_genero, p_id_tipo_seguro, 
         p_no_afiliacion, clave_calculada, p_fecha_ingreso, p_id_sesion_registro);
	ELSEIF tipo = 2
    THEN
		UPDATE beneficiarios
        SET	id_domicilio = p_id_domicilio, 
			ap_paterno = p_ap_paterno, 
            ap_materno = p_ap_materno, 
            nombre = p_nombre, 
            fecha_nac = p_fecha_nac, 
            id_genero = p_id_genero, 
            id_tipo_seguro = p_id_tipo_seguro, 
			no_afiliacion = p_no_afiliacion,
            fecha_ingreso = p_fecha_ingreso, 
            id_sesion_registro = p_id_sesion_registro
		WHERE	id_beneficiario = p_id_beneficiario;
	ELSEIF tipo = 3
    THEN
		SELECT	id_beneficiario, id_domicilio, ap_paterno, ap_materno, nombre, fecha_nac, id_genero, id_tipo_seguro, no_afiliacion, clave_mem, fecha_ingreso, id_sesion_registro
        FROM	beneficiarios
		WHERE	id_beneficiario = p_id_beneficiario;
	END IF;
END
%%
CREATE TRIGGER t_ai_beneficiarios BEFORE INSERT ON beneficiarios FOR EACH ROW
BEGIN
	DECLARE conteo_registros INT;
    -- Validando Duplicidad de registros
    SELECT COUNT(*)
    INTO	conteo_registros
    FROM	beneficiarios
	WHERE	clave_mem = NEW.clave_mem;
    -- Validando # encontrados
    IF conteo_registros > 0
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Ya existe esta clave de membresia';
    END IF;
END
%%
CREATE TRIGGER t_di_beneficiarios AFTER INSERT ON beneficiarios FOR EACH ROW
BEGIN
	CALL sp_bitacora(1, 0, 4, 4, NEW.id_beneficiario, CURRENT_TIMESTAMP(), '', NEW.id_sesion_registro);
END
%%
DELIMITER %%
CREATE PROCEDURE sp_registro(tipo INT, p_id_registro INT, p_id_beneficiario INT, p_id_distrito INT, p_id_grupo INT, p_id_estatus TINYINT, 
p_id_seccion INT, p_año INT, p_fecha_inicio DATE, p_fecha_termino DATE, p_id_sesion_registro INT)
BEGIN
	-- Validando Tipos
	IF tipo = 1
	THEN
		INSERT	INTO	registro
		(id_registro, id_beneficiario, id_distrito, id_grupo, id_estatus, id_seccion, año, fecha_inicio, fecha_termino, id_sesion_registro)
		VALUES
		(NULL, p_id_beneficiario, p_id_distrito, p_id_grupo, p_id_estatus, p_id_seccion, p_año, p_fecha_inicio, p_fecha_termino, p_id_sesion_registro);
	ELSEIF tipo = 2
    THEN
		UPDATE registro
        SET	id_beneficiario = p_id_beneficiario, 
			id_distrito = p_id_distrito, 
            id_grupo = p_id_grupo, 
            id_estatus = p_id_estatus, 
            id_seccion = p_id_seccion, 
            año = p_año, 
            fecha_inicio = p_fecha_inicio, 
            fecha_termino = p_fecha_termino, 
            id_sesion_registro = p_id_sesion_registro
		WHERE	id_registro = p_id_registro;
	ELSEIF tipo = 3
    THEN
		SELECT	id_registro, id_beneficiario, id_distrito, id_grupo, id_estatus, id_seccion, año, fecha_inicio, fecha_termino, id_sesion_registro
        FROM	registro
		WHERE	id_registro = p_id_registro;
	END IF;
END
%%
DELIMITER %%
CREATE TRIGGER t_ai_registro BEFORE INSERT ON registro FOR EACH ROW
BEGIN
	DECLARE conteo_registros INT;
    DECLARE v_id_seccion INT;
    
    -- Invocano Función
    SELECT	f_determina_seccion_registro(fecha_nac, id_genero, NEW.año)
    INTO	v_id_seccion
    FROM	beneficiarios
    WHERE	id_beneficiario = NEW.id_beneficiario;
    -- Asignando Valor
    SET NEW.id_seccion = CASE WHEN v_id_seccion IS NULL THEN NEW.id_seccion ELSE v_id_seccion END;
    
    -- Validando Duplicidad de registros
    SELECT COUNT(*)
    INTO	conteo_registros
    FROM	registro
	WHERE	id_beneficiario = NEW.id_beneficiario
    AND año = NEW.año
    AND id_grupo = NEW.id_grupo
    AND id_seccion = NEW.id_seccion
    ;
    -- Validando # encontrados
    IF conteo_registros > 0
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Ya existe el registro del beneficiario';
    END IF;
END
%%
CREATE TRIGGER t_di_registro AFTER INSERT ON registro FOR EACH ROW
BEGIN
	CALL sp_bitacora(1, 0, 12, 12, NEW.id_registro, CURRENT_TIMESTAMP(), '', NEW.id_sesion_registro);
END
%%
DELIMITER %%
CREATE FUNCTION f_determina_seccion_registro(p_fecha_nac DATE, p_id_genero TINYINT, p_anio_registro VARCHAR(10))
RETURNS INT DETERMINISTIC
BEGIN
	-- Obteniendo Edad registro
    DECLARE v_id_seccion INT;
    DECLARE	v_edad_registro INT;
    -- Si es el año actual
    IF DATE_FORMAT(CURRENT_TIMESTAMP(), '%Y') = p_anio_registro
    THEN
		SELECT	TIMESTAMPDIFF(YEAR, p_fecha_nac, CURRENT_TIMESTAMP())
        INTO	v_edad_registro;
	ELSE
		SELECT	TIMESTAMPDIFF(YEAR, p_fecha_nac, CONCAT(p_anio_registro,'-12-31'))
        INTO	v_edad_registro;
    END IF;
    
    -- Validando Genero
    IF p_id_genero = 1
    THEN
		-- HOMBRES
        SELECT	IFNULL(id_seccion,0)
        INTO	v_id_seccion
        FROM	seccion
        WHERE	v_edad_registro BETWEEN edad_inicial AND edad_final
        AND id_seccion IN(1,3,5,7)
        ORDER	BY	id_seccion DESC
        LIMIT 1;
	ELSEIF p_id_genero = 2
    THEN
		-- MUJERES
        SELECT	IFNULL(id_seccion,0)
        INTO	v_id_seccion
        FROM	seccion
        WHERE	v_edad_registro BETWEEN edad_inicial AND edad_final
        AND id_seccion IN(1,2,4,6)
        ORDER	BY	id_seccion DESC
        LIMIT 1;
	ELSE
		SET v_id_seccion = 0;
	END IF;
    
    RETURN v_id_seccion;
END
;
CREATE FUNCTION f_edad_actual_beneficiario(p_id_beneficiario INT, p_anio_registro VARCHAR(4))
RETURNS INT DETERMINISTIC
BEGIN
	-- Obteniendo Edad registro
    DECLARE	v_edad_registro INT;
    DECLARE v_fecha_nac_b DATE;
    -- Obteniendo Fecha de Nacimiento
    SELECT	fecha_nac
    INTO	v_fecha_nac_b
    FROM	beneficiarios
    WHERE	id_beneficiario = p_id_beneficiario
    LIMIT 1;
    
    -- Si es el año actual
    IF DATE_FORMAT(CURRENT_TIMESTAMP(), '%Y') = p_anio_registro
    THEN
		SELECT	TIMESTAMPDIFF(YEAR, v_fecha_nac_b, CURRENT_TIMESTAMP())
        INTO	v_edad_registro;
	ELSE
		SELECT	TIMESTAMPDIFF(YEAR, v_fecha_nac_b, CONCAT(p_anio_registro,'-12-31'))
        INTO	v_edad_registro;
    END IF;
	
    RETURN v_edad_registro;
END
;
%%
DELIMITER %%
CREATE OR REPLACE VIEW vw_membresia_actual_seccion
AS
SELECT	S.nombre AS Seccion,
		AVG(f_edad_actual_beneficiario(R.id_beneficiario, DATE_FORMAT(CURRENT_TIMESTAMP(), '%Y'))) AS EdadPromedio,
        COUNT(id_registro) AS Conteo
FROM	registro R
JOIN	beneficiarios B ON B.id_beneficiario = R.id_beneficiario
JOIN	seccion S ON R.id_seccion = S.id_seccion
WHERE	DATE_FORMAT(fecha_inicio, '%Y') = DATE_FORMAT(CURRENT_TIMESTAMP(), '%Y')
GROUP	BY	S.nombre
;
CREATE OR REPLACE VIEW vw_registros_grupo_anual
AS
SELECT	G.numero AS NoGrupo, 
		G.nombre AS Nombre,
        D.descripcion AS Distrito,
        R.año AS Periodo,
        COUNT(id_registro) AS Conteo
FROM	grupo G
JOIN	distrito D ON G.id_distrito = D.id_distrito
LEFT	JOIN	registro R ON R.id_grupo = G.id_grupo
GROUP	BY	G.numero, G.nombre, D.descripcion, R.año
ORDER	BY	R.año DESC, G.numero
;
CREATE OR REPLACE VIEW vw_registros_grupo_seccion
AS
SELECT	G.numero AS NoGrupo, 
		G.nombre AS Nombre,
        S.nombre AS Seccion,
        R.año AS Periodo,
        COUNT(id_registro) AS Conteo
FROM	grupo G
LEFT	JOIN	registro R ON R.id_grupo = G.id_grupo
LEFT	JOIN	seccion S ON S.id_seccion = R.id_seccion
GROUP	BY	G.numero, G.nombre, S.nombre, R.año
ORDER	BY	R.año DESC, G.numero
;
CREATE OR REPLACE VIEW vw_contabiliza_zona_domicilio
AS
SELECT	PAIS.descripcion AS Pais,
		C.c_estado AS Estado,
        C.c_municipio AS Municipio,
        COUNT(D.id_domicilio) AS Beneficiarios
FROM	domicilio D
JOIN	codigo_postal C ON C.cp = D.cp
JOIN	beneficiarios B ON B.id_domicilio = D.id_domicilio
LEFT	JOIN	catalogo PAIS ON PAIS.id_valor = C.id_pais AND PAIS.id_catalogo_tipo = 9
-- LEFT	JOIN	catalogo EST ON EST. = C.id_pais AND PAIS.id_catalogo_tipo = 10
GROUP	BY	PAIS.descripcion, C.c_estado, C.c_municipio
ORDER	BY	4 DESC
;
CREATE OR REPLACE VIEW vw_log_acciones_bd
AS
SELECT	DATE_FORMAT(B.fecha_bitacora, '%Y') AS Año,
		T.alias_tabla AS Entidad,
		BT.descripcion AS Tipo,
        COUNT(B.id_bitacora) AS Conteo
FROM	bitacora B
JOIN	bitacora_tipo BT ON BT.id_bitacora_tipo = B.id_bitacora_tipo
JOIN	tablas T ON B.id_tabla = T.id_tabla
GROUP	BY	DATE_FORMAT(B.fecha_bitacora, '%Y'), BT.descripcion, T.alias_tabla, BT.descripcion
ORDER	BY	4 DESC
;
%%