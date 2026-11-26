/* =========================================================
PRUEBAS (ejecutalas una por una y revisa el resultado)
========================================================= */

--1. Crear una cita y pagarla: debe pasar a Pagada y aparecer dos veces en la bitacora
--(paciente 3 con el doctor 3 de Cardiología, costo 900, dentro de 10 dias a las 08:00)
--INSERT INTO CITA (id_paciente, num_empleado_doctor, id_consultorio, fecha_cita, hora_cita, costo, linea_pago)
--VALUES (3, 3, 1, DATEADD(DAY, 10, CAST(GETDATE() AS DATE)), '08:00', 900, 'LPPRUEBA0000000001');
--INSERT INTO PAGO (folio_cita, monto, metodo_pago) VALUES ((SELECT MAX(folio_cita) FROM CITA), 900, 'Tarjeta');
--SELECT folio_cita, estatus FROM CITA WHERE linea_pago = 'LPPRUEBA0000000001';
--SELECT * FROM BITACORA_ESTATUS_CITA WHERE folio_cita = (SELECT MAX(folio_cita) FROM CITA);

--2. Pagar con un monto incorrecto: debe marcar error
--INSERT INTO PAGO (folio_cita, monto, metodo_pago) VALUES (16, 100, 'Efectivo');

--3. Cambiar el estatus de una cita atendida: debe marcar error
--UPDATE CITA SET estatus = 'Cancelada paciente' WHERE folio_cita = 1;

--4. Vender mas medicamento del que hay (Tamoxifeno, id 15, stock 30): debe marcar error
--INSERT INTO VENTA (num_empleado, nombre_cliente, metodo_pago) VALUES (2, 'Cliente prueba', 'Efectivo');
--INSERT INTO DETALLE_VENTA (id_venta, id_medicamento, cantidad, precio_unitario) VALUES (11, 15, 100, 450);

--5. Vender 2 Paracetamol (id 1): el stock debe bajar en 2
--INSERT INTO DETALLE_VENTA (id_venta, id_medicamento, cantidad, precio_unitario) VALUES (11, 1, 2, 45);
--SELECT nombre, stock FROM MEDICAMENTO WHERE id_medicamento = 1;

--6. Borrar la bitacora: debe marcar error
--DELETE FROM BITACORA_ESTATUS_CITA;
