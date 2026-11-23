
-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: [Your Group, e.g., Group A / B / C / D]
-- Project Name: Local Company Share Marketplace

ALTER SESSION SET CONTAINER = grp_20251sen191_sifa_mkt_db;

-- CREATE USER sifa_admin IDENTIFIED BY "sifa";
GRANT DBA TO sifa_admin;
ALTER USER sifa_admin DEFAULT TABLESPACE mkt_data;
ALTER USER sifa_admin TEMPORARY TABLESPACE mkt_temp;
ALTER USER sifa_admin QUOTA UNLIMITED ON mkt_data;
ALTER USER sifa_admin QUOTA UNLIMITED ON mkt_idx;