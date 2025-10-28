ALTER SESSION SET NLS_DATE_LANGUAGE = 'ENGLISH';
ALTER SESSION SET NLS_TERRITORY     = 'AMERICA';

BEGIN EXECUTE IMMEDIATE 'DROP TABLE hr.empleado_capacitacion CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE hr.capacitacion CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE hr.capacitacion (
  cap_id      NUMBER(6)    PRIMARY KEY,
  nombre      VARCHAR2(80) NOT NULL,
  horas       NUMBER(4,1)  NOT NULL CHECK (horas > 0),
  descripcion VARCHAR2(400)
);

CREATE TABLE hr.empleado_capacitacion (
  employee_id NUMBER(6) NOT NULL REFERENCES hr.employees(employee_id),
  cap_id      NUMBER(6) NOT NULL REFERENCES hr.capacitacion(cap_id),
  CONSTRAINT pk_empleado_capacitacion PRIMARY KEY (employee_id, cap_id)
);

-- CAPACITACION (10)
INSERT INTO hr.capacitacion VALUES (1,'SQL Básico',16,'Fundamentos SQL');
INSERT INTO hr.capacitacion VALUES (2,'PL/SQL',24,'Programación PL/SQL');
INSERT INTO hr.capacitacion VALUES (3,'Docker',12,'Contenedores');
INSERT INTO hr.capacitacion VALUES (4,'Python',20,'Aplicaciones');
INSERT INTO hr.capacitacion VALUES (5,'Excel Avanzado',16,'Tablas dinámicas');
INSERT INTO hr.capacitacion VALUES (6,'Power BI',12,'Visualización');
INSERT INTO hr.capacitacion VALUES (7,'Git',8,'Control de versiones');
INSERT INTO hr.capacitacion VALUES (8,'Redes',14,'Conceptos básicos');
INSERT INTO hr.capacitacion VALUES (9,'Linux',18,'Administración');
INSERT INTO hr.capacitacion VALUES (10,'Seguridad',16,'Buenas prácticas');

-- EMPLEADO_CAPACITACION (10)
-- Ajusta los IDs 100–109 a los que existan en tu HR si es necesario
INSERT INTO hr.empleado_capacitacion VALUES (100,1);
INSERT INTO hr.empleado_capacitacion VALUES (100,2);
INSERT INTO hr.empleado_capacitacion VALUES (101,2);
INSERT INTO hr.empleado_capacitacion VALUES (101,7);
INSERT INTO hr.empleado_capacitacion VALUES (102,3);
INSERT INTO hr.empleado_capacitacion VALUES (103,4);
INSERT INTO hr.empleado_capacitacion VALUES (104,5);
INSERT INTO hr.empleado_capacitacion VALUES (105,6);
INSERT INTO hr.empleado_capacitacion VALUES (106,9);
INSERT INTO hr.empleado_capacitacion VALUES (107,10);

COMMIT;
