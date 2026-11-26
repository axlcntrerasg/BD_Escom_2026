USE HospitalDB

--Usuario y Contraseña de los diferentes roles

--Administrador
--Usuario: admin
--Contraseña: Admin2026!

--Recepcionista
--Usuario: mariana.ortega 
--Contraseña: Recep2026!

--Doctor
--Usuario: dr.garcia
--Contraseña: Doctor2026!

--Doctora
--Usuario: dr.carrillo
--Contraseña: Doctor2026!

--Farmaceutico
--Usuario: patricia.cervantes
--Contraseña: Farma2026!

--Paciente
--Usuario: maria.lopez
--Contraseña: Paciente2026!

--Conocer todos los usuarios (Pacientes)
SELECT PACIENTE.id_paciente, USUARIO.username, PACIENTE.nombre, PACIENTE.ap_paterno, PACIENTE.curp, PACIENTE.correo, USUARIO.fecha_alta
FROM PACIENTE
JOIN USUARIO ON USUARIO.id_usuario = PACIENTE.id_usuario
ORDER BY USUARIO.fecha_alta DESC;

----Cuantos Usuario hay en cada rol
SELECT rol, COUNT(*)
FROM USUARIO
GROUP BY rol;

--Datos de un paciente por su usuario
SELECT PACIENTE.*, USUARIO.username, USUARIO.fecha_alta
FROM PACIENTE
JOIN USUARIO ON USUARIO.id_usuario = PACIENTE.id_usuario
WHERE USUARIO.username = 'maria.lopez';

--Doctores por especialidad,consultorio y horario
SELECT DOCTOR.num_empleado, EMPLEADO.nombre, EMPLEADO.ap_paterno, ESPECIALIDAD.nombre, CONSULTORIO.numero, DOCTOR.hora_entrada, DOCTOR.hora_salida
FROM DOCTOR
JOIN EMPLEADO ON EMPLEADO.num_empleado = DOCTOR.num_empleado
JOIN ESPECIALIDAD ON ESPECIALIDAD.id_especialidad = DOCTOR.id_especialidad
JOIN CONSULTORIO ON CONSULTORIO.id_consultorio = DOCTOR.id_consultorio
ORDER BY ESPECIALIDAD.nombre, EMPLEADO.ap_paterno; 

--Cuantos doctores hay por especialidad
SELECT ESPECIALIDAD.nombre, COUNT(DOCTOR.num_empleado)
FROM ESPECIALIDAD
LEFT JOIN DOCTOR ON DOCTOR.id_especialidad = ESPECIALIDAD.id_especialidad
GROUP BY ESPECIALIDAD.nombre;

--Doctores de una especialidad  
SELECT EMPLEADO.nombre, EMPLEADO.ap_paterno, DOCTOR.cedula_profesional, DOCTOR.hora_entrada, DOCTOR.hora_salida
FROM DOCTOR
JOIN EMPLEADO ON EMPLEADO.num_empleado = DOCTOR.num_empleado
JOIN ESPECIALIDAD ON ESPECIALIDAD.id_especialidad = DOCTOR.id_especialidad
WHERE ESPECIALIDAD.nombre = 'Cardiología';

--Que doctores comparten consultorio
SELECT CONSULTORIO.numero, EMPLEADO.nombre, EMPLEADO.ap_paterno, DOCTOR.hora_entrada, DOCTOR.hora_salida
FROM CONSULTORIO
JOIN DOCTOR ON DOCTOR.id_consultorio = CONSULTORIO.id_consultorio
JOIN EMPLEADO ON EMPLEADO.num_empleado = DOCTOR.num_empleado
ORDER BY CONSULTORIO.numero, DOCTOR.hora_entrada;

--Que doctores comparten consultorio (solo Cardiologia)
SELECT CONSULTORIO.numero, EMPLEADO.nombre, EMPLEADO.ap_paterno, DOCTOR.hora_entrada, DOCTOR.hora_salida
FROM CONSULTORIO
JOIN DOCTOR ON DOCTOR.id_consultorio = CONSULTORIO.id_consultorio
JOIN EMPLEADO ON EMPLEADO.num_empleado = DOCTOR.num_empleado
JOIN ESPECIALIDAD ON ESPECIALIDAD.id_especialidad = DOCTOR.id_especialidad
WHERE ESPECIALIDAD.nombre = 'Cardiología'
ORDER BY CONSULTORIO.numero, DOCTOR.hora_entrada;

--Todas las citas de un paciente (por usuario)
SELECT CITA.folio_cita, CITA.fecha_cita, CITA.hora_cita, ESPECIALIDAD.nombre, EMPLEADO.nombre, EMPLEADO.ap_paterno, CITA.costo, CITA.estatus
FROM CITA
JOIN PACIENTE ON PACIENTE.id_paciente = CITA.id_paciente
JOIN USUARIO ON USUARIO.id_usuario = PACIENTE.id_usuario
JOIN DOCTOR ON DOCTOR.num_empleado = CITA.num_empleado_doctor
JOIN EMPLEADO ON EMPLEADO.num_empleado = DOCTOR.num_empleado
JOIN ESPECIALIDAD ON ESPECIALIDAD.id_especialidad = DOCTOR.id_especialidad
WHERE USUARIO.username = 'maria.lopez'
ORDER BY CITA.fecha_cita DESC;

--Cuantas citas hay en cada estatus
SELECT estatus, COUNT(*)
FROM CITA
GROUP BY estatus;

--Todo sobre una cita: paciente, doctor, especialidad y consultorio (Folio 27)
SELECT CITA.folio_cita, CITA.fecha_cita, CITA.hora_cita, PACIENTE.nombre, PACIENTE.ap_paterno, EMPLEADO.nombre, 
EMPLEADO.ap_paterno, ESPECIALIDAD.nombre, CONSULTORIO.numero, CITA.costo, CITA.linea_pago, CITA.estatus
FROM CITA
JOIN PACIENTE ON PACIENTE.id_paciente = CITA.id_paciente
JOIN DOCTOR ON DOCTOR.num_empleado = CITA.num_empleado_doctor
JOIN EMPLEADO ON EMPLEADO.num_empleado = DOCTOR.num_empleado
JOIN ESPECIALIDAD ON ESPECIALIDAD.id_especialidad = DOCTOR.id_especialidad
JOIN CONSULTORIO ON CONSULTORIO.id_consultorio = CITA.id_consultorio
WHERE CITA.folio_cita = 27;

--Cuantas citas hay en cada estatus?
SELECT estatus, COUNT(*)
FROM CITA
GROUP BY estatus;

--Citas pendientes de pago y hasta cuando pueden pagarse (8 horas despues de agendar)
SELECT folio_cita, id_paciente, fecha_registro, DATEADD(HOUR, 8, fecha_registro), costo
FROM CITA
WHERE estatus = 'Agendada pendiente de pago';

--Que paciente tiene mas citas
SELECT PACIENTE.nombre, PACIENTE.ap_paterno, COUNT(CITA.folio_cita)
FROM PACIENTE
JOIN CITA ON CITA.id_paciente = PACIENTE.id_paciente
GROUP BY PACIENTE.nombre, PACIENTE.ap_paterno
ORDER BY COUNT(CITA.folio_cita) DESC;

--Cuanto dinero ha entrado por citas, por metodo de pago
SELECT metodo_pago, SUM(monto)
FROM PAGO
GROUP BY metodo_pago;

--Historial medico de un paciente
SELECT PACIENTE.nombre, PACIENTE.ap_paterno, HISTORIAL_MEDICO.tipo_sangre, HISTORIAL_MEDICO.alergias, 
HISTORIAL_MEDICO.padecimientos_previos, HISTORIAL_MEDICO.peso, HISTORIAL_MEDICO.estatura
FROM HISTORIAL_MEDICO
JOIN PACIENTE ON PACIENTE.id_paciente = HISTORIAL_MEDICO.id_paciente
WHERE PACIENTE.id_paciente = 1;

--Receta de una cita con sus medicamentos
SELECT RECETA.folio_receta, RECETA.fecha, RECETA.diagnostico, RECETA.tratamiento, MEDICAMENTO.nombre, MEDICAMENTO.presentacion, RECETA_MEDICAMENTO.dosis
FROM RECETA
JOIN RECETA_MEDICAMENTO ON RECETA_MEDICAMENTO.folio_receta = RECETA.folio_receta
JOIN MEDICAMENTO ON MEDICAMENTO.id_medicamento = RECETA_MEDICAMENTO.id_medicamento
WHERE RECETA.folio_cita = 1;

--Medicamentos con poco stock (menos de 50 piezas)
SELECT id_medicamento, nombre, presentacion, stock
FROM MEDICAMENTO
WHERE stock < 50
ORDER BY stock;

--Cuanto se ha vendido en total en farmacia y servicios
SELECT SUM(cantidad * precio_unitario)
FROM DETALLE_VENTA;

--Tablas de la base
SELECT name FROM sys.tables ORDER BY name;

--Vistas
SELECT name FROM sys.views ORDER BY name;

--Demostrar que la recepcionista NO puede ver recetas (debe marcar error de permisos)
EXECUTE AS USER = 'usr_recepcionista';
SELECT * FROM V_RECETA;
REVERT;
GO
