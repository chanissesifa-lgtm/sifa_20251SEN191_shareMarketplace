
-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: [Your Group, e.g., Group A / B / C / D]
-- Project Name: Local Company Share Marketplace

-- Archive logging preserves redo log history across the database for point-in-time recovery.
-- In Oracle's multitenant architecture, redo generation and archival processes belong to the CDB,
-- not an individual PDB. Because all PDBs share the CDB's redo and recovery infrastructure,
-- ARCHIVELOG mode is configured at the CDB level with SYSDBA privileges and a database restart,
-- rather than per PDB.

ALTER SESSION SET CONTAINER = CDB$ROOT;
ARCHIVE LOG LIST;

-- Local installation steps only (do not run on a shared lab server):
-- SHUTDOWN IMMEDIATE;
-- STARTUP MOUNT;
-- ALTER DATABASE ARCHIVELOG;
-- ALTER DATABASE OPEN;
-- ARCHIVE LOG LIST;