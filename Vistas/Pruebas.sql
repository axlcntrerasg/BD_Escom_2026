/* =========================================================
PRUEBAS RAPIDAS
========================================================= */
SELECT * FROM V_CITAS_PACIENTE WHERE id_paciente = 1 ORDER BY fecha_cita DESC;
SELECT * FROM V_COMPROBANTE_CITA WHERE folio_cita = 15;
SELECT * FROM V_CITAS_DOCTOR WHERE num_empleado_doctor = 3;
SELECT * FROM V_RECETA WHERE folio_receta = 1;
SELECT * FROM V_RECETA_MEDICAMENTOS WHERE folio_receta = 1;
SELECT * FROM V_SOLICITUDES_CANCELACION;
SELECT * FROM V_ESPECIALIDADES;
SELECT * FROM V_TICKET_TOTAL;
GO
