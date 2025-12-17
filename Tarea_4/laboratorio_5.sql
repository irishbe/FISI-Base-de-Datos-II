-- 1. CREACIÓN DEL TABLESPACE DE DATOS "Esquema"
-- Dos archivos de datos
-- Crecimiento automático hasta un tamaño máximo
-- Extents administrados localmente
-- Segmentos administrados automáticamente

CREATE TABLESPACE Esquema
DATAFILE
    '/u01/app/oracle/oradata/ORCL/esquema01.dbf' SIZE 100M AUTOEXTEND ON
        NEXT 10M MAXSIZE 500M,
    '/u01/app/oracle/oradata/ORCL/esquema02.dbf' SIZE 100M AUTOEXTEND ON
        NEXT 10M MAXSIZE 500M
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;

-- 2. CREACIÓN DEL TABLESPACE TEMPORAL "TempEsquema"
-- Archivo temporal de tamaño fijo
-- Propio de un tablespace temporal

CREATE TEMPORARY TABLESPACE TempEsquema
TEMPFILE '/u01/app/oracle/oradata/ORCL/tempesquema01.dbf' SIZE 100M
EXTENT MANAGEMENT LOCAL
UNIFORM SIZE 1M;

-- 3. CREACIÓN DE TABLAS DE LA BASE DE DATOS UNIVERSITARIA

-- Tabla Persona: datos comunes a todos los miembros
CREATE TABLE Persona (
    persona_id NUMBER(5) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    direccion VARCHAR2(100),
    telefono VARCHAR2(20),
    email VARCHAR2(50)
);

-- Tabla Profesor
CREATE TABLE Profesor (
    persona_id NUMBER(5) PRIMARY KEY,
    departamento VARCHAR2(50),
    dedicacion VARCHAR2(20),
    CONSTRAINT fk_profesor_persona FOREIGN KEY (persona_id)
        REFERENCES Persona(persona_id)
);

-- Tabla Centro
CREATE TABLE Centro (
    centro_id NUMBER(5) PRIMARY KEY,
    nombre VARCHAR2(50),
    direccion VARCHAR2(100)
);

-- Relación entre profesores y centros
CREATE TABLE Profesor_Centro (
    persona_id NUMBER(5),
    centro_id NUMBER(5),
    CONSTRAINT pk_profesor_centro PRIMARY KEY (persona_id, centro_id),
    CONSTRAINT fk_pc_profesor FOREIGN KEY (persona_id)
        REFERENCES Profesor(persona_id),
    CONSTRAINT fk_pc_centro FOREIGN KEY (centro_id)
        REFERENCES Centro(centro_id)
);

-- Tabla Alumno
CREATE TABLE Alumno (
    persona_id NUMBER(5) PRIMARY KEY,
    centro_id NUMBER(5),
    num_expediente NUMBER(10),
    titulacion VARCHAR2(50),
    CONSTRAINT fk_alumno_persona FOREIGN KEY (persona_id)
        REFERENCES Persona(persona_id),
    CONSTRAINT fk_alumno_centro FOREIGN KEY (centro_id)
        REFERENCES Centro(centro_id)
);

-- Tabla Personal administrativo
CREATE TABLE Personal (
    persona_id NUMBER(5) PRIMARY KEY,
    unidad_administrativa VARCHAR2(50),
    categoria_profesional VARCHAR2(50),
    CONSTRAINT fk_personal_persona FOREIGN KEY (persona_id)
        REFERENCES Persona(persona_id)
);

-- 4. CREACIÓN DE RESTRICCIONES DE INTEGRIDAD

-- Restricciones sobre Persona
ALTER TABLE Persona
ADD CONSTRAINT chk_persona_nombre CHECK (nombre IS NOT NULL);

ALTER TABLE Persona
ADD CONSTRAINT uq_persona_email UNIQUE (email);

-- Restricciones sobre Profesor
ALTER TABLE Profesor
ADD CONSTRAINT chk_profesor_departamento
CHECK (departamento IS NOT NULL);

-- Restricciones sobre Alumno
ALTER TABLE Alumno
ADD CONSTRAINT chk_alumno_expediente
CHECK (num_expediente > 0);

ALTER TABLE Alumno
ADD CONSTRAINT chk_alumno_titulacion
CHECK (titulacion IS NOT NULL);

-- Restricciones sobre Personal
ALTER TABLE Personal
ADD CONSTRAINT chk_personal_unidad
CHECK (unidad_administrativa IS NOT NULL);

ALTER TABLE Personal
ADD CONSTRAINT chk_personal_categoria
CHECK (categoria_profesional IS NOT NULL);

-- Restricciones sobre Centro
ALTER TABLE Centro
ADD CONSTRAINT chk_centro_nombre
CHECK (nombre IS NOT NULL);

ALTER TABLE Centro
ADD CONSTRAINT uq_centro_nombre UNIQUE (nombre);

-- 5. CREACIÓN DE LA VISTA GENERAL DE LA UNIVERSIDAD
-- Lista alfabética de todas las personas
-- Incluye datos comunes y específicos

CREATE OR REPLACE VIEW Vista_Universidad AS
SELECT
    p.nombre,
    p.direccion,
    p.telefono,
    p.email,
    pr.departamento AS departamento_profesor,
    pr.dedicacion AS dedicacion_profesor,
    a.num_expediente AS expediente_alumno,
    a.titulacion AS titulacion_alumno,
    per.unidad_administrativa AS unidad_personal,
    per.categoria_profesional AS categoria_personal
FROM Persona p
LEFT JOIN Profesor pr ON p.persona_id = pr.persona_id
LEFT JOIN Alumno a ON p.persona_id = a.persona_id
LEFT JOIN Personal per ON p.persona_id = per.persona_id
ORDER BY p.nombre;

-- 6. CREACIÓN DE ÍNDICES PARA BÚSQUEDA POR NOMBRE

CREATE INDEX idx_profesor_nombre
ON Profesor (nombre);

CREATE INDEX idx_alumno_nombre
ON Alumno (nombre);

CREATE INDEX idx_personal_nombre
ON Personal (nombre);
