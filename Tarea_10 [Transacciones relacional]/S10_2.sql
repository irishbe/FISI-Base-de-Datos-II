-- a) ¿Por qué la segunda sesión quedó bloqueada?
--    Porque la primera sesión actualizó la misma fila y no ejecutó COMMIT ni ROLLBACK,
--    por lo tanto, Oracle bloqueó la fila para mantener la integridad de los datos.

-- b) ¿Qué comando libera los bloqueos?
--    Los comandos COMMIT o ROLLBACK liberan los bloqueos.

-- c) ¿Qué vistas del diccionario permiten verificar sesiones bloqueadas?
--    v$session, v$locked_object, v$lock, dba_blockers y dba_waiters.