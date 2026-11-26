/* =========================================================
PRUEBAS (ejecutalas una por una)
========================================================= */

--Login correcto e incorrecto
--EXEC sp_Login 'maria.lopez', 'Paciente2026!';
--EXEC sp_Login 'maria.lopez', 'mal';

--Registrar un paciente nuevo
--EXEC sp_RegistrarPaciente 'pedro.ruiz', 'Pedro2026!', 'Pedro', 'Ruiz', 'Gil', 'RUGP000101HDFZLD01', '2000-01-01', 'M', '5512345678', 'pedro.ruiz@gmail.com';

--Agendar: paciente 3 con el doctor 3 (Cardiologia, 07:00-14:00) dentro de 5 dias a las 09:00
--DECLARE @f DATE = DATEADD(DAY, 5, CAST(GETDATE() AS DATE));
--EXEC sp_AgendarCita 3, 3, @f, '09:00';

--Agendar mañana: debe marcar error de 48 horas
--DECLARE @m DATE = DATEADD(DAY, 1, CAST(GETDATE() AS DATE));
--EXEC sp_AgendarCita 3, 4, @m, '15:00';

--Agendar fuera del horario del doctor 3 (sale a las 14:00): debe marcar error
--DECLARE @g DATE = DATEADD(DAY, 6, CAST(GETDATE() AS DATE));
--EXEC sp_AgendarCita 4, 3, @g, '18:00';

--Pagar la cita que se acaba de agendar
--DECLARE @folio INT = (SELECT MAX(folio_cita) FROM CITA);
--EXEC sp_PagarCita @folio, 'Tarjeta';

--Cancelarla como paciente (faltan mas de 48 h: devuelve 100%)
--DECLARE @folio2 INT = (SELECT MAX(folio_cita) FROM CITA);
--EXEC sp_CancelarCitaPaciente @folio2, 3, 'Ya no puedo asistir';

--Solicitud del doctor 40 (Pediatría) sobre su cita 13 y aprobacion de la recepcionista (empleado 1)
--EXEC sp_SolicitarCancelacionDoctor 13, 40, 'Congreso';
--SELECT * FROM V_SOLICITUDES_CANCELACION WHERE estado = 'Pendiente';
--EXEC sp_ResolverCancelacion <id_cancelacion>, 1, 1;

--Venta de 2 Paracetamol y una inyeccion
--EXEC sp_CrearVenta 2, NULL, 'Cliente mostrador', 'Efectivo';
--EXEC sp_AgregarMedicamentoVenta <id_venta>, 1, 2;
--EXEC sp_AgregarServicioVenta <id_venta>, 1, 1;
--SELECT * FROM V_TICKET_TOTAL WHERE id_venta = <id_venta>;
