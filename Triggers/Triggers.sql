--Proyecto final Bases de Datos: SGBD Hospital
--Script 04: triggers

USE HospitalDB;
GO

--CITA

--Una cita en estatus final (cancelada, atendida o no acudio) ya no puede cambiar de estatus
CREATE TRIGGER TR_CITA_ESTATUS_FINAL
ON CITA
AFTER UPDATE
AS
BEGIN
SET NOCOUNT ON;
IF EXISTS (
SELECT 1
FROM inserted i
JOIN deleted d ON d.folio_cita = i.folio_cita
WHERE d.estatus IN ('Cancelada falta de pago', 'Cancelada paciente', 'Cancelada doctor', 'Atendida', 'No acudio')
AND i.estatus <> d.estatus
)
BEGIN
RAISERROR('La cita ya está en un estatus final y no se puede modificar.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END
END
GO

--Cada vez que se crea una cita o cambia su estatus, se registra en la bitacora de estatus
--Si la cita se cancelo, toma la politica y el monto devuelto de CANCELACION
--(por eso el SP de cancelar debe insertar en CANCELACION antes de cambiar el estatus de la cita)
CREATE TRIGGER TR_CITA_BITACORA_ESTATUS
ON CITA
AFTER INSERT, UPDATE
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO BITACORA_ESTATUS_CITA (folio_cita, estatus_cita, fecha_cita, id_especialidad, costo, politica_cancela, monto_devuelto)
SELECT i.folio_cita,
i.estatus,
i.fecha_cita,
doc.id_especialidad,
i.costo,
CASE
WHEN ca.id_cancelacion IS NULL THEN NULL
WHEN ca.solicitada_por = 'Doctor' THEN 'Cancelacion por doctor: 100%'
WHEN ca.solicitada_por = 'Sistema' THEN 'Falta de pago: 0%'
WHEN ca.porcentaje_devolucion = 100 THEN '48 h o mas: 100%'
WHEN ca.porcentaje_devolucion = 50 THEN 'Entre 24 y 48 h: 50%'
ELSE 'Menos de 24 h: 0%'
END,
ca.monto_devuelto
FROM inserted i
JOIN DOCTOR doc ON doc.num_empleado = i.num_empleado_doctor
LEFT JOIN deleted d ON d.folio_cita = i.folio_cita
LEFT JOIN CANCELACION ca ON ca.folio_cita = i.folio_cita AND ca.estado = 'Aprobada'
--Si es INSERT no hay fila en deleted; si es UPDATE solo cuenta cuando el estatus cambio
WHERE d.folio_cita IS NULL OR d.estatus <> i.estatus;
END
GO

--Cuando una cita pasa a Atendida o No acudio, se registra en la bitacora del historial
--usuario: el login de SQL Server con el que se conecto la aplicacion (uno por perfil, ver script de permisos)
CREATE TRIGGER TR_CITA_BITACORA_HISTORIAL
ON CITA
AFTER UPDATE
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO BITACORA_HISTORIAL_CITA (usuario, maquina_ip, folio_cita, fecha_cita, hora_cita, id_paciente, folio_receta, id_doctor, estatus_consulta, especialidad, consultorio)
SELECT SUSER_SNAME(),
HOST_NAME(),
i.folio_cita,
i.fecha_cita,
i.hora_cita,
i.id_paciente,
r.folio_receta,
i.num_empleado_doctor,
i.estatus,
es.nombre,
co.numero
FROM inserted i
JOIN deleted d ON d.folio_cita = i.folio_cita
JOIN DOCTOR doc ON doc.num_empleado = i.num_empleado_doctor
JOIN ESPECIALIDAD es ON es.id_especialidad = doc.id_especialidad
JOIN CONSULTORIO co ON co.id_consultorio = i.id_consultorio
LEFT JOIN RECETA r ON r.folio_cita = i.folio_cita
WHERE i.estatus IN ('Atendida', 'No acudio')
AND d.estatus <> i.estatus;
END
GO

--PAGO


--Al registrar un pago: valida que la cita este pendiente de pago, que el monto sea el costo
--y que no hayan pasado las 8 horas; si todo esta bien, la cita pasa a Pagada
CREATE TRIGGER TR_PAGO_VALIDAR
ON PAGO
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON;
--La cita debe estar pendiente de pago
IF EXISTS (
SELECT 1 FROM inserted i
JOIN CITA c ON c.folio_cita = i.folio_cita
WHERE c.estatus <> 'Agendada pendiente de pago'
)
BEGIN
RAISERROR('Solo se pueden pagar citas en estatus Agendada pendiente de pago.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END
--El monto debe ser exactamente el costo de la cita
IF EXISTS (
SELECT 1 FROM inserted i
JOIN CITA c ON c.folio_cita = i.folio_cita
WHERE i.monto <> c.costo
)
BEGIN
RAISERROR('El monto del pago debe ser igual al costo de la cita.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END
--Debe pagarse dentro de las 8 horas siguientes a agendar
IF EXISTS (
SELECT 1 FROM inserted i
JOIN CITA c ON c.folio_cita = i.folio_cita
WHERE i.fecha_pago > DATEADD(HOUR, 8, c.fecha_registro)
)
BEGIN
RAISERROR('El tiempo para pagar (8 horas) ya venció.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END
--Todo bien: la cita pasa a Pagada (esto dispara la bitacora de estatus)
UPDATE CITA
SET estatus = 'Pagada pendiente por atender'
WHERE folio_cita IN (SELECT folio_cita FROM inserted);
END
GO


--RECETA

--Al crear una receta: la cita debe estar pagada y el dia de la cita ya debe haber llegado;
--si todo esta bien, la cita pasa a Atendida (esto dispara las dos bitacoras)
CREATE TRIGGER TR_RECETA_ATENDER
ON RECETA
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON;
IF EXISTS (
SELECT 1 FROM inserted i
JOIN CITA c ON c.folio_cita = i.folio_cita
WHERE c.estatus <> 'Pagada pendiente por atender'
)
BEGIN
RAISERROR('Solo se puede recetar en una cita pagada y pendiente por atender.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END
IF EXISTS (
SELECT 1 FROM inserted i
JOIN CITA c ON c.folio_cita = i.folio_cita
WHERE c.fecha_cita > CAST(GETDATE() AS DATE)
)
BEGIN
RAISERROR('No se puede recetar antes del día de la cita.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END
UPDATE CITA
SET estatus = 'Atendida'
WHERE folio_cita IN (SELECT folio_cita FROM inserted);
END
GO

--FARMACIA

--Al vender medicamentos: valida que haya stock suficiente y lo descuenta
CREATE TRIGGER TR_DETALLE_VENTA_STOCK
ON DETALLE_VENTA
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON;
--Compara el stock contra lo que se vende de cada medicamento en este movimiento
IF EXISTS (
SELECT 1
FROM MEDICAMENTO m
JOIN (SELECT id_medicamento, SUM(cantidad) AS vendidos
FROM inserted
WHERE id_medicamento IS NOT NULL
GROUP BY id_medicamento) v ON v.id_medicamento = m.id_medicamento
WHERE m.stock < v.vendidos
)
BEGIN
RAISERROR('No hay stock suficiente del medicamento.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END
--Descuenta el stock
UPDATE m
SET m.stock = m.stock - v.vendidos
FROM MEDICAMENTO m
JOIN (SELECT id_medicamento, SUM(cantidad) AS vendidos
FROM inserted
WHERE id_medicamento IS NOT NULL
GROUP BY id_medicamento) v ON v.id_medicamento = m.id_medicamento;
END
GO

--BITACORAS: solo consulta e insercion

--Impide modificar o borrar la bitacora de estatus
CREATE TRIGGER TR_BITACORA_ESTATUS_PROTEGER
ON BITACORA_ESTATUS_CITA
INSTEAD OF UPDATE, DELETE
AS
BEGIN
RAISERROR('La bitácora de estatus solo permite consulta e inserción.', 16, 1);
END
GO

--Impide modificar o borrar la bitacora del historial
CREATE TRIGGER TR_BITACORA_HISTORIAL_PROTEGER
ON BITACORA_HISTORIAL_CITA
INSTEAD OF UPDATE, DELETE
AS
BEGIN
RAISERROR('La bitácora del historial solo permite consulta e inserción.', 16, 1);
END
GO
