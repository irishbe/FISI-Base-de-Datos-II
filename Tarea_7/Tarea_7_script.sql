-- 1 Obtenga el color y ciudad para las partes que no son de París, con un peso mayor de diez.
CREATE OR REPLACE PROCEDURE tarea_siete_p1 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT p.color, p.city
        FROM p
        WHERE p.city <> 'Paris'
        AND p.weight > 10;
    ClOSE rc;
END;


-- 2 Para todas las partes, obtenga el número de parte y el peso de dichas partes en gramos.
-- (1 libra = 453.592 gramos)
CREATE OR REPLACE PROCEDURE tarea_siete_p2 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT  p.p# AS NUMERO_P,
                p.weight AS PESO_LIBRAS,
                (p.weight * 453.592) AS PESO_GRAMOS
        FROM p;
END;

-- 3 Obtenga el detalle completo de todos los proveedores.
CREATE OR REPLACE PROCEDURE tarea_siete_p3 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT s.*
        FROM s;
END;

-- 4 Obtenga todas las combinaciones de proveedores y partes para aquellos proveedores y partes co-localizados.
CREATE OR REPLACE PROCEDURE tarea_siete_p4 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT s.s# AS S_NUMERO, p.p# AS P_NUMERO, s.city AS CIUDAD
        FROM   s CROSS JOIN p
        WHERE  s.city = p.city;
END;

-- 5 Obtenga todos los pares de nombres de ciudades de tal forma que el proveedor localizado en la primera ciudad del par abastece una parte almacenada en la segunda ciudad del par.
CREATE OR REPLACE PROCEDURE tarea_siete_p5 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT DISTINCT s.city AS CIUDAD_PROVEEDOR,
                        p.city AS CIUDAD_PARTE
        FROM sp
        JOIN s ON s.s# = sp.s#
        JOIN p ON p.p# = sp.p#;
END;

-- 6 Obtenga todos los pares de número de proveedor tales que los dos proveedores del par estén co-localizados.
CREATE OR REPLACE PROCEDURE tarea_siete_p6 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT s1.s# AS S_NUMERO_1, s2.s# AS S_NUMERO_2, s1.city
        FROM   s s1
        JOIN   s s2 ON s1.city = s2.city AND s1.s# < s2.s#;
END;

-- 7 Obtenga el número total de proveedores.
CREATE OR REPLACE PROCEDURE tarea_siete_p7 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT COUNT(*) AS TOTAL_PROVEEDORES
        FROM s;
END;

-- 8 Obtenga la cantidad mínima y la cantidad máxima para la parte P2.
CREATE OR REPLACE PROCEDURE tarea_siete_p8 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT MIN(sp.qty) AS MIN_CANTIDAD,
               MAX(sp.qty) AS MAX_CANTIDAD
        FROM sp
        WHERE sp.p# = 'P2';
END;

-- 9 Para cada parte abastecida, obtenga el número de parte y el total despachado.
CREATE OR REPLACE PROCEDURE tarea_siete_p9 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT sp.p# AS P_NUMERO,
               SUM(sp.qty) AS TOTAL_CANTIDAD
        FROM sp
        GROUP BY sp.p#;
END;

-- 10 Obtenga el número de parte para todas las partes abastecidas por más de un proveedor.
CREATE OR REPLACE PROCEDURE tarea_siete_p10 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT sp.p# AS P_NUMERO
        FROM sp
        GROUP BY sp.p#
        HAVING COUNT(DISTINCT sp.s#) > 1;
END;

-- 11 Obtenga el nombre de proveedor para todos los proveedores que abastecen la parte P2.
CREATE OR REPLACE PROCEDURE tarea_siete_p11 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT DISTINCT s.sname AS NOMBRE_PROVEEDOR
        FROM sp
        JOIN s ON s.s# = sp.s#
        WHERE sp.p# = 'P2';
END;

-- 12 Obtenga el nombre de proveedor de quienes abastecen por lo menos una parte.
CREATE OR REPLACE PROCEDURE tarea_siete_p12 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT DISTINCT s.sname AS NOMBRE_PROVEEDOR
        FROM s
        WHERE EXISTS (SELECT 1 FROM sp WHERE sp.s# = s.s#);
END;

-- 13 Obtenga el número de proveedor para los proveedores con estado menor que el máximo valor de estado en la tabla S.
CREATE OR REPLACE PROCEDURE tarea_siete_p13 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT s.s#
        FROM s
        WHERE s.status < (SELECT MAX(s2.status) FROM s s2);
END;

-- 14 Obtenga el nombre de proveedor para los proveedores que abastecen la parte P2 (aplicar EXISTS en su solución).
CREATE OR REPLACE PROCEDURE tarea_siete_p14 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT s.sname AS NOMBRE_PROVEEDOR
        FROM s
        WHERE EXISTS (
            SELECT 1
            FROM sp
            WHERE sp.s# = s.s# AND sp.p# = 'P2'
        );
END;

-- 15 Obtenga el nombre de proveedor para los proveedores que no abastecen la parte P2.
CREATE OR REPLACE PROCEDURE tarea_siete_p15 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT s.sname AS NOMBRE_PROVEEDOR
        FROM s
        WHERE NOT EXISTS (
            SELECT 1
            FROM sp
            WHERE sp.s# = s.s# AND sp.p# = 'P2'
        );
END;

-- 16 Obtenga el nombre de proveedor para los proveedores que abastecen todas las partes.
CREATE OR REPLACE PROCEDURE tarea_siete_p16 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT s.sname AS NOMBRE_PROVEEDOR
        FROM s
        WHERE NOT EXISTS (
            SELECT 1
            FROM p
            WHERE NOT EXISTS (
                SELECT 1
                FROM sp
                WHERE sp.s# = s.s# AND sp.p# = p.p#
            )
        );
END;

-- 17 Obtenga el número de parte para todas las partes que pesan más de 16 libras ó son abastecidas por el proveedor S2, ó cumplen con ambos criterios.
CREATE OR REPLACE PROCEDURE tarea_siete_p17 (rc OUT SYS_REFCURSOR) AS
BEGIN
    OPEN rc FOR
        SELECT DISTINCT p.p# AS P_NUMERO
        FROM p
        WHERE p.weight > 16
           OR EXISTS (
                SELECT 1
                FROM sp
                WHERE sp.p# = p.p# AND sp.s# = 'S2'
           );
END;
