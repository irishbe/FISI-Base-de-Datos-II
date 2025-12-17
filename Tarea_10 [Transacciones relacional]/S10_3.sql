DECLARE
  v_old_dept employees.department_id%TYPE;
  v_old_job  employees.job_id%TYPE;
  v_start    DATE;
  v_end_     DATE := SYSDATE;
BEGIN
  SAVEPOINT xfer;

  SELECT department_id, job_id
    INTO v_old_dept, v_old_job
    FROM employees
   WHERE employee_id = 104
   FOR UPDATE;

  SELECT NVL(MAX(end_date) + 1/86400, SYSDATE - 1/86400)
    INTO v_start
    FROM job_history
   WHERE employee_id = 104;

  UPDATE employees
     SET department_id = 110
   WHERE employee_id = 104;

  INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
  VALUES (104, v_start, v_end_, v_old_job, v_old_dept);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Transferencia registrada.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO xfer;
    DBMS_OUTPUT.PUT_LINE('Error, se revirtió la transacción: ' || SQLERRM);
END;
/


-- a) Debe ser atómica para que cambio en EMPLOYEES y registro en JOB_HISTORY ocurran juntos; si uno falla y el otro no, queda inconsistencia.
-- b) Se revierte todo (ROLLBACK/SAVEPOINT) y nada persiste: ni el cambio de departamento ni el insert en JOB_HISTORY.
-- c) Con la FK entre JOB_HISTORY.EMPLOYEE_ID → EMPLOYEES.EMPLOYEE_ID (y la FK de departamento); además, la transacción atómica evita registros “huérfanos”.
