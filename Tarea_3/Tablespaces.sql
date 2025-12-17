-- Tablespace para datos del sistema de ciclistas
CREATE TABLESPACE ts_data_cycling
DATAFILE 'ts_data_cycling01.dbf' SIZE 6M
AUTOEXTEND ON NEXT 1M MAXSIZE 10M
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;

-- Tablespace temporal del sistema de ciclistas
CREATE TEMPORARY TABLESPACE ts_temp_cycling
TEMPFILE 'ts_temp_cycling.dbf' SIZE 2M
AUTOEXTEND ON NEXT 1M MAXSIZE 5M
EXTENT MANAGEMENT LOCAL;
