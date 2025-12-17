CREATE OR REPLACE PACKAGE hr.pkg_asistencia_empleado AS
  FUNCTION horas_trabajadas(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER;
  FUNCTION horas_faltadas  (p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER;
  PROCEDURE liquidacion_mensual(p_mes NUMBER, p_anio NUMBER, o_rc OUT SYS_REFCURSOR);
END pkg_asistencia_empleado;
/

CREATE OR REPLACE PACKAGE BODY hr.pkg_asistencia_empleado AS

  FUNCTION horas_entre(p_ini DATE, p_fin DATE) RETURN NUMBER IS
  BEGIN
    RETURN ROUND((p_fin - p_ini) * 24, 2);
  END;

  FUNCTION horas_programadas_mes(p_emp NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER IS
    v_total NUMBER := 0;
    v_ini DATE := TRUNC(TO_DATE(p_anio||'-'||p_mes,'YYYY-MM'), 'MM');
    v_fin DATE := LAST_DAY(v_ini);
  BEGIN
    FOR r IN (
      SELECT eh.dia_semana, h.hora_inicio, h.hora_fin, h.turno
        FROM hr.empleado_horario eh
        JOIN hr.horario h ON h.dia_semana = eh.dia_semana AND h.turno = eh.turno
       WHERE eh.employee_id = p_emp
    ) LOOP
      IF r.turno = 'OFF' THEN CONTINUE; END IF;
      FOR d IN (
        SELECT v_ini + LEVEL - 1 AS fecha
          FROM dual
        CONNECT BY v_ini + LEVEL - 1 <= v_fin
      ) LOOP
        IF TO_CHAR(d.fecha,'DY','NLS_DATE_LANGUAGE=ENGLISH') = r.dia_semana THEN
          v_total := v_total + horas_entre(r.hora_inicio, r.hora_fin);
        END IF;
      END LOOP;
    END LOOP;
    RETURN v_total;
  END;

  FUNCTION horas_trabajadas(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER IS
    v_total NUMBER := 0;
  BEGIN
    SELECT NVL(SUM(ROUND((hora_fin_real - hora_inicio_real)*24,2)),0)
      INTO v_total
      FROM hr.asistencia_empleado
     WHERE employee_id = p_employee_id
       AND EXTRACT(MONTH FROM fecha_real) = p_mes
       AND EXTRACT(YEAR  FROM fecha_real) = p_anio;
    RETURN v_total;
  END;

  FUNCTION horas_faltadas(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER IS
    v_prog NUMBER := horas_programadas_mes(p_employee_id, p_mes, p_anio);
    v_trab NUMBER := horas_trabajadas(p_employee_id, p_mes, p_anio);
  BEGIN
    RETURN GREATEST(v_prog - v_trab, 0);
  END;

  PROCEDURE liquidacion_mensual(p_mes NUMBER, p_anio NUMBER, o_rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN o_rc FOR
      WITH datos AS (
        SELECT e.employee_id, e.first_name nombre, e.last_name apellido, e.salary salario
          FROM hr.employees e
      ),
      calc AS (
        SELECT d.*,
               pkg_asistencia_empleado.horas_trabajadas(d.employee_id, p_mes, p_anio) horas_trab,
               pkg_asistencia_empleado.horas_faltadas  (d.employee_id, p_mes, p_anio) horas_falta
          FROM datos d
      )
      SELECT nombre, apellido,
             CASE WHEN (horas_trab + horas_falta) > 0
                  THEN ROUND(salario * (horas_trab / (horas_trab + horas_falta)),2)
                  ELSE 0 END AS sueldo_calculado
        FROM calc
       ORDER BY apellido, nombre;
  END;

END pkg_asistencia_empleado;

-- PRUEBAS ------------------------------------------------------

ALTER SESSION SET NLS_DATE_LANGUAGE = 'ENGLISH';
ALTER SESSION SET NLS_TERRITORY = 'AMERICA';

-- 3.1.5
SELECT hr.pkg_asistencia_empleado.horas_trabajadas(100, 5, 2025) AS horas_trabajadas FROM dual;

-- 3.1.6
SELECT hr.pkg_asistencia_empleado.horas_faltadas(100, 5, 2025) AS horas_faltadas FROM dual;

-- 3.1.7
VAR rc REFCURSOR
EXEC hr.pkg_asistencia_empleado.liquidacion_mensual(5, 2025, :rc);
PRINT rc;
