
-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: [Your Group, e.g., Group A / B / C / D]
-- Project Name: Local Company Share Marketplace

ALTER SESSION SET CONTAINER = CDB$ROOT;

CREATE PLUGGABLE DATABASE grp_20251sen191_sifa_mkt_db
  ADMIN USER sifa_admin IDENTIFIED BY "sifa"
  FILE_NAME_CONVERT = ('C:\APP\ORADATA\ORCL\PDBSEED\', 'C:\APP\ORADATA\ORCL\grp_20251sen191_sifa_mkt_db\');

ALTER PLUGGABLE DATABASE grp_20251sen191_sifa_mkt_db OPEN READ WRITE;
ALTER PLUGGABLE DATABASE grp_20251sen191_sifa_mkt_db SAVE STATE;