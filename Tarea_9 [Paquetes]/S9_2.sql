CREATE TABLE hr.horario (
  dia_semana  VARCHAR2(3)  CHECK (dia_semana IN ('MON','TUE','WED','THU','FRI','SAT','SUN')),
  turno       VARCHAR2(10),
  hora_inicio DATE         NOT NULL,
  hora_fin    DATE         NOT NULL,
  CONSTRAINT pk_horario PRIMARY KEY (dia_semana, turno),
  CONSTRAINT ck_horario_rango CHECK (hora_fin > hora_inicio OR turno = 'OFF')
);

CREATE TABLE hr.empleado_horario (
  employee_id NUMBER(6)    REFERENCES hr.employees(employee_id),
  dia_semana  VARCHAR2(3)  CHECK (dia_semana IN ('MON','TUE','WED','THU','FRI','SAT','SUN')),
  turno       VARCHAR2(10),
  CONSTRAINT pk_empleado_horario PRIMARY KEY (employee_id, dia_semana),
  CONSTRAINT fk_emphor_horario FOREIGN KEY (dia_semana, turno)
    REFERENCES hr.horario(dia_semana, turno)
);

CREATE TABLE hr.asistencia_empleado (
  employee_id      NUMBER(6)   REFERENCES hr.employees(employee_id),
  dia_semana       VARCHAR2(3) CHECK (dia_semana IN ('MON','TUE','WED','THU','FRI','SAT','SUN')),
  fecha_real       DATE        NOT NULL,
  hora_inicio_real DATE        NOT NULL,
  hora_fin_real    DATE        NOT NULL,
  CONSTRAINT pk_asistencia PRIMARY KEY (employee_id, fecha_real)
);

-- HORARIO
INSERT INTO hr.horario VALUES ('MON','DIA', TO_DATE('2000-01-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2000-01-01 17:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.horario VALUES ('TUE','DIA', TO_DATE('2000-01-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2000-01-01 17:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.horario VALUES ('WED','DIA', TO_DATE('2000-01-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2000-01-01 18:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.horario VALUES ('THU','DIA', TO_DATE('2000-01-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2000-01-01 18:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.horario VALUES ('FRI','DIA', TO_DATE('2000-01-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2000-01-01 19:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.horario VALUES ('SAT','MAN',TO_DATE('2000-01-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2000-01-01 12:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.horario VALUES ('SUN','OFF',TO_DATE('2000-01-01 00:00','YYYY-MM-DD HH24:MI'), TO_DATE('2000-01-01 00:01','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.horario VALUES ('MON','TAR',TO_DATE('2000-01-01 12:00','YYYY-MM-DD HH24:MI'), TO_DATE('2000-01-01 21:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.horario VALUES ('TUE','TAR',TO_DATE('2000-01-01 12:00','YYYY-MM-DD HH24:MI'), TO_DATE('2000-01-01 21:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.horario VALUES ('FRI','MAN',TO_DATE('2000-01-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2000-01-01 11:00','YYYY-MM-DD HH24:MI'));

-- EMPLEADO_HORARIO
BEGIN
  FOR i IN 100..104 LOOP
    INSERT INTO hr.empleado_horario VALUES (i,'MON','DIA');
    INSERT INTO hr.empleado_horario VALUES (i,'TUE','DIA');
    INSERT INTO hr.empleado_horario VALUES (i,'WED','DIA');
    INSERT INTO hr.empleado_horario VALUES (i,'THU','DIA');
    INSERT INTO hr.empleado_horario VALUES (i,'FRI','DIA');
    INSERT INTO hr.empleado_horario VALUES (i,'SAT','MAN');
    INSERT INTO hr.empleado_horario VALUES (i,'SUN','OFF');
  END LOOP;
END;
/

-- ASISTENCIA_EMPLEADO
INSERT INTO hr.asistencia_empleado VALUES (100,'MON', DATE '2025-05-05', TO_DATE('2025-05-05 08:05','YYYY-MM-DD HH24:MI'), TO_DATE('2025-05-05 17:02','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.asistencia_empleado VALUES (100,'TUE', DATE '2025-05-06', TO_DATE('2025-05-06 08:10','YYYY-MM-DD HH24:MI'), TO_DATE('2025-05-06 17:01','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.asistencia_empleado VALUES (100,'WED', DATE '2025-05-07', TO_DATE('2025-05-07 09:03','YYYY-MM-DD HH24:MI'), TO_DATE('2025-05-07 18:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.asistencia_empleado VALUES (100,'THU', DATE '2025-05-08', TO_DATE('2025-05-08 09:05','YYYY-MM-DD HH24:MI'), TO_DATE('2025-05-08 18:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.asistencia_empleado VALUES (100,'FRI', DATE '2025-05-09', TO_DATE('2025-05-09 10:20','YYYY-MM-DD HH24:MI'), TO_DATE('2025-05-09 19:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.asistencia_empleado VALUES (101,'MON', DATE '2025-05-05', TO_DATE('2025-05-05 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-05-05 17:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.asistencia_empleado VALUES (101,'TUE', DATE '2025-05-06', TO_DATE('2025-05-06 12:05','YYYY-MM-DD HH24:MI'), TO_DATE('2025-05-06 21:00','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.asistencia_empleado VALUES (102,'SAT', DATE '2025-05-10', TO_DATE('2025-05-10 08:10','YYYY-MM-DD HH24:MI'), TO_DATE('2025-05-10 12:02','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.asistencia_empleado VALUES (103,'WED', DATE '2025-05-14', TO_DATE('2025-05-14 09:40','YYYY-MM-DD HH24:MI'), TO_DATE('2025-05-14 18:10','YYYY-MM-DD HH24:MI'));
INSERT INTO hr.asistencia_empleado VALUES (104,'FRI', DATE '2025-05-16', TO_DATE('2025-05-16 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-05-16 19:00','YYYY-MM-DD HH24:MI'));
COMMIT;
