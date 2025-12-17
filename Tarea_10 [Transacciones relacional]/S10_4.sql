BEGIN
    UPDATE employees e
       SET e.salary = CASE 
                        WHEN e.salary * 1.08 > (SELECT j.max_salary FROM jobs j WHERE j.job_id = e.job_id)
                        THEN (SELECT j.max_salary FROM jobs j WHERE j.job_id = e.job_id)
                        ELSE e.salary * 1.08
                     END
     WHERE e.department_id = 100;
    SAVEPOINT A;

    UPDATE employees e
       SET e.salary = CASE 
                        WHEN e.salary * 1.05 > (SELECT j.max_salary FROM jobs j WHERE j.job_id = e.job_id)
                        THEN (SELECT j.max_salary FROM jobs j WHERE j.job_id = e.job_id)
                        ELSE e.salary * 1.05
                     END
     WHERE e.department_id = 80;
    SAVEPOINT B;

    DELETE FROM employees e
     WHERE e.department_id = 50
       AND e.employee_id NOT IN (SELECT d.manager_id FROM departments d WHERE d.manager_id IS NOT NULL)
       AND e.employee_id NOT IN (SELECT jh.employee_id FROM job_history jh);

    ROLLBACK TO B;
    COMMIT;
END;
/

-- a) Quedan persistentes los aumentos de los departamentos 100 y 80.
-- b) Las filas eliminadas se revierten con el ROLLBACK TO B.
-- c) Se verifica con consultas SELECT antes y después del COMMIT.