--5. COMPROBAR LOS PERMISOS

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
