CREATE OR REPLACE PACKAGE hr.pkg_capacitacion AS
  -- 3.1.1
  FUNCTION horas_totales_por_empleado RETURN SYS_REFCURSOR;
  -- 3.1.2
  PROCEDURE listado_capacitaciones(o_rc OUT SYS_REFCURSOR);
END pkg_capacitacion;
/

CREATE OR REPLACE PACKAGE BODY hr.pkg_capacitacion AS

  FUNCTION horas_totales_por_empleado RETURN SYS_REFCURSOR IS
    rc SYS_REFCURSOR;
  BEGIN
    OPEN rc FOR
      SELECT e.employee_id,
             e.last_name  AS apellido,
             e.first_name AS nombre,
             NVL(SUM(c.horas),0) AS horas_totales
        FROM hr.employees e
        LEFT JOIN hr.empleado_capacitacion ec ON ec.employee_id = e.employee_id
        LEFT JOIN hr.capacitacion c           ON c.cap_id       = ec.cap_id
       GROUP BY e.employee_id, e.last_name, e.first_name
       ORDER BY horas_totales DESC, e.employee_id;
    RETURN rc;
  END;

  PROCEDURE listado_capacitaciones(o_rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN o_rc FOR
      SELECT c.cap_id,
             c.nombre        AS capacitacion,
             e.employee_id,
             e.last_name     AS apellido,
             e.first_name    AS nombre,
             NVL(c.horas,0)  AS horas_empleado_en_capacitacion
        FROM hr.capacitacion c
        LEFT JOIN hr.empleado_capacitacion ec ON ec.cap_id      = c.cap_id
        LEFT JOIN hr.employees e              ON e.employee_id  = ec.employee_id
       ORDER BY horas_empleado_en_capacitacion DESC, c.nombre, e.last_name, e.first_name;
  END;

END pkg_capacitacion;
/

-- PRUEBAS
-- 3.1.1
VAR rc REFCURSOR
EXEC :rc := hr.pkg_capacitacion.horas_totales_por_empleado();
PRINT rc

-- 3.1.2
VAR rc2 REFCURSOR
EXEC hr.pkg_capacitacion.listado_capacitaciones(:rc2);
PRINT rc2
