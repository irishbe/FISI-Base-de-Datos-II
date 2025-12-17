CREATE OR REPLACE TRIGGER hr.trg_asistencia_validacion
BEFORE INSERT OR UPDATE ON hr.asistencia_empleado
FOR EACH ROW
DECLARE
  v_turno VARCHAR2(10);
  v_ini   DATE;
  v_fin   DATE;
BEGIN
  -- Completar/cotejar día de semana
  IF :NEW.dia_semana IS NULL THEN
    :NEW.dia_semana := TO_CHAR(:NEW.fecha_real,'DY','NLS_DATE_LANGUAGE=ENGLISH');
  END IF;

  IF TO_CHAR(:NEW.fecha_real,'DY','NLS_DATE_LANGUAGE=ENGLISH') <> :NEW.dia_semana THEN
    RAISE_APPLICATION_ERROR(-20001,'Día no corresponde a la fecha.');
  END IF;

  -- Turno del empleado ese día
  SELECT eh.turno, h.hora_inicio, h.hora_fin
    INTO v_turno, v_ini, v_fin
    FROM hr.empleado_horario eh
    JOIN hr.horario h ON h.dia_semana=eh.dia_semana AND h.turno=eh.turno
   WHERE eh.employee_id=:NEW.employee_id
     AND eh.dia_semana = :NEW.dia_semana;

  -- Rango válido
  IF :NEW.hora_inicio_real < (TRUNC(:NEW.hora_inicio_real)+(v_ini-TRUNC(v_ini)))
     OR :NEW.hora_fin_real  > (TRUNC(:NEW.hora_fin_real) +(v_fin-TRUNC(v_fin)))
     OR :NEW.hora_fin_real  <= :NEW.hora_inicio_real
  THEN
    RAISE_APPLICATION_ERROR(-20002,'Horas fuera del rango del turno o fin <= inicio.');
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20003,'Empleado sin turno asignado ese día.');
END;
/

CREATE OR REPLACE TRIGGER hr.trg_employees_sueldo_rango
BEFORE INSERT OR UPDATE OF salary, job_id ON hr.employees
FOR EACH ROW
DECLARE
  v_min hr.jobs.min_salary%TYPE;
  v_max hr.jobs.max_salary%TYPE;
BEGIN
  SELECT min_salary, max_salary
    INTO v_min, v_max
    FROM hr.jobs
   WHERE job_id = :NEW.job_id;

  IF :NEW.salary < v_min OR :NEW.salary > v_max THEN
    RAISE_APPLICATION_ERROR(
      -20010,
      'Salario fuera de rango para '||:NEW.job_id||' ('||v_min||' - '||v_max||')'
    );
  END IF;
END;
/

CREATE OR REPLACE TRIGGER hr.trg_asistencia_ventana_ingreso
BEFORE INSERT ON hr.asistencia_empleado
FOR EACH ROW
DECLARE
  v_prog_ini DATE;
  v_menos30  DATE;
  v_mas30    DATE;
BEGIN
  -- Asegurar día
  IF :NEW.dia_semana IS NULL THEN
    :NEW.dia_semana := TO_CHAR(:NEW.fecha_real,'DY','NLS_DATE_LANGUAGE=ENGLISH');
  END IF;

  -- Hora de inicio programada
  SELECT h.hora_inicio
    INTO v_prog_ini
    FROM hr.empleado_horario eh
    JOIN hr.horario h ON h.dia_semana=eh.dia_semana AND h.turno=eh.turno
   WHERE eh.employee_id=:NEW.employee_id
     AND eh.dia_semana = :NEW.dia_semana;

  -- Ventana ±30 minutos sobre el mismo día de la marca
  v_menos30 := TRUNC(:NEW.hora_inicio_real) + (v_prog_ini-TRUNC(v_prog_ini)) - (30/1440);
  v_mas30   := TRUNC(:NEW.hora_inicio_real) + (v_prog_ini-TRUNC(v_prog_ini)) + (30/1440);

  -- Si está fuera de ventana, marcar 0 horas silenciosamente
  IF :NEW.hora_inicio_real < v_menos30 OR :NEW.hora_inicio_real > v_mas30 THEN
    :NEW.hora_fin_real := :NEW.hora_inicio_real; -- 0 horas
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Sin turno ese día: 0 horas
    :NEW.hora_fin_real := :NEW.hora_inicio_real;
END;
/