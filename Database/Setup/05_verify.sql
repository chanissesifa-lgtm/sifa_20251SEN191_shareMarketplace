
-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: [Your Group, e.g., Group A / B / C / D]
-- Project Name: Local Company Share Marketplace

ALTER SESSION SET CONTAINER = CDB$ROOT;
SELECT con_id, name, open_mode FROM v$pdbs WHERE name = 'GRP_20251SEN191_SIFA_MKT_DB';
ARCHIVE LOG LIST;

ALTER SESSION SET CONTAINER = grp_20251sen191_sifa_mkt_db;

SELECT username, default_tablespace, temporary_tablespace
FROM dba_users
WHERE username = 'SIFA_ADMIN';

SELECT tablespace_name,
       ROUND(bytes / 1024 / 1024, 2) AS size_mb,
       autoextensible,
       ROUND(increment_by * 8192 / 1024 / 1024, 2) AS next_mb,
       ROUND(maxbytes / 1024 / 1024, 2) AS max_mb
FROM dba_data_files
WHERE tablespace_name IN ('MKT_DATA', 'MKT_IDX')
UNION ALL
SELECT tablespace_name,
       ROUND(bytes / 1024 / 1024, 2) AS size_mb,
       autoextensible,
       ROUND(increment_by * 8192 / 1024 / 1024, 2) AS next_mb,
       ROUND(maxbytes / 1024 / 1024, 2) AS max_mb
FROM dba_temp_files
WHERE tablespace_name = 'MKT_TEMP';

EXEC DBMS_XDB_CONFIG.SETHTTPSPORT(5591);