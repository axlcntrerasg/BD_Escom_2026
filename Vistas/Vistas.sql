--Proyecto final Bases de Datos: SGBD Hospital
--Script 03: vistas
--Las vistas no reciben parametros: la aplicacion filtra con WHERE
--Ejemplo: SELECT * FROM V_CITAS_PACIENTE WHERE id_paciente = 1 AND estatus = 'Atendida'

USE HospitalDB;
GO

--PACIENTE

--Datos personales del paciente con su edad y su usuario
CREATE VIEW V_DATOS_PACIENTE AS
SELECT p.id_paciente,
p.id_usuario,
u.username,
p.nombre,
p.ap_paterno,
p.ap_materno,
p.curp,
p.fecha_nacimiento,
--Edad exacta: resta 1 si todavia no cumple años este año
DATEDIFF(YEAR, p.fecha_nacimiento, GETDATE())
- CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, p.fecha_nacimiento, GETDATE()), p.fecha_nacimiento) > GETDATE() THEN 1 ELSE 0 END AS edad,
p.sexo,
p.telefono,
p.correo,
p.fecha_registro
FROM PACIENTE p
JOIN USUARIO u ON u.id_usuario = p.id_usuario;
GO

--Todas las citas del paciente con sus datos y estatus (se filtra por id_paciente, fecha o estatus)
CREATE VIEW V_CITAS_PACIENTE AS
SELECT c.folio_cita,
c.id_paciente,
c.fecha_cita,
c.hora_cita,
es.nombre AS especialidad,
e.nombre + ' ' + e.ap_paterno AS doctor,
co.numero AS consultorio,
c.costo,
c.linea_pago,
c.fecha_registro,
DATEADD(HOUR, 8, c.fecha_registro) AS fecha_limite_pago,
c.estatus,
ca.monto_devuelto
FROM CITA c
JOIN DOCTOR d ON d.num_empleado = c.num_empleado_doctor
JOIN EMPLEADO e ON e.num_empleado = d.num_empleado
JOIN ESPECIALIDAD es ON es.id_especialidad = d.id_especialidad
JOIN CONSULTORIO co ON co.id_consultorio = c.id_consultorio
LEFT JOIN CANCELACION ca ON ca.folio_cita = c.folio_cita AND ca.estado = 'Aprobada';
GO

--Comprobante de cita con los datos que pide el PDF
CREATE VIEW V_COMPROBANTE_CITA AS
SELECT c.folio_cita,
c.id_paciente,
p.nombre + ' ' + p.ap_paterno + ' ' + ISNULL(p.ap_materno, '') AS paciente,
c.fecha_cita,
c.hora_cita AS horario,
co.numero AS consultorio,
es.nombre AS especialidad,
e.nombre + ' ' + e.ap_paterno + ' ' + ISNULL(e.ap_materno, '') AS doctor,
c.costo,
c.linea_pago,
DATEADD(HOUR, 8, c.fecha_registro) AS pagar_antes_de,
'Tiene 8 horas a partir de que agendó para realizar su pago; si no paga, la cita se cancela.' AS leyenda_pago,
'Cancelación con 48 h o más: se devuelve el 100%. Entre 24 y 48 h: 50%. Menos de 24 h: 0%.' AS leyenda_cancelacion
FROM CITA c
JOIN PACIENTE p ON p.id_paciente = c.id_paciente
JOIN DOCTOR d ON d.num_empleado = c.num_empleado_doctor
JOIN EMPLEADO e ON e.num_empleado = d.num_empleado
JOIN ESPECIALIDAD es ON es.id_especialidad = d.id_especialidad
JOIN CONSULTORIO co ON co.id_consultorio = c.id_consultorio;
GO

--Para agendar: especialidades con su costo y sus doctores activos
CREATE VIEW V_DOCTORES_POR_ESPECIALIDAD AS
SELECT es.id_especialidad,
es.nombre AS especialidad,
es.costo_consulta,
d.num_empleado,
e.nombre + ' ' + e.ap_paterno + ' ' + ISNULL(e.ap_materno, '') AS doctor,
co.numero AS consultorio,
d.hora_entrada,
d.hora_salida
FROM ESPECIALIDAD es
JOIN DOCTOR d ON d.id_especialidad = es.id_especialidad
JOIN EMPLEADO e ON e.num_empleado = d.num_empleado
JOIN CONSULTORIO co ON co.id_consultorio = d.id_consultorio
WHERE e.activo = 1;
GO

--Para agendar: horarios ya ocupados de cada doctor (citas pendientes de pago o pagadas)
--La aplicacion muestra como disponibles los bloques de la jornada que no aparecen aqui
CREATE VIEW V_HORARIOS_OCUPADOS AS
SELECT num_empleado_doctor,
fecha_cita,
hora_cita
FROM CITA
WHERE estatus IN ('Agendada pendiente de pago', 'Pagada pendiente por atender');
GO

--DOCTOR

--Datos del doctor con su especialidad, consultorio y jornada
CREATE VIEW V_DATOS_DOCTOR AS
SELECT d.num_empleado,
e.id_usuario,
e.nombre,
e.ap_paterno,
e.ap_materno,
e.curp,
d.cedula_profesional,
es.nombre AS especialidad,
co.numero AS consultorio,
d.hora_entrada,
d.hora_salida,
e.telefono,
e.correo,
e.activo
FROM DOCTOR d
JOIN EMPLEADO e ON e.num_empleado = d.num_empleado
JOIN ESPECIALIDAD es ON es.id_especialidad = d.id_especialidad
JOIN CONSULTORIO co ON co.id_consultorio = d.id_consultorio;
GO

--Citas del doctor (se filtra por num_empleado_doctor)
CREATE VIEW V_CITAS_DOCTOR AS
SELECT c.folio_cita,
c.num_empleado_doctor,
c.fecha_cita,
c.hora_cita,
c.id_paciente,
p.nombre + ' ' + p.ap_paterno + ' ' + ISNULL(p.ap_materno, '') AS paciente,
DATEDIFF(YEAR, p.fecha_nacimiento, c.fecha_cita)
- CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, p.fecha_nacimiento, c.fecha_cita), p.fecha_nacimiento) > c.fecha_cita THEN 1 ELSE 0 END AS edad,
co.numero AS consultorio,
c.estatus,
r.folio_receta
FROM CITA c
JOIN PACIENTE p ON p.id_paciente = c.id_paciente
JOIN CONSULTORIO co ON co.id_consultorio = c.id_consultorio
LEFT JOIN RECETA r ON r.folio_cita = c.folio_cita;
GO

--Receta con los datos que pide el PDF (los medicamentos estan en V_RECETA_MEDICAMENTOS)
CREATE VIEW V_RECETA AS
SELECT r.folio_receta,
r.folio_cita,
r.fecha,
c.num_empleado_doctor,
e.nombre + ' ' + e.ap_paterno + ' ' + ISNULL(e.ap_materno, '') AS nombre_doctor,
d.cedula_profesional,
c.id_paciente,
p.nombre + ' ' + p.ap_paterno + ' ' + ISNULL(p.ap_materno, '') AS nombre_paciente,
DATEDIFF(YEAR, p.fecha_nacimiento, r.fecha)
- CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, p.fecha_nacimiento, r.fecha), p.fecha_nacimiento) > r.fecha THEN 1 ELSE 0 END AS edad,
r.diagnostico,
r.tratamiento,
r.observaciones
FROM RECETA r
JOIN CITA c ON c.folio_cita = r.folio_cita
JOIN DOCTOR d ON d.num_empleado = c.num_empleado_doctor
JOIN EMPLEADO e ON e.num_empleado = d.num_empleado
JOIN PACIENTE p ON p.id_paciente = c.id_paciente;
GO

--Medicamentos de cada receta
CREATE VIEW V_RECETA_MEDICAMENTOS AS
SELECT rm.folio_receta,
m.nombre AS medicamento,
m.presentacion,
rm.dosis
FROM RECETA_MEDICAMENTO rm
JOIN MEDICAMENTO m ON m.id_medicamento = rm.id_medicamento;
GO

--Historial medico con el nombre del paciente
CREATE VIEW V_HISTORIAL_MEDICO AS
SELECT h.id_historial,
h.id_paciente,
p.nombre + ' ' + p.ap_paterno + ' ' + ISNULL(p.ap_materno, '') AS nombre_paciente,
h.tipo_sangre,
h.alergias,
h.padecimientos_previos,
h.peso,
h.estatura
FROM HISTORIAL_MEDICO h
JOIN PACIENTE p ON p.id_paciente = h.id_paciente;
GO


--RECEPCIONISTA

--Todos los empleados con su rol
CREATE VIEW V_EMPLEADOS AS
SELECT e.num_empleado,
e.nombre,
e.ap_paterno,
e.ap_materno,
e.curp,
u.username,
u.rol,
e.telefono,
e.correo,
e.fecha_ingreso,
e.activo
FROM EMPLEADO e
JOIN USUARIO u ON u.id_usuario = e.id_usuario;
GO

--Todas las citas con paciente, doctor, especialidad y si ya se pagaron
CREATE VIEW V_CITAS_RECEPCION AS
SELECT c.folio_cita,
c.fecha_cita,
c.hora_cita,
p.nombre + ' ' + p.ap_paterno AS paciente,
e.nombre + ' ' + e.ap_paterno AS doctor,
es.nombre AS especialidad,
co.numero AS consultorio,
c.costo,
c.estatus,
CASE WHEN pa.id_pago IS NULL THEN 'No' ELSE 'Si' END AS pagada,
pa.metodo_pago,
ca.monto_devuelto
FROM CITA c
JOIN PACIENTE p ON p.id_paciente = c.id_paciente
JOIN DOCTOR d ON d.num_empleado = c.num_empleado_doctor
JOIN EMPLEADO e ON e.num_empleado = d.num_empleado
JOIN ESPECIALIDAD es ON es.id_especialidad = d.id_especialidad
JOIN CONSULTORIO co ON co.id_consultorio = c.id_consultorio
LEFT JOIN PAGO pa ON pa.folio_cita = c.folio_cita
LEFT JOIN CANCELACION ca ON ca.folio_cita = c.folio_cita AND ca.estado = 'Aprobada';
GO

--Solicitudes de cancelacion de los doctores (la recepcionista aprueba o rechaza las pendientes)
CREATE VIEW V_SOLICITUDES_CANCELACION AS
SELECT ca.id_cancelacion,
ca.folio_cita,
e.nombre + ' ' + e.ap_paterno AS doctor,
p.nombre + ' ' + p.ap_paterno AS paciente,
c.fecha_cita,
c.hora_cita,
ca.motivo,
ca.fecha_solicitud,
ca.estado,
ca.aprobada_por
FROM CANCELACION ca
JOIN CITA c ON c.folio_cita = ca.folio_cita
JOIN EMPLEADO e ON e.num_empleado = c.num_empleado_doctor
JOIN PACIENTE p ON p.id_paciente = c.id_paciente
WHERE ca.solicitada_por = 'Doctor';
GO

--Especialidades con cuantos doctores activos tiene cada una
CREATE VIEW V_ESPECIALIDADES AS
SELECT es.id_especialidad,
es.nombre,
es.costo_consulta,
COUNT(e.num_empleado) AS doctores_activos
FROM ESPECIALIDAD es
LEFT JOIN DOCTOR d ON d.id_especialidad = es.id_especialidad
LEFT JOIN EMPLEADO e ON e.num_empleado = d.num_empleado AND e.activo = 1
GROUP BY es.id_especialidad, es.nombre, es.costo_consulta;
GO

--Consultorios (para asignar uno al dar de alta un doctor)
CREATE VIEW V_CONSULTORIOS AS
SELECT id_consultorio,
numero,
piso
FROM CONSULTORIO;
GO

--FARMACIA Y COBRO

--Servicios extras con su precio (para cobrarlos)
CREATE VIEW V_SERVICIOS AS
SELECT id_servicio,
nombre,
precio
FROM SERVICIO;
GO

--Inventario de medicamentos con aviso de stock
CREATE VIEW V_INVENTARIO AS
SELECT id_medicamento,
nombre,
presentacion,
precio,
stock,
CASE
WHEN stock = 0 THEN 'Agotado'
WHEN stock < 20 THEN 'Stock bajo'
ELSE 'Disponible'
END AS estado_stock
FROM MEDICAMENTO;
GO

--Renglones del ticket: medicamento o servicio con su subtotal
CREATE VIEW V_TICKET_DETALLE AS
SELECT dv.id_venta,
dv.id_detalle,
CASE WHEN dv.id_medicamento IS NOT NULL THEN 'Medicamento' ELSE 'Servicio' END AS tipo,
ISNULL(m.nombre + ' ' + m.presentacion, s.nombre) AS concepto,
dv.cantidad,
dv.precio_unitario,
dv.cantidad * dv.precio_unitario AS subtotal
FROM DETALLE_VENTA dv
LEFT JOIN MEDICAMENTO m ON m.id_medicamento = dv.id_medicamento
LEFT JOIN SERVICIO s ON s.id_servicio = dv.id_servicio;
GO

--Ticket con su total (suma de medicamentos y servicios)
CREATE VIEW V_TICKET_TOTAL AS
SELECT v.id_venta,
v.fecha,
e.nombre + ' ' + e.ap_paterno AS atendio,
CASE
WHEN v.id_paciente IS NOT NULL THEN p.nombre + ' ' + p.ap_paterno
ELSE ISNULL(v.nombre_cliente, 'Público en general')
END AS cliente,
v.metodo_pago,
SUM(dv.cantidad * dv.precio_unitario) AS total
FROM VENTA v
JOIN EMPLEADO e ON e.num_empleado = v.num_empleado
LEFT JOIN PACIENTE p ON p.id_paciente = v.id_paciente
JOIN DETALLE_VENTA dv ON dv.id_venta = v.id_venta
GROUP BY v.id_venta, v.fecha, e.nombre, e.ap_paterno, v.id_paciente, p.nombre, p.ap_paterno, v.nombre_cliente, v.metodo_pago;
GO
