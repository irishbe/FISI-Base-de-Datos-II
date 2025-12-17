CREATE OR REPLACE PACKAGE hr.pkg_analitica_empleados AS
  PROCEDURE top4_empleados_rotacion(o_rc OUT SYS_REFCURSOR);
  FUNCTION promedio_contrataciones_por_mes(o_rc OUT SYS_REFCURSOR) RETURN NUMBER;
  PROCEDURE estadistica_por_region(o_rc OUT SYS_REFCURSOR);
  FUNCTION tiempo_servicio_y_vacaciones(o_rc OUT SYS_REFCURSOR) RETURN NUMBER;
END pkg_analitica_empleados;
/


CREATE OR REPLACE PACKAGE BODY hr.pkg_analitica_empleados AS

  PROCEDURE top4_empleados_rotacion(o_rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN o_rc FOR
      SELECT e.employee_id,
             e.last_name AS apellido,
             e.first_name AS nombre,
             e.job_id AS puesto_id,
             j.job_title AS puesto,
             NVL(c.cambios,0) AS cambios
        FROM hr.employees e
        JOIN hr.jobs j ON j.job_id = e.job_id
        LEFT JOIN (
          SELECT employee_id, COUNT(*) cambios
            FROM hr.job_history
           GROUP BY employee_id
        ) c ON c.employee_id = e.employee_id
       ORDER BY NVL(c.cambios,0) DESC, e.employee_id
       FETCH FIRST 4 ROWS ONLY;
  END;

  FUNCTION promedio_contrataciones_por_mes(o_rc OUT SYS_REFCURSOR) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    OPEN o_rc FOR
      WITH base AS (
        SELECT EXTRACT(MONTH FROM hire_date) mes, EXTRACT(YEAR FROM hire_date) anio
          FROM hr.employees
      ),
      agrupado AS (
        SELECT mes, COUNT(*) contrataciones, COUNT(DISTINCT anio) anios
          FROM base
         GROUP BY mes
      )
      SELECT TO_CHAR(TO_DATE(mes,'MM'),'Month','NLS_DATE_LANGUAGE=ENGLISH') mes,
             ROUND(contrataciones / NULLIF(anios,0),2) promedio
        FROM agrupado
       ORDER BY mes;
    SELECT COUNT(DISTINCT EXTRACT(MONTH FROM hire_date)) INTO v_total FROM hr.employees;
    RETURN v_total;
  END;

  PROCEDURE estadistica_por_region(o_rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN o_rc FOR
      SELECT r.region_name region,
             SUM(e.salary) total_salarios,
             COUNT(e.employee_id) cantidad,
             MIN(e.hire_date) ingreso_mas_antiguo
        FROM hr.regions r
        JOIN hr.countries c ON c.region_id = r.region_id
        JOIN hr.locations l ON l.country_id = c.country_id
        JOIN hr.departments d ON d.location_id = l.location_id
        LEFT JOIN hr.employees e ON e.department_id = d.department_id
       GROUP BY r.region_name
       ORDER BY r.region_name;
  END;

  FUNCTION tiempo_servicio_y_vacaciones(o_rc OUT SYS_REFCURSOR) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    OPEN o_rc FOR
      SELECT e.employee_id,
             e.last_name apellido,
             e.first_name nombre,
             e.hire_date fecha_ingreso,
             e.salary salario,
             TRUNC(MONTHS_BETWEEN(SYSDATE,e.hire_date)/12) anios_servicio,
             ROUND((e.salary/12)*TRUNC(MONTHS_BETWEEN(SYSDATE,e.hire_date)/12),2) costo_vacaciones
        FROM hr.employees e
       ORDER BY e.last_name, e.first_name;
    SELECT SUM(ROUND((salary/12)*TRUNC(MONTHS_BETWEEN(SYSDATE,hire_date)/12),2))
      INTO v_total FROM hr.employees;
    RETURN NVL(v_total,0);
  END;

END pkg_analitica_empleados;
/


-- Pruebas

ALTER SESSION SET NLS_DATE_LANGUAGE = 'ENGLISH';
ALTER SESSION SET NLS_TERRITORY = 'AMERICA';

VAR rc REFCURSOR
EXEC hr.pkg_analitica_empleados.top4_empleados_rotacion(:rc);
PRINT rc

VAR rc REFCURSOR
VAR total NUMBER
EXEC :total := hr.pkg_analitica_empleados.promedio_contrataciones_por_mes(:rc);
PRINT rc
PRINT total

VAR rc REFCURSOR
EXEC hr.pkg_analitica_empleados.estadistica_por_region(:rc);
PRINT rc

VAR rc REFCURSOR
VAR total NUMBER
EXEC :total := hr.pkg_analitica_empleados.tiempo_servicio_y_vacaciones(:rc);
PRINT rc
PRINT total
