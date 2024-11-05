/* =========================================================
   Base de datos: dbGamarraMarket
   ========================================================= */

/* Crear la base de datos si no existe */
DROP DATABASE IF EXISTS dbGamarraMarket;
CREATE DATABASE dbGamarraMarket DEFAULT CHARACTER SET utf8;

/* Poner en uso la base de datos dbGamarraMarket */
USE dbGamarraMarket;

/* =========================================================
   Tabla: CLIENTE
   ========================================================= */
CREATE TABLE CLIENTE (
    identificador INT NOT NULL AUTO_INCREMENT,
    tipo_documento CHAR(3) NOT NULL,                -- Ej: 'DNI', 'CNE'
    numero_documento CHAR(9) NOT NULL UNIQUE,       -- Documento único para cada cliente
    nombres VARCHAR(60) NOT NULL,                   -- Nombres del cliente
    apellidos VARCHAR(90) NOT NULL,                 -- Apellidos del cliente
    email VARCHAR(80),                              -- Correo electrónico
    celular CHAR(9),                                -- Número de celular (Ej: '999999999')
    fecha_nacimiento DATE,                          -- Fecha de nacimiento del cliente
    activo BOOL,                     			    -- Indica si el cliente está activo o no
    CONSTRAINT cliente_pk PRIMARY KEY (identificador)
);

/* =========================================================
   Tabla: VENDEDOR
   ========================================================= */
CREATE TABLE VENDEDOR (
    identificador INT NOT NULL AUTO_INCREMENT,
    tipo_documento CHAR(3) NOT NULL,                -- Ej: 'DNI', 'CNE'
    numero_documento CHAR(15) NOT NULL UNIQUE,      -- Documento único para cada vendedor
    nombres VARCHAR(60) NOT NULL,                   -- Nombres del vendedor
    apellidos VARCHAR(90) NOT NULL,                 -- Apellidos del vendedor
    salario DECIMAL(8,2) NOT NULL,                  -- Salario del vendedor
    celular CHAR(9),                                -- Número de celular
    email VARCHAR(80),                              -- Correo electrónico
    activo BOOL,                       				-- Indica si el vendedor está activo o no
    CONSTRAINT vendedor_pk PRIMARY KEY (identificador)
);

/* =========================================================
   Tabla: PRENDA
   ========================================================= */
CREATE TABLE PRENDA (
    identificador INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(90) NOT NULL,               -- Descripción de la prenda
    marca VARCHAR(60),                              -- Marca de la prenda
    cantidad INT DEFAULT 0,                         -- Cantidad en stock
    talla VARCHAR(10),                              -- Talla de la prenda (Ej: 'S', 'M', 'L')
    precio DECIMAL(8,2) NOT NULL,                   -- Precio de la prenda
    activo BOOL,                       				-- Indica si la prenda está activa o no
    CONSTRAINT prenda_pk PRIMARY KEY (identificador)
);

/* =========================================================
   Tabla: VENTA
   ========================================================= */
CREATE TABLE VENTA (
    identificador INT NOT NULL AUTO_INCREMENT,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha y hora de la venta
    activo BOOL DEFAULT TRUE,                       -- Indica si la venta está activa o no
    cliente_identificador INT NOT NULL,             -- ID del cliente asociado a la venta
    vendedor_identificador INT NOT NULL,            -- ID del vendedor que realizó la venta
    CONSTRAINT venta_pk PRIMARY KEY (identificador),
    CONSTRAINT cliente_venta_fk FOREIGN KEY (cliente_identificador) 
        REFERENCES CLIENTE (identificador) 
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT vendedor_venta_fk FOREIGN KEY (vendedor_identificador) 
        REFERENCES VENDEDOR (identificador) 
        ON UPDATE CASCADE ON DELETE CASCADE
);

/* =========================================================
   Tabla: VENTA_DETALLE
   ========================================================= */
CREATE TABLE VENTA_DETALLE (
    identificador INT NOT NULL AUTO_INCREMENT,
    cantidad INT NOT NULL,                          -- Cantidad de la prenda en esta venta
    venta_identificador INT NOT NULL,               -- ID de la venta asociada
    prenda_identificador INT NOT NULL,              -- ID de la prenda vendida
    CONSTRAINT venta_detalle_pk PRIMARY KEY (identificador),
    CONSTRAINT venta_venta_detalle_fk FOREIGN KEY (venta_identificador) 
        REFERENCES VENTA (identificador) 
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT venta_detalle_prenda_fk FOREIGN KEY (prenda_identificador) 
        REFERENCES PRENDA (identificador) 
        ON UPDATE CASCADE ON DELETE CASCADE
);

/* =========================================================
   Comandos de verificación
   ========================================================= */

/* Mostrar la estructura de cada tabla */
SHOW COLUMNS IN CLIENTE;
SHOW COLUMNS IN VENDEDOR;
SHOW COLUMNS IN PRENDA;
SHOW COLUMNS IN VENTA;
SHOW COLUMNS IN VENTA_DETALLE;

/*prenda_identificador Listar todas las tablas existentes en la base de datos en uso */
SHOW TABLES;

/* Consultar relaciones (foreign keys) de las tablas en la base de datos activa */
SELECT 
    i.constraint_name, k.table_name, k.column_name, 
    k.referenced_table_name, k.referenced_column_name
FROM 
    information_schema.TABLE_CONSTRAINTS i 
LEFT JOIN information_schema.KEY_COLUMN_USAGE k 
ON i.CONSTRAINT_NAME = k.CONSTRAINT_NAME 
WHERE i.CONSTRAINT_TYPE = 'FOREIGN KEY' 
AND i.TABLE_SCHEMA = DATABASE();
