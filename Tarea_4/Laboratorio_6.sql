/* =========================================================
   ENUNCIADO
   Base de datos para gestionar empleados, departamentos,
   estudios, historial laboral y salarial de una empresa.
   ========================================================= */

/* =========================================================
   1. CREACIÓN DE TABLAS CON ATRIBUTOS OBLIGATORIOS (NOT NULL)
   ========================================================= */

/* Tabla de departamentos */
CREATE TABLE Departamentos (
    dpto_cod NUMBER(5) PRIMARY KEY,
    nombre_dpto VARCHAR2(30) NOT NULL,
    dpto_padre NUMBER(5),
    presupuesto NUMBER NOT NULL,
    pres_actual NUMBER,
    CONSTRAINT fk_dpto_padre FOREIGN KEY (dpto_padre)
        REFERENCES Departamentos(dpto_cod)
);

/* Tabla de empleados */
CREATE TABLE Empleados (
    dni NUMBER(8) PRIMARY KEY,
    nombre VARCHAR2(10) NOT NULL,
    apellido1 VARCHAR2(15) NOT NULL,
    apellido2 VARCHAR2(15),
    direcc1 VARCHAR2(25),
    direcc2 VARCHAR2(20),
    ciudad VARCHAR2(20),
    provincia VARCHAR2(20),
    cod_postal VARCHAR2(5),
    sexo VARCHAR2(1),
    fecha_nac DATE,
    dpto_cod NUMBER(5),
    CONSTRAINT fk_empleado_departamento FOREIGN KEY (dpto_cod)
        REFERENCES Departamentos(dpto_cod)
);

/* Tabla de universidades */
CREATE TABLE Universidades (
    univ_cod NUMBER(5) PRIMARY KEY,
    nombre_univ VARCHAR2(25) NOT NULL,
    ciudad VARCHAR2(20),
    municipio VARCHAR2(2),
    cod_postal VARCHAR2(5)
);

/* Tabla de estudios */
CREATE TABLE Estudios (
    empleado_dni NUMBER(8),
    universidad NUMBER(5),
    año NUMBER,
    grado VARCHAR2(3),
    especialidad VARCHAR2(20),
    CONSTRAINT fk_estudios_empleado FOREIGN KEY (empleado_dni)
        REFERENCES Empleados(dni),
    CONSTRAINT fk_estudios_universidad FOREIGN KEY (universidad)
        REFERENCES Universidades(univ_cod)
);

/* Tabla de trabajos */
CREATE TABLE Trabajos (
    trabajo_cod NUMBER(5) PRIMARY KEY,
    nombre_trab VARCHAR2(20) NOT NULL,
    salario_min NUMBER(2) NOT NULL,
    salario_max NUMBER(2) NOT NULL
);

/* Tabla de historial laboral */
CREATE TABLE Historial_Laboral (
    empleado_dni NUMBER(8),
    univ_cod NUMBER(5),
    trabajo_cod NUMBER(5),
    fecha_inicio DATE,
    fecha_fin DATE,
    dpto_cod NUMBER(5),
    supervisor_dni NUMBER(8),
    CONSTRAINT pk_historial_laboral PRIMARY KEY (empleado_dni, trabajo_cod, fecha_inicio),
    CONSTRAINT fk_historial_laboral_empleado FOREIGN KEY (empleado_dni)
        REFERENCES Empleados(dni),
    CONSTRAINT fk_historial_laboral_universidad FOREIGN KEY (univ_cod)
        REFERENCES Universidades(univ_cod),
    CONSTRAINT fk_historial_laboral_trabajo FOREIGN KEY (trabajo_cod)
        REFERENCES Trabajos(trabajo_cod),
    CONSTRAINT fk_historial_laboral_dpto FOREIGN KEY (dpto_cod)
        REFERENCES Departamentos(dpto_cod),
    CONSTRAINT fk_historial_laboral_supervisor FOREIGN KEY (supervisor_dni)
        REFERENCES Empleados(dni)
);

/* Tabla de historial salarial */
CREATE TABLE Historial_Salarial (
    empleado_dni NUMBER(8),
    salario NUMBER NOT NULL,
    fecha_comienzo DATE,
    fecha_fin DATE,
    CONSTRAINT pk_historial_salarial PRIMARY KEY (empleado_dni, fecha_comienzo),
    CONSTRAINT fk_historial_salarial_empleado FOREIGN KEY (empleado_dni)
        REFERENCES Empleados(dni)
);

/* =========================================================
   2. RESTRICCIÓN DE SEXO (H/M)
   ========================================================= */
ALTER TABLE Empleados
ADD CONSTRAINT check_empleado_sexo
CHECK (sexo IN ('H', 'M'));

/* =========================================================
   3. NOMBRES ÚNICOS EN DEPARTAMENTOS Y TRABAJOS
   ========================================================= */
ALTER TABLE Departamentos
ADD CONSTRAINT unique_departamento_nombre UNIQUE (nombre_dpto);

ALTER TABLE Trabajos
ADD CONSTRAINT unique_trabajo_nombre UNIQUE (nombre_trab);

/* =========================================================
   4. UN SOLO SALARIO Y TRABAJO POR PERÍODO
   ========================================================= */
ALTER TABLE Historial_Salarial
ADD CONSTRAINT unique_salario_por_periodo
UNIQUE (empleado_dni, fecha_comienzo);

ALTER TABLE Historial_Laboral
ADD CONSTRAINT unique_trabajo_por_periodo
UNIQUE (empleado_dni, fecha_inicio);

/* =========================================================
   6. AGREGAR TELÉFONO Y CELULAR A EMPLEADOS
   ========================================================= */
ALTER TABLE Empleados
ADD (
    telefono VARCHAR2(15),
    celular VARCHAR2(15)
);

/* =========================================================
   7. INSERCIÓN DE DATOS
   ========================================================= */
INSERT INTO Empleados (nombre, apellido1, apellido2, dni, sexo)
VALUES ('Sergio', 'Palma', 'Entrena', 111222, 'H');

INSERT INTO Empleados (nombre, apellido1, apellido2, dni, sexo)
VALUES ('Ana', 'Torres', 'Mendoza', 111223, 'M');

INSERT INTO Historial_Laboral (empleado_dni, fecha_inicio, dpto_cod)
VALUES (111222, TO_DATE('16/06/1996','DD/MM/YYYY'), 222333);

/* =========================================================
   9. MODIFICACIÓN DE CLAVE FORÁNEA EN ESTUDIOS
   ========================================================= */

/* Opción a: borrar estudios asociados */
ALTER TABLE ESTUDIOS
DROP CONSTRAINT fk_estudios_universidad;

ALTER TABLE ESTUDIOS
ADD CONSTRAINT fk_estudios_universidad
FOREIGN KEY (id_universidad)
REFERENCES UNIVERSIDADES(id_universidad)
ON DELETE CASCADE;

/* Opción b: dejar universidad en NULL */
ALTER TABLE Estudios
DROP CONSTRAINT fk_estudios_universidad;

ALTER TABLE Estudios
ADD CONSTRAINT fk_estudios_universidad
FOREIGN KEY (id_universidad)
REFERENCES Universidades(id_universidad)
ON DELETE SET NULL;

/* =========================================================
   10. CIUDAD IMPLICA CÓDIGO POSTAL
   ========================================================= */
ALTER TABLE Empleados
ADD CONSTRAINT chk_ciudad_codpostal
CHECK (ciudad IS NULL OR cod_postal IS NOT NULL);

/* =========================================================
   11. CAMPO VALORACIÓN CON VALOR POR DEFECTO
   ========================================================= */
ALTER TABLE Empleados
ADD valoracion NUMBER(2)
DEFAULT 5
CONSTRAINT chk_valoracion CHECK (valoracion BETWEEN 1 AND 10);

/* =========================================================
   12. ELIMINAR NOT NULL DE NOMBRE
   ========================================================= */
ALTER TABLE Empleados
MODIFY nombre VARCHAR2(10) NULL;

/* =========================================================
   13. MODIFICAR TAMAÑO DE DIRECC1
   ========================================================= */
ALTER TABLE Empleados
MODIFY direcc1 VARCHAR2(40);

/* =========================================================
   14. MODIFICAR FECHA_NAC A CADENA
   ========================================================= */
ALTER TABLE Empleados
MODIFY fecha_nac VARCHAR2(10);

/* =========================================================
   15. CAMBIAR CLAVE PRIMARIA DE EMPLEADOS
   ========================================================= */
ALTER TABLE Empleados
DROP PRIMARY KEY;

ALTER TABLE Empleados
ADD CONSTRAINT pk_empleados
PRIMARY KEY (nombre, apellido1, apellido2);

/* =========================================================
   16. TABLA INFORMACIÓN UNIVERSITARIA
   ========================================================= */
CREATE TABLE Informacion_Universitaria (
    empleado_nombre_completo VARCHAR2(100),
    universidad VARCHAR2(25)
);

INSERT INTO Informacion_Universitaria (empleado_nombre_completo, universidad)
SELECT
    RTRIM(e.nombre || ' ' || e.apellido1 || ' ' || NVL(e.apellido2, '')),
    u.nombre_univ
FROM Empleados e
JOIN Estudios est
    ON e.dni = est.empleado_dni
JOIN Universidades u
    ON est.universidad = u.univ_cod;

/* =========================================================
   17. VISTA DE EMPLEADOS DE MÁLAGA
   ========================================================= */
CREATE VIEW Nombre_Empleados AS
SELECT
    nombre || ' ' || apellido1 || ' ' || NVL(apellido2, '') AS nombre_completo
FROM Empleados
WHERE ciudad = 'Málaga';

/* =========================================================
   18. VISTA CON EDAD DE EMPLEADOS
   ========================================================= */
CREATE VIEW Informacion_Empleados AS
SELECT
    nombre || ' ' || apellido1 || ' ' || NVL(apellido2, '') AS nombre_completo,
    TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_nac) / 12) AS edad
FROM Empleados;

/* =========================================================
   19. VISTA CON INFORMACIÓN ACTUAL Y SALARIO
   ========================================================= */
CREATE VIEW Informacion_Actual AS
SELECT
    ie.nombre_completo,
    ie.edad,
    e.salario
FROM Informacion_Empleados ie
JOIN Empleados e
    ON ie.nombre_completo =
       e.nombre || ' ' || e.apellido1 || ' ' || NVL(e.apellido2, '');

/* =========================================================
   20. BORRADO DE TABLAS (RESPETANDO CLAVES FORÁNEAS)
   ========================================================= */
DROP TABLE Historial_Laboral;
DROP TABLE Historial_Salarial;
DROP TABLE Estudios;
DROP TABLE Empleados;
DROP TABLE Trabajos;
DROP TABLE Universidades;
DROP TABLE Departamentos;
