--Proyecto final Bases de Datos: SGBD Hospital
--Script 06: seguridad y permisos
--Ejecutar despues del script 05 (procedimientos)
--Requisito: SQL Server debe aceptar autenticacion de SQL Server
--(clic derecho en el servidor > Properties > Security > "SQL Server and Windows Authentication mode"
--y reiniciar el servicio)

--Idea general:
--Cada perfil tiene un login, un usuario y un rol en la base de datos.
--Los roles NO tienen permisos sobre las tablas: solo pueden ejecutar sus procedimientos
--y consultar sus vistas. SQL Server deja que el SP o la vista lean las tablas por dentro
--(encadenamiento de propiedad), pero nadie puede tocar las tablas directamente.

/* =========================================================
1. LOGINS (nivel servidor)
========================================================= */
USE master;
GO
CREATE LOGIN login_app WITH PASSWORD = 'App#Hospital2026', DEFAULT_DATABASE = HospitalDB;
CREATE LOGIN login_paciente WITH PASSWORD = 'Paciente#Hospital2026', DEFAULT_DATABASE = HospitalDB;
CREATE LOGIN login_doctor WITH PASSWORD = 'Doctor#Hospital2026', DEFAULT_DATABASE = HospitalDB;
CREATE LOGIN login_recepcionista WITH PASSWORD = 'Recep#Hospital2026', DEFAULT_DATABASE = HospitalDB;
CREATE LOGIN login_farmaceutico WITH PASSWORD = 'Farma#Hospital2026', DEFAULT_DATABASE = HospitalDB;
CREATE LOGIN login_admin WITH PASSWORD = 'Admin#Hospital2026', DEFAULT_DATABASE = HospitalDB;
GO

/* =========================================================
2. USUARIOS Y ROLES (nivel base de datos)
========================================================= */
USE HospitalDB;
GO
--Un usuario de base de datos por cada login
CREATE USER usr_app FOR LOGIN login_app;
CREATE USER usr_paciente FOR LOGIN login_paciente;
CREATE USER usr_doctor FOR LOGIN login_doctor;
CREATE USER usr_recepcionista FOR LOGIN login_recepcionista;
CREATE USER usr_farmaceutico FOR LOGIN login_farmaceutico;
CREATE USER usr_admin FOR LOGIN login_admin;
GO

--Un rol por perfil
CREATE ROLE rol_publico;
CREATE ROLE rol_paciente;
CREATE ROLE rol_doctor;
CREATE ROLE rol_recepcionista;
CREATE ROLE rol_farmaceutico;
GO

--Cada usuario entra a su rol
ALTER ROLE rol_publico ADD MEMBER usr_app;
ALTER ROLE rol_paciente ADD MEMBER usr_paciente;
ALTER ROLE rol_doctor ADD MEMBER usr_doctor;
ALTER ROLE rol_recepcionista ADD MEMBER usr_recepcionista;
ALTER ROLE rol_farmaceutico ADD MEMBER usr_farmaceutico;
--El administrador es dueño de la base de datos (puede hacer todo)
ALTER ROLE db_owner ADD MEMBER usr_admin;
GO

/* =========================================================
3. PERMISOS POR PERFIL
========================================================= */

--PUBLICO: la conexion de Flask antes de iniciar sesion (solo login y registro)
GRANT EXECUTE ON sp_Login TO rol_publico;
GRANT EXECUTE ON sp_RegistrarPaciente TO rol_publico;
GRANT SELECT ON V_ESPECIALIDADES TO rol_publico;
GO

--PACIENTE
GRANT SELECT ON V_DATOS_PACIENTE TO rol_paciente;
GRANT SELECT ON V_CITAS_PACIENTE TO rol_paciente;
GRANT SELECT ON V_COMPROBANTE_CITA TO rol_paciente;
GRANT SELECT ON V_DOCTORES_POR_ESPECIALIDAD TO rol_paciente;
GRANT SELECT ON V_HORARIOS_OCUPADOS TO rol_paciente;
GRANT SELECT ON V_ESPECIALIDADES TO rol_paciente;
GRANT EXECUTE ON sp_AgendarCita TO rol_paciente;
GRANT EXECUTE ON sp_PagarCita TO rol_paciente;
GRANT EXECUTE ON sp_CancelarCitaPaciente TO rol_paciente;
GRANT EXECUTE ON sp_ActualizarPaciente TO rol_paciente;
GRANT EXECUTE ON sp_CancelarFaltaPago TO rol_paciente;
GO

--DOCTOR
GRANT SELECT ON V_DATOS_DOCTOR TO rol_doctor;
GRANT SELECT ON V_CITAS_DOCTOR TO rol_doctor;
GRANT SELECT ON V_RECETA TO rol_doctor;
GRANT SELECT ON V_RECETA_MEDICAMENTOS TO rol_doctor;
GRANT SELECT ON V_HISTORIAL_MEDICO TO rol_doctor;
GRANT SELECT ON V_INVENTARIO TO rol_doctor;
GRANT EXECUTE ON sp_CrearReceta TO rol_doctor;
GRANT EXECUTE ON sp_AgregarMedicamentoReceta TO rol_doctor;
GRANT EXECUTE ON sp_GuardarHistorial TO rol_doctor;
GRANT EXECUTE ON sp_SolicitarCancelacionDoctor TO rol_doctor;
GRANT EXECUTE ON sp_ActualizarContactoEmpleado TO rol_doctor;
GO

--RECEPCIONISTA
GRANT SELECT ON V_EMPLEADOS TO rol_recepcionista;
GRANT SELECT ON V_DATOS_DOCTOR TO rol_recepcionista;
GRANT SELECT ON V_DATOS_PACIENTE TO rol_recepcionista;
GRANT SELECT ON V_CITAS_RECEPCION TO rol_recepcionista;
GRANT SELECT ON V_COMPROBANTE_CITA TO rol_recepcionista;
GRANT SELECT ON V_SOLICITUDES_CANCELACION TO rol_recepcionista;
GRANT SELECT ON V_ESPECIALIDADES TO rol_recepcionista;
GRANT SELECT ON V_DOCTORES_POR_ESPECIALIDAD TO rol_recepcionista;
GRANT SELECT ON V_HORARIOS_OCUPADOS TO rol_recepcionista;
GRANT SELECT ON V_TICKET_DETALLE TO rol_recepcionista;
GRANT SELECT ON V_TICKET_TOTAL TO rol_recepcionista;
GRANT EXECUTE ON sp_AltaEmpleado TO rol_recepcionista;
GRANT EXECUTE ON sp_ActualizarDoctor TO rol_recepcionista;
GRANT EXECUTE ON sp_BajaEmpleado TO rol_recepcionista;
GRANT EXECUTE ON sp_ResolverCancelacion TO rol_recepcionista;
GRANT EXECUTE ON sp_MarcarNoAcudio TO rol_recepcionista;
GRANT EXECUTE ON sp_RegistrarPaciente TO rol_recepcionista;
GRANT EXECUTE ON sp_PagarCita TO rol_recepcionista;
GRANT EXECUTE ON sp_CrearVenta TO rol_recepcionista;
GRANT EXECUTE ON sp_AgregarServicioVenta TO rol_recepcionista;
GO
--La recepcionista NO puede ver recetas ni historial medico (lo pide el PDF)
DENY SELECT ON V_RECETA TO rol_recepcionista;
DENY SELECT ON V_RECETA_MEDICAMENTOS TO rol_recepcionista;
DENY SELECT ON V_HISTORIAL_MEDICO TO rol_recepcionista;
DENY SELECT, INSERT, UPDATE, DELETE ON RECETA TO rol_recepcionista;
DENY SELECT, INSERT, UPDATE, DELETE ON RECETA_MEDICAMENTO TO rol_recepcionista;
DENY SELECT, INSERT, UPDATE, DELETE ON HISTORIAL_MEDICO TO rol_recepcionista;
DENY EXECUTE ON sp_CrearReceta TO rol_recepcionista;
DENY EXECUTE ON sp_AgregarMedicamentoReceta TO rol_recepcionista;
DENY EXECUTE ON sp_GuardarHistorial TO rol_recepcionista;
GO

--FARMACEUTICO
GRANT SELECT ON V_INVENTARIO TO rol_farmaceutico;
GRANT SELECT ON V_RECETA_MEDICAMENTOS TO rol_farmaceutico;
GRANT SELECT ON V_TICKET_DETALLE TO rol_farmaceutico;
GRANT SELECT ON V_TICKET_TOTAL TO rol_farmaceutico;
GRANT EXECUTE ON sp_CrearVenta TO rol_farmaceutico;
GRANT EXECUTE ON sp_AgregarMedicamentoVenta TO rol_farmaceutico;
GRANT EXECUTE ON sp_AgregarServicioVenta TO rol_farmaceutico;
GO

/* =========================================================
4. BITACORAS: solo consulta e insercion para todos
========================================================= */
--"public" es el rol al que pertenecen todos los usuarios de la base
DENY UPDATE, DELETE ON BITACORA_ESTATUS_CITA TO public;
DENY UPDATE, DELETE ON BITACORA_HISTORIAL_CITA TO public;
GO

/* =========================================================
5. COMPROBAR LOS PERMISOS
========================================================= */
--Lista de permisos de cada rol
SELECT pr.name AS rol,
pe.state_desc AS permiso,
pe.permission_name AS accion,
OBJECT_NAME(pe.major_id) AS objeto
FROM sys.database_permissions pe
JOIN sys.database_principals pr ON pr.principal_id = pe.grantee_principal_id
WHERE pr.name LIKE 'rol_%' OR pr.name = 'public' AND OBJECT_NAME(pe.major_id) LIKE 'BITACORA%'
ORDER BY pr.name, objeto;
GO

--Probar como recepcionista: la primera consulta funciona, la segunda debe marcar error de permisos
EXECUTE AS USER = 'usr_recepcionista';
SELECT TOP 5 * FROM V_CITAS_RECEPCION;
SELECT TOP 5 * FROM V_RECETA;
REVERT;
GO
