BEGIN
    -- +10% a salarios del dept 90 (respetando max_salary del job por si hay trigger de rango)
    UPDATE employees e
       SET e.salary = LEAST(
             e.salary * 1.10,
             (SELECT j.max_salary FROM jobs j WHERE j.job_id = e.job_id)
           )
     WHERE e.department_id = 90;

    SAVEPOINT punto1;

    -- +5% a salarios del dept 60 (también respetando max_salary)
    UPDATE employees e
       SET e.salary = LEAST(
             e.salary * 1.05,
             (SELECT j.max_salary FROM jobs j WHERE j.job_id = e.job_id)
           )
     WHERE e.department_id = 60;

    -- Reversión parcial: deshace lo hecho después de 'punto1'
    ROLLBACK TO punto1;

    -- Confirma lo realizado antes del savepoint
    COMMIT;
END;
/
-- a) El departamento 90 mantuvo los cambios (el +10%).
-- b) El ROLLBACK parcial deshizo los cambios posteriores al SAVEPOINT, es decir, el +5% del dept 60.
-- c) Con ROLLBACK sin SAVEPOINT se revierte toda la transacción (también se perdería el +10% del dept 90).
