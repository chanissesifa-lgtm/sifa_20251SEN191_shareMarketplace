
-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: [Your Group, e.g., Group A / B / C / D]
-- Project Name: Local Company Share Marketplace

ALTER SESSION SET CONTAINER = grp_20251sen191_sifa_mkt_db;

CREATE TABLESPACE mkt_data
  DATAFILE 'C:\APP\ORADATA\ORCL\grp_20251sen191_sifa_mkt_db\mkt_data01.dbf' SIZE 100M
  AUTOEXTEND ON NEXT 10M MAXSIZE 1G;

CREATE TABLESPACE mkt_idx
  DATAFILE 'C:\APP\ORADATA\ORCL\grp_20251sen191_sifa_mkt_db\mkt_idx01.dbf' SIZE 50M
  AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

CREATE TEMPORARY TABLESPACE mkt_temp
  TEMPFILE 'C:\APP\ORADATA\ORCL\grp_20251sen191_sifa_mkt_db\mkt_temp01.dbf' SIZE 50M
  AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

ALTER USER sifa_admin DEFAULT TABLESPACE mkt_data;
ALTER USER sifa_admin TEMPORARY TABLESPACE mkt_temp;
ALTER USER sifa_admin QUOTA UNLIMITED ON mkt_data;
ALTER USER sifa_admin QUOTA UNLIMITED ON mkt_idx;