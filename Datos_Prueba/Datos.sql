--Proyecto final Bases de Datos: SGBD Hospital
--Script 02: datos de prueba
--Ejecutar justo despues del script 01, sobre la base recien creada
--(los id se asignan en orden con IDENTITY, por eso la base debe estar vacia)

USE HospitalDB;
GO

--Consultorios: 20 (cada uno lo comparten 2 doctores, uno de turno matutino y otro vespertino)
INSERT INTO CONSULTORIO (numero, piso) VALUES
('C-101', 1),
('C-102', 1),
('C-103', 1),
('C-104', 1),
('C-105', 1),
('C-106', 1),
('C-107', 1),
('C-108', 1),
('C-109', 1),
('C-110', 1),
('C-201', 2),
('C-202', 2),
('C-203', 2),
('C-204', 2),
('C-205', 2),
('C-206', 2),
('C-207', 2),
('C-208', 2),
('C-209', 2),
('C-210', 2);
GO

--Servicios extras: se agregan 6 a los 4 del script 01 (total 10)
INSERT INTO SERVICIO (nombre, precio) VALUES
('Electrocardiograma', 450),
('Rayos X', 600),
('Nebulización', 120),
('Sutura', 400),
('Retiro de puntos', 150),
('Ultrasonido', 900);
GO

--Medicamentos: 15
INSERT INTO MEDICAMENTO (nombre, presentacion, precio, stock) VALUES
('Paracetamol', 'Tabletas 500 mg', 45, 120),
('Ibuprofeno', 'Tabletas 400 mg', 60, 100),
('Amoxicilina', 'Cápsulas 500 mg', 120, 80),
('Omeprazol', 'Cápsulas 20 mg', 85, 90),
('Loratadina', 'Tabletas 10 mg', 55, 70),
('Metformina', 'Tabletas 850 mg', 70, 110),
('Losartán', 'Tabletas 50 mg', 95, 75),
('Atorvastatina', 'Tabletas 20 mg', 180, 60),
('Salbutamol', 'Inhalador 100 mcg', 210, 40),
('Ácido fólico', 'Tabletas 5 mg', 40, 150),
('Diclofenaco', 'Gel 1%', 110, 50),
('Clotrimazol', 'Crema 1%', 75, 45),
('Ambroxol', 'Jarabe 30 mg/5 ml', 90, 65),
('Naproxeno', 'Tabletas 250 mg', 65, 85),
('Tamoxifeno', 'Tabletas 20 mg', 450, 30);
GO

--Usuarios: 1 recepcionista, 1 farmaceutico, 40 doctores y 12 pacientes (pueden ser los que quieras)
--(el admin ya es el id_usuario 1; recepcionista 2, farmaceutico 3, doctores 4-43, pacientes 44-55)
INSERT INTO USUARIO (username, contrasena, rol) VALUES
('mariana.ortega', 'Recep2026!', 'Recepcionista'),
('patricia.cervantes', 'Farma2026!', 'Farmaceutico'),
('dr.garcia', 'Doctor2026!', 'Doctor'),
('dr.molina', 'Doctor2026!', 'Doctor'),
('dr.dominguez', 'Doctor2026!', 'Doctor'),
('dr.castillo', 'Doctor2026!', 'Doctor'),
('dr.navarro', 'Doctor2026!', 'Doctor'),
('dr.ibarra', 'Doctor2026!', 'Doctor'),
('dr.medina', 'Doctor2026!', 'Doctor'),
('dr.guerrero', 'Doctor2026!', 'Doctor'),
('dr.vazquez', 'Doctor2026!', 'Doctor'),
('dr.paredes', 'Doctor2026!', 'Doctor'),
('dr.montes', 'Doctor2026!', 'Doctor'),
('dr.herrera', 'Doctor2026!', 'Doctor'),
('dr.pacheco', 'Doctor2026!', 'Doctor'),
('dr.cabrera', 'Doctor2026!', 'Doctor'),
('dr.zamora', 'Doctor2026!', 'Doctor'),
('dr.estrada', 'Doctor2026!', 'Doctor'),
('dr.salazar', 'Doctor2026!', 'Doctor'),
('dr.ponce', 'Doctor2026!', 'Doctor'),
('dr.acosta', 'Doctor2026!', 'Doctor'),
('dr.robles', 'Doctor2026!', 'Doctor'),
('dr.barrera', 'Doctor2026!', 'Doctor'),
('dr.figueroa', 'Doctor2026!', 'Doctor'),
('dr.villalobos', 'Doctor2026!', 'Doctor'),
('dr.benitez', 'Doctor2026!', 'Doctor'),
('dr.lozano', 'Doctor2026!', 'Doctor'),
('dr.carrillo', 'Doctor2026!', 'Doctor'),
('dr.orozco', 'Doctor2026!', 'Doctor'),
('dr.valencia', 'Doctor2026!', 'Doctor'),
('dr.esquivel', 'Doctor2026!', 'Doctor'),
('dr.maldonado', 'Doctor2026!', 'Doctor'),
('dr.serrano', 'Doctor2026!', 'Doctor'),
('dr.cuevas', 'Doctor2026!', 'Doctor'),
('dr.rivas', 'Doctor2026!', 'Doctor'),
('dr.bautista', 'Doctor2026!', 'Doctor'),
('dr.aguirre', 'Doctor2026!', 'Doctor'),
('dr.munoz', 'Doctor2026!', 'Doctor'),
('dr.delgado', 'Doctor2026!', 'Doctor'),
('dr.santana', 'Doctor2026!', 'Doctor'),
('dr.peralta', 'Doctor2026!', 'Doctor'),
('dr.arellano', 'Doctor2026!', 'Doctor'),
('maria.lopez', 'Paciente2026!', 'Paciente'),
('jose.martinez', 'Paciente2026!', 'Paciente'),
('ana.hernandez', 'Paciente2026!', 'Paciente'),
('carlos.ramirez', 'Paciente2026!', 'Paciente'),
('laura.torres', 'Paciente2026!', 'Paciente'),
('miguel.flores', 'Paciente2026!', 'Paciente'),
('valeria.gonzalez', 'Paciente2026!', 'Paciente'),
('jorge.sanchez', 'Paciente2026!', 'Paciente'),
('daniela.cruz', 'Paciente2026!', 'Paciente'),
('fernando.jimenez', 'Paciente2026!', 'Paciente'),
('sofia.mendoza', 'Paciente2026!', 'Paciente'),
('diego.vargas', 'Paciente2026!', 'Paciente');
GO

--Empleados: num_empleado 1 recepcionista, 2 farmaceutico, 3-42 doctores
INSERT INTO EMPLEADO (id_usuario, nombre, ap_paterno, ap_materno, curp, telefono, correo, fecha_ingreso) VALUES
(2, 'Mariana', 'Ortega', 'Silva', 'OESM920314MDFRLR00', '5512340000', 'mariana.ortega@hospital.mx', '2023-01-16'),
(3, 'Patricia', 'Cervantes', 'Lara', 'CELP870930MDFRRT00', '5512340017', 'patricia.cervantes@hospital.mx', '2023-01-16'),
(4, 'Alejandro', 'García', 'Ruiz', 'GARA650101HDFRZL00', '5512340034', 'dr.garcia@hospital.mx', '2015-01-01'),
(5, 'Beatriz', 'Molina', 'Aguilar', 'MOAB720204MDFLGT00', '5512340051', 'dr.molina@hospital.mx', '2016-02-01'),
(6, 'Raúl', 'Domínguez', 'Peña', 'DOPR790307HDFMNL00', '5512340068', 'dr.dominguez@hospital.mx', '2017-03-01'),
(7, 'Gabriela', 'Castillo', 'Rojas', 'CARG860410MDFSJB00', '5512340085', 'dr.castillo@hospital.mx', '2018-04-01'),
(8, 'Andrés', 'Navarro', 'León', 'NALA680513HDFVNN00', '5512340102', 'dr.navarro@hospital.mx', '2019-05-01'),
(9, 'Lucía', 'Ibarra', 'Fuentes', 'IAFL750616MDFBNC00', '5512340119', 'dr.ibarra@hospital.mx', '2020-06-01'),
(10, 'Sergio', 'Medina', 'Campos', 'MECS820719HDFDMR00', '5512340136', 'dr.medina@hospital.mx', '2021-07-01'),
(11, 'Paola', 'Guerrero', 'Ríos', 'GURP890822MDFRSL00', '5512340153', 'dr.guerrero@hospital.mx', '2022-08-01'),
(12, 'Elena', 'Vázquez', 'Cordero', 'VACE710925MDFZRL00', '5512340170', 'dr.vazquez@hospital.mx', '2023-09-01'),
(13, 'Mónica', 'Paredes', 'Solís', 'PASM781001MDFRLN00', '5512340187', 'dr.paredes@hospital.mx', '2015-01-01'),
(14, 'Isabel', 'Montes', 'Galindo', 'MOGI851104MDFNLS00', '5512340204', 'dr.montes@hospital.mx', '2016-02-01'),
(15, 'Adriana', 'Herrera', 'Tapia', 'HETA671207MDFRPD00', '5512340221', 'dr.herrera@hospital.mx', '2017-03-01'),
(16, 'Roberto', 'Pacheco', 'Ávila', 'PAAR740110HDFCVB00', '5512340238', 'dr.pacheco@hospital.mx', '2018-04-01'),
(17, 'Luis', 'Cabrera', 'Nava', 'CANL810213HDFBVS00', '5512340255', 'dr.cabrera@hospital.mx', '2019-05-01'),
(18, 'Verónica', 'Zamora', 'Quintero', 'ZAQV880316MDFMNR00', '5512340272', 'dr.zamora@hospital.mx', '2020-06-01'),
(19, 'Arturo', 'Estrada', 'Mejía', 'EAMA700419HDFSJR00', '5512340289', 'dr.estrada@hospital.mx', '2021-07-01'),
(20, 'Fernanda', 'Salazar', 'Cano', 'SACF770522MDFLNR00', '5512340306', 'dr.salazar@hospital.mx', '2022-08-01'),
(21, 'Javier', 'Ponce', 'Arias', 'POAJ840625HDFNRV00', '5512340323', 'dr.ponce@hospital.mx', '2023-09-01'),
(22, 'Rocío', 'Acosta', 'Miranda', 'AOMR660701MDFCRC00', '5512340340', 'dr.acosta@hospital.mx', '2015-01-01'),
(23, 'Manuel', 'Robles', 'Sandoval', 'ROSM730804HDFBNN00', '5512340357', 'dr.robles@hospital.mx', '2016-02-01'),
(24, 'Silvia', 'Barrera', 'Juárez', 'BAJS800907MDFRRL00', '5512340374', 'dr.barrera@hospital.mx', '2017-03-01'),
(25, 'Tomás', 'Figueroa', 'Duarte', 'FIDT871010HDFGRM00', '5512340391', 'dr.figueroa@hospital.mx', '2018-04-01'),
(26, 'Carmen', 'Villalobos', 'Rangel', 'VIRC691113MDFLNR00', '5512340408', 'dr.villalobos@hospital.mx', '2019-05-01'),
(27, 'Óscar', 'Benítez', 'Trejo', 'BETO761216HDFNRS00', '5512340425', 'dr.benitez@hospital.mx', '2020-06-01'),
(28, 'Diana', 'Lozano', 'Espinoza', 'LOED830119MDFZSN00', '5512340442', 'dr.lozano@hospital.mx', '2021-07-01'),
(29, 'Pablo', 'Carrillo', 'Becerra', 'CABP650222HDFRCB00', '5512340459', 'dr.carrillo@hospital.mx', '2022-08-01'),
(30, 'Natalia', 'Orozco', 'Gallegos', 'OOGN720325MDFRLT00', '5512340476', 'dr.orozco@hospital.mx', '2023-09-01'),
(31, 'Hugo', 'Valencia', 'Mora', 'VAMH790401HDFLRG00', '5512340493', 'dr.valencia@hospital.mx', '2015-01-01'),
(32, 'Teresa', 'Esquivel', 'Pérez', 'EUPT860504MDFSRR00', '5512340510', 'dr.esquivel@hospital.mx', '2016-02-01'),
(33, 'Ernesto', 'Maldonado', 'Cortés', 'MACE680607HDFLRR00', '5512340527', 'dr.maldonado@hospital.mx', '2017-03-01'),
(34, 'Alicia', 'Serrano', 'Villa', 'SEVA750710MDFRLL00', '5512340544', 'dr.serrano@hospital.mx', '2018-04-01'),
(35, 'Rodrigo', 'Cuevas', 'Montoya', 'CUMR820813HDFVND00', '5512340561', 'dr.cuevas@hospital.mx', '2019-05-01'),
(36, 'Guillermo', 'Rivas', 'Treviño', 'RITG890916HDFVRL00', '5512340578', 'dr.rivas@hospital.mx', '2020-06-01'),
(37, 'Leticia', 'Bautista', 'Ochoa', 'BAOL711019MDFTCT00', '5512340595', 'dr.bautista@hospital.mx', '2021-07-01'),
(38, 'Francisco', 'Aguirre', 'Valdez', 'AUVF781122HDFGLR00', '5512340612', 'dr.aguirre@hospital.mx', '2022-08-01'),
(39, 'Irene', 'Muñoz', 'Carmona', 'MUCI851225MDFNRR00', '5512340629', 'dr.munoz@hospital.mx', '2023-09-01'),
(40, 'Mauricio', 'Delgado', 'Robledo', 'DERM670101HDFLBR00', '5512340646', 'dr.delgado@hospital.mx', '2015-01-01'),
(41, 'Karina', 'Santana', 'Vera', 'SAVK740204MDFNRR00', '5512340663', 'dr.santana@hospital.mx', '2016-02-01'),
(42, 'Eduardo', 'Peralta', 'Guzmán', 'PEGE810307HDFRZD00', '5512340680', 'dr.peralta@hospital.mx', '2017-03-01'),
(43, 'Lorena', 'Arellano', 'Quiroz', 'AEQL880410MDFRRR00', '5512340697', 'dr.arellano@hospital.mx', '2018-04-01');
GO

--Doctores: 4 por especialidad (id_especialidad 1-10 en el orden del script 01)
--Turno matutino 07:00-14:00 y vespertino 14:00-21:00; cada consultorio lo comparten dos doctores
INSERT INTO DOCTOR (num_empleado, cedula_profesional, id_especialidad, id_consultorio, hora_entrada, hora_salida) VALUES
--Cardiología
(3, '10258324', 1, 1, '07:00', '14:00'),
(4, '10266243', 1, 1, '14:00', '21:00'),
(5, '10274162', 1, 2, '07:00', '14:00'),
(6, '10282081', 1, 2, '14:00', '21:00'),
--Dermatología
(7, '10290000', 2, 3, '07:00', '14:00'),
(8, '10297919', 2, 3, '14:00', '21:00'),
(9, '10305838', 2, 4, '07:00', '14:00'),
(10, '10313757', 2, 4, '14:00', '21:00'),
--Ginecología
(11, '10321676', 3, 5, '07:00', '14:00'),
(12, '10329595', 3, 5, '14:00', '21:00'),
(13, '10337514', 3, 6, '07:00', '14:00'),
(14, '10345433', 3, 6, '14:00', '21:00'),
--Medicina General
(15, '10353352', 4, 7, '07:00', '14:00'),
(16, '10361271', 4, 7, '14:00', '21:00'),
(17, '10369190', 4, 8, '07:00', '14:00'),
(18, '10377109', 4, 8, '14:00', '21:00'),
--Nefrología
(19, '10385028', 5, 9, '07:00', '14:00'),
(20, '10392947', 5, 9, '14:00', '21:00'),
(21, '10400866', 5, 10, '07:00', '14:00'),
(22, '10408785', 5, 10, '14:00', '21:00'),
--Nutriología
(23, '10416704', 6, 11, '07:00', '14:00'),
(24, '10424623', 6, 11, '14:00', '21:00'),
(25, '10432542', 6, 12, '07:00', '14:00'),
(26, '10440461', 6, 12, '14:00', '21:00'),
--Oftalmología
(27, '10448380', 7, 13, '07:00', '14:00'),
(28, '10456299', 7, 13, '14:00', '21:00'),
(29, '10464218', 7, 14, '07:00', '14:00'),
(30, '10472137', 7, 14, '14:00', '21:00'),
--Oncología
(31, '10480056', 8, 15, '07:00', '14:00'),
(32, '10487975', 8, 15, '14:00', '21:00'),
(33, '10495894', 8, 16, '07:00', '14:00'),
(34, '10503813', 8, 16, '14:00', '21:00'),
--Ortopedia
(35, '10511732', 9, 17, '07:00', '14:00'),
(36, '10519651', 9, 17, '14:00', '21:00'),
(37, '10527570', 9, 18, '07:00', '14:00'),
(38, '10535489', 9, 18, '14:00', '21:00'),
--Pediatría
(39, '10543408', 10, 19, '07:00', '14:00'),
(40, '10551327', 10, 19, '14:00', '21:00'),
(41, '10559246', 10, 20, '07:00', '14:00'),
(42, '10567165', 10, 20, '14:00', '21:00');
GO

--Pacientes: 12 (id_usuario 44-55); los dos ultimos son menores de edad para Pediatría
INSERT INTO PACIENTE (id_usuario, nombre, ap_paterno, ap_materno, curp, fecha_nacimiento, sexo, telefono, correo) VALUES
(44, 'María Fernanda', 'López', 'Ruiz', 'LORM900412MDFPZR00', '1990-04-12', 'F', '5598760000', 'maria.lopez@gmail.com'),
(45, 'José Luis', 'Martínez', 'Gómez', 'MAGJ850823HDFRMS00', '1985-08-23', 'M', '5598760131', 'jose.martinez@gmail.com'),
(46, 'Ana Sofía', 'Hernández', 'Castro', 'HECA980130MDFRSN00', '1998-01-30', 'F', '5598760262', 'ana.hernandez@gmail.com'),
(47, 'Carlos Alberto', 'Ramírez', 'Soto', 'RASC750617HDFMTR00', '1975-06-17', 'M', '5598760393', 'carlos.ramirez@gmail.com'),
(48, 'Laura Patricia', 'Torres', 'Vega', 'TOVL821205MDFRGR00', '1982-12-05', 'F', '5598760524', 'laura.torres@gmail.com'),
(49, 'Miguel Ángel', 'Flores', 'Díaz', 'FODM930911HDFLZG00', '1993-09-11', 'M', '5598760655', 'miguel.flores@gmail.com'),
(50, 'Valeria', 'González', 'Morales', 'GOMV010227MDFNRL00', '2001-02-27', 'F', '5598760786', 'valeria.gonzalez@gmail.com'),
(51, 'Jorge Eduardo', 'Sánchez', 'Ortiz', 'SAOJ681019HDFNRR00', '1968-10-19', 'M', '5598760917', 'jorge.sanchez@gmail.com'),
(52, 'Daniela', 'Cruz', 'Reyes', 'CURD950508MDFRYN00', '1995-05-08', 'F', '5598761048', 'daniela.cruz@gmail.com'),
(53, 'Fernando', 'Jiménez', 'Navarro', 'JINF790322HDFMVR00', '1979-03-22', 'M', '5598761179', 'fernando.jimenez@gmail.com'),
(54, 'Sofía', 'Mendoza', 'Ríos', 'MERS160714MDFNSF00', '2016-07-14', 'F', '5598761310', 'sofia.mendoza@gmail.com'),
(55, 'Diego', 'Vargas', 'Luna', 'VALD191103HDFRNG00', '2019-11-03', 'M', '5598761441', 'diego.vargas@gmail.com');
GO

--Historial medico: uno por paciente
INSERT INTO HISTORIAL_MEDICO (id_paciente, tipo_sangre, alergias, padecimientos_previos, peso, estatura) VALUES
(1, 'O+', 'Penicilina', 'Ninguno', 62.5, 1.63),
(2, 'A+', NULL, 'Hipertensión', 81.0, 1.75),
(3, 'B+', 'Polen', 'Asma leve', 55.2, 1.6),
(4, 'O-', 'Sulfas', 'Diabetes tipo 2', 90.3, 1.72),
(5, 'A-', NULL, 'Hipotiroidismo', 68.0, 1.58),
(6, 'AB+', 'Mariscos', NULL, 77.4, 1.8),
(7, 'O+', NULL, 'Miopía', 58.9, 1.65),
(8, 'B-', 'Ácido acetilsalicílico', 'Cáncer de próstata en tratamiento', 84.1, 1.7),
(9, 'A+', 'Látex', NULL, 60.0, 1.62),
(10, 'O+', NULL, 'Colesterol alto', 88.7, 1.78),
(11, 'A+', 'Huevo', NULL, 28.5, 1.28),
(12, 'O+', NULL, 'Bronquitis recurrente', 16.2, 1.02);
GO

--Citas: 25 con todos los estatus
--Las fechas se calculan desde hoy para que los datos sigan siendo validos cuando los pruebes
--folio 1-10 Atendida, 11 No acudio, 12-14 Pagada, 15-16 Agendada, 17-20 Cancelada paciente,
--21-23 Cancelada doctor, 24-25 Cancelada falta de pago
INSERT INTO CITA (id_paciente, num_empleado_doctor, id_consultorio, fecha_cita, hora_cita, fecha_registro, costo, linea_pago, estatus) VALUES
(1, 3, 1, DATEADD(DAY, -30, CAST(GETDATE() AS DATE)), '09:00', DATEADD(DAY, -35, GETDATE()), 900, 'LP202600000000000001', 'Atendida'),
(2, 8, 3, DATEADD(DAY, -28, CAST(GETDATE() AS DATE)), '16:00', DATEADD(DAY, -33, GETDATE()), 750, 'LP202600000000000002', 'Atendida'),
(3, 11, 5, DATEADD(DAY, -25, CAST(GETDATE() AS DATE)), '10:00', DATEADD(DAY, -30, GETDATE()), 800, 'LP202600000000000003', 'Atendida'),
(4, 17, 8, DATEADD(DAY, -22, CAST(GETDATE() AS DATE)), '11:30', DATEADD(DAY, -27, GETDATE()), 400, 'LP202600000000000004', 'Atendida'),
(5, 20, 9, DATEADD(DAY, -20, CAST(GETDATE() AS DATE)), '15:00', DATEADD(DAY, -24, GETDATE()), 950, 'LP202600000000000005', 'Atendida'),
(6, 23, 11, DATEADD(DAY, -18, CAST(GETDATE() AS DATE)), '09:30', DATEADD(DAY, -22, GETDATE()), 600, 'LP202600000000000006', 'Atendida'),
(7, 30, 14, DATEADD(DAY, -15, CAST(GETDATE() AS DATE)), '17:00', DATEADD(DAY, -20, GETDATE()), 800, 'LP202600000000000007', 'Atendida'),
(8, 31, 15, DATEADD(DAY, -12, CAST(GETDATE() AS DATE)), '08:00', DATEADD(DAY, -16, GETDATE()), 1200, 'LP202600000000000008', 'Atendida'),
(11, 39, 19, DATEADD(DAY, -10, CAST(GETDATE() AS DATE)), '10:30', DATEADD(DAY, -14, GETDATE()), 650, 'LP202600000000000009', 'Atendida'),
(9, 36, 17, DATEADD(DAY, -8, CAST(GETDATE() AS DATE)), '18:30', DATEADD(DAY, -12, GETDATE()), 850, 'LP202600000000000010', 'Atendida'),
(10, 15, 7, DATEADD(DAY, -6, CAST(GETDATE() AS DATE)), '12:00', DATEADD(DAY, -10, GETDATE()), 400, 'LP202600000000000011', 'No acudio'),
(1, 7, 3, DATEADD(DAY, 5, CAST(GETDATE() AS DATE)), '09:00', DATEADD(DAY, -2, GETDATE()), 750, 'LP202600000000000012', 'Pagada pendiente por atender'),
(12, 40, 19, DATEADD(DAY, 7, CAST(GETDATE() AS DATE)), '16:30', DATEADD(DAY, -3, GETDATE()), 650, 'LP202600000000000013', 'Pagada pendiente por atender'),
(4, 4, 1, DATEADD(DAY, 10, CAST(GETDATE() AS DATE)), '15:30', DATEADD(DAY, -1, GETDATE()), 900, 'LP202600000000000014', 'Pagada pendiente por atender'),
(2, 27, 13, DATEADD(DAY, 4, CAST(GETDATE() AS DATE)), '10:00', DATEADD(HOUR, -2, GETDATE()), 800, 'LP202600000000000015', 'Agendada pendiente de pago'),
(5, 12, 5, DATEADD(DAY, 12, CAST(GETDATE() AS DATE)), '17:00', DATEADD(HOUR, -1, GETDATE()), 800, 'LP202600000000000016', 'Agendada pendiente de pago'),
(6, 35, 17, DATEADD(DAY, 15, CAST(GETDATE() AS DATE)), '11:00', DATEADD(DAY, -4, GETDATE()), 850, 'LP202600000000000017', 'Cancelada paciente'),
(7, 24, 11, DATEADD(DAY, -3, CAST(GETDATE() AS DATE)), '14:30', DATEADD(DAY, -10, GETDATE()), 600, 'LP202600000000000018', 'Cancelada paciente'),
(8, 5, 2, DATEADD(DAY, -4, CAST(GETDATE() AS DATE)), '10:00', DATEADD(DAY, -12, GETDATE()), 900, 'LP202600000000000019', 'Cancelada paciente'),
(9, 16, 7, DATEADD(DAY, 6, CAST(GETDATE() AS DATE)), '19:00', DATEADD(HOUR, -3, GETDATE()), 400, 'LP202600000000000020', 'Cancelada paciente'),
(10, 19, 9, DATEADD(DAY, 8, CAST(GETDATE() AS DATE)), '09:00', DATEADD(DAY, -5, GETDATE()), 950, 'LP202600000000000021', 'Cancelada doctor'),
(3, 32, 15, DATEADD(DAY, 9, CAST(GETDATE() AS DATE)), '16:00', DATEADD(DAY, -6, GETDATE()), 1200, 'LP202600000000000022', 'Cancelada doctor'),
(11, 41, 20, DATEADD(DAY, 3, CAST(GETDATE() AS DATE)), '12:30', DATEADD(DAY, -4, GETDATE()), 650, 'LP202600000000000023', 'Cancelada doctor'),
(12, 9, 4, DATEADD(DAY, 11, CAST(GETDATE() AS DATE)), '13:00', DATEADD(DAY, -2, GETDATE()), 750, 'LP202600000000000024', 'Cancelada falta de pago'),
(1, 25, 12, DATEADD(DAY, 14, CAST(GETDATE() AS DATE)), '08:30', DATEADD(DAY, -3, GETDATE()), 600, 'LP202600000000000025', 'Cancelada falta de pago');
GO

--Pagos: 20 (todas las citas que se pagaron dentro de las 8 horas)
INSERT INTO PAGO (folio_cita, monto, fecha_pago, metodo_pago) VALUES
(1, 900, DATEADD(HOUR, 2, DATEADD(DAY, -35, GETDATE())), 'Tarjeta'),
(2, 750, DATEADD(HOUR, 2, DATEADD(DAY, -33, GETDATE())), 'Efectivo'),
(3, 800, DATEADD(HOUR, 2, DATEADD(DAY, -30, GETDATE())), 'Transferencia'),
(4, 400, DATEADD(HOUR, 2, DATEADD(DAY, -27, GETDATE())), 'Tarjeta'),
(5, 950, DATEADD(HOUR, 2, DATEADD(DAY, -24, GETDATE())), 'Efectivo'),
(6, 600, DATEADD(HOUR, 2, DATEADD(DAY, -22, GETDATE())), 'Transferencia'),
(7, 800, DATEADD(HOUR, 2, DATEADD(DAY, -20, GETDATE())), 'Tarjeta'),
(8, 1200, DATEADD(HOUR, 2, DATEADD(DAY, -16, GETDATE())), 'Efectivo'),
(9, 650, DATEADD(HOUR, 2, DATEADD(DAY, -14, GETDATE())), 'Transferencia'),
(10, 850, DATEADD(HOUR, 2, DATEADD(DAY, -12, GETDATE())), 'Tarjeta'),
(11, 400, DATEADD(HOUR, 2, DATEADD(DAY, -10, GETDATE())), 'Efectivo'),
(12, 750, DATEADD(HOUR, 2, DATEADD(DAY, -2, GETDATE())), 'Transferencia'),
(13, 650, DATEADD(HOUR, 2, DATEADD(DAY, -3, GETDATE())), 'Tarjeta'),
(14, 900, DATEADD(HOUR, 2, DATEADD(DAY, -1, GETDATE())), 'Efectivo'),
(17, 850, DATEADD(HOUR, 2, DATEADD(DAY, -4, GETDATE())), 'Transferencia'),
(18, 600, DATEADD(HOUR, 2, DATEADD(DAY, -10, GETDATE())), 'Tarjeta'),
(19, 900, DATEADD(HOUR, 2, DATEADD(DAY, -12, GETDATE())), 'Efectivo'),
(21, 950, DATEADD(HOUR, 2, DATEADD(DAY, -5, GETDATE())), 'Transferencia'),
(22, 1200, DATEADD(HOUR, 2, DATEADD(DAY, -6, GETDATE())), 'Tarjeta'),
(23, 650, DATEADD(HOUR, 2, DATEADD(DAY, -4, GETDATE())), 'Efectivo');
GO

--Cancelaciones: 10
--17: 100% (mas de 48 h antes), 18: 50% (entre 24 y 48 h), 19: 0% (menos de 24 h), 20: sin pago
--21-23: canceladas por el doctor y aprobadas por recepcion (100%), 24-25: falta de pago
--La solicitud sobre la cita 14 fue rechazada por recepcion, por eso esa cita sigue Pagada
INSERT INTO CANCELACION (folio_cita, solicitada_por, motivo, fecha_solicitud, estado, aprobada_por, porcentaje_devolucion, monto_devuelto) VALUES
(17, 'Paciente', 'Viaje de trabajo', DATEADD(DAY, -1, GETDATE()), 'Aprobada', NULL, 100, 850),
(18, 'Paciente', 'Se siente mejor', DATEADD(HOUR, 20, CAST(DATEADD(DAY, -5, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Aprobada', NULL, 50, 300),
(19, 'Paciente', 'Problema de transporte', DATEADD(HOUR, 2, CAST(DATEADD(DAY, -4, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Aprobada', NULL, 0, 0),
(20, 'Paciente', 'Agendó por error', DATEADD(HOUR, -1, GETDATE()), 'Aprobada', NULL, 0, 0),
(21, 'Doctor', 'Congreso médico', DATEADD(DAY, -1, GETDATE()), 'Aprobada', 1, 100, 950),
(22, 'Doctor', 'Incapacidad del doctor', DATEADD(DAY, -2, GETDATE()), 'Aprobada', 1, 100, 1200),
(23, 'Doctor', 'Cirugía de urgencia', DATEADD(DAY, -1, GETDATE()), 'Aprobada', 1, 100, 650),
(24, 'Sistema', 'No se pagó en 8 horas', DATEADD(HOUR, 8, DATEADD(DAY, -2, GETDATE())), 'Aprobada', NULL, 0, 0),
(25, 'Sistema', 'No se pagó en 8 horas', DATEADD(HOUR, 8, DATEADD(DAY, -3, GETDATE())), 'Aprobada', NULL, 0, 0),
(14, 'Doctor', 'Cambio de horario', DATEADD(HOUR, -12, GETDATE()), 'Rechazada', 1, 0, 0);
GO

--Recetas: una por cada cita Atendida (folio_cita 1-10)
INSERT INTO RECETA (folio_cita, fecha, diagnostico, tratamiento, observaciones) VALUES
(1, DATEADD(HOUR, 9, CAST(DATEADD(DAY, -30, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Hipertensión arterial controlada', 'Dieta baja en sal y caminata diaria de 30 minutos', 'Control en 3 meses'),
(2, DATEADD(HOUR, 10, CAST(DATEADD(DAY, -28, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Dermatitis por contacto', 'Evitar el contacto con detergentes', 'Revisar en 2 semanas'),
(3, DATEADD(HOUR, 11, CAST(DATEADD(DAY, -25, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Infección de vías urinarias', 'Tomar 2 litros de agua al día', NULL),
(4, DATEADD(HOUR, 12, CAST(DATEADD(DAY, -22, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Faringitis bacteriana', 'Reposo de 3 días', 'Regresar si persiste la fiebre'),
(5, DATEADD(HOUR, 13, CAST(DATEADD(DAY, -20, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Enfermedad renal crónica etapa 2', 'Dieta baja en proteínas y control de presión', 'Estudios de laboratorio en 1 mes'),
(6, DATEADD(HOUR, 9, CAST(DATEADD(DAY, -18, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Sobrepeso', 'Plan de alimentación de 1800 kcal', 'Pesarse cada semana'),
(7, DATEADD(HOUR, 10, CAST(DATEADD(DAY, -15, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Conjuntivitis alérgica', 'Compresas frías', 'Evitar frotarse los ojos'),
(8, DATEADD(HOUR, 11, CAST(DATEADD(DAY, -12, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Seguimiento de cáncer de próstata', 'Continuar tratamiento hormonal', 'Siguiente consulta en 1 mes'),
(9, DATEADD(HOUR, 12, CAST(DATEADD(DAY, -10, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Bronquitis aguda', 'Nebulizaciones cada 12 horas por 5 días', 'Tutor debe vigilar la fiebre'),
(10, DATEADD(HOUR, 13, CAST(DATEADD(DAY, -8, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Esguince de tobillo grado 1', 'Reposo, hielo y vendaje por 7 días', NULL);
GO

--Medicamentos recetados: 16 (id_medicamento en el orden de la tabla MEDICAMENTO)
INSERT INTO RECETA_MEDICAMENTO (folio_receta, id_medicamento, dosis) VALUES
(1, 7, '1 tableta cada 24 horas'),
(1, 8, '1 tableta cada noche'),
(2, 12, 'Aplicar 2 veces al día por 10 días'),
(2, 5, '1 tableta cada 24 horas por 7 días'),
(3, 3, '1 cápsula cada 8 horas por 7 días'),
(3, 1, '1 tableta cada 8 horas si hay dolor'),
(4, 3, '1 cápsula cada 8 horas por 10 días'),
(4, 2, '1 tableta cada 8 horas por 3 días'),
(5, 7, '1 tableta cada 12 horas'),
(6, 10, '1 tableta cada 24 horas'),
(7, 5, '1 tableta cada 24 horas por 5 días'),
(8, 15, '1 tableta cada 24 horas'),
(9, 9, '2 disparos cada 6 horas'),
(9, 13, '5 ml cada 8 horas por 5 días'),
(10, 14, '1 tableta cada 12 horas por 5 días'),
(10, 11, 'Aplicar 3 veces al día');
GO

--Ventas (tickets): 10; el cliente puede ser paciente (id_paciente) o no (nombre_cliente o anonimo)
--num_empleado 1 recepcionista (cobra servicios), 2 farmaceutico (cobra medicamentos)
INSERT INTO VENTA (fecha, num_empleado, id_paciente, nombre_cliente, metodo_pago) VALUES
(DATEADD(DAY, -29, GETDATE()), 2, 1, NULL, 'Efectivo'),
(DATEADD(DAY, -26, GETDATE()), 2, NULL, 'Rosa Elena Díaz', 'Tarjeta'),
(DATEADD(DAY, -27, GETDATE()), 2, 2, NULL, 'Efectivo'),
(DATEADD(DAY, -21, GETDATE()), 2, NULL, NULL, 'Efectivo'),
(DATEADD(DAY, -24, GETDATE()), 1, 3, NULL, 'Tarjeta'),
(DATEADD(DAY, -17, GETDATE()), 1, NULL, 'Arturo Mena', 'Transferencia'),
(DATEADD(DAY, -11, GETDATE()), 2, 8, NULL, 'Tarjeta'),
(DATEADD(DAY, -9, GETDATE()), 1, 11, NULL, 'Efectivo'),
(DATEADD(DAY, -5, GETDATE()), 2, NULL, 'Guadalupe Soto', 'Efectivo'),
(DATEADD(DAY, -7, GETDATE()), 1, 9, NULL, 'Tarjeta');
GO

--Detalle de las ventas: 19 renglones (cada renglon es un medicamento o un servicio)
INSERT INTO DETALLE_VENTA (id_venta, id_medicamento, id_servicio, cantidad, precio_unitario) VALUES
(1, 7, NULL, 1, 95),
(1, 8, NULL, 1, 180),
(2, NULL, 1, 1, 80),
(2, 1, NULL, 2, 45),
(3, 12, NULL, 1, 75),
(3, NULL, 3, 1, 250),
(4, 2, NULL, 1, 60),
(5, 3, NULL, 2, 120),
(5, 1, NULL, 1, 45),
(6, NULL, 2, 1, 150),
(6, NULL, 4, 1, 350),
(7, 15, NULL, 1, 450),
(8, 5, NULL, 1, 55),
(8, NULL, 7, 1, 120),
(9, 11, NULL, 1, 110),
(9, NULL, 9, 1, 150),
(10, 9, NULL, 1, 210),
(10, 13, NULL, 1, 90),
(10, NULL, 7, 2, 120);
GO

--Bitacora de estatus: el historial de cambios de cada cita
--(cuando hagamos los triggers se llenara sola; estos registros son para tener datos de prueba)
INSERT INTO BITACORA_ESTATUS_CITA (folio_cita, fecha_mov, estatus_cita, fecha_cita, id_especialidad, costo, politica_cancela, monto_devuelto) VALUES
(1, DATEADD(DAY, -35, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -30, CAST(GETDATE() AS DATE)), 1, 900, NULL, NULL),
(1, DATEADD(HOUR, 2, DATEADD(DAY, -35, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -30, CAST(GETDATE() AS DATE)), 1, 900, NULL, NULL),
(1, DATEADD(HOUR, 10, CAST(DATEADD(DAY, -30, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Atendida', DATEADD(DAY, -30, CAST(GETDATE() AS DATE)), 1, 900, NULL, NULL),
(2, DATEADD(DAY, -33, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -28, CAST(GETDATE() AS DATE)), 2, 750, NULL, NULL),
(2, DATEADD(HOUR, 2, DATEADD(DAY, -33, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -28, CAST(GETDATE() AS DATE)), 2, 750, NULL, NULL),
(2, DATEADD(HOUR, 17, CAST(DATEADD(DAY, -28, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Atendida', DATEADD(DAY, -28, CAST(GETDATE() AS DATE)), 2, 750, NULL, NULL),
(3, DATEADD(DAY, -30, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -25, CAST(GETDATE() AS DATE)), 3, 800, NULL, NULL),
(3, DATEADD(HOUR, 2, DATEADD(DAY, -30, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -25, CAST(GETDATE() AS DATE)), 3, 800, NULL, NULL),
(3, DATEADD(HOUR, 11, CAST(DATEADD(DAY, -25, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Atendida', DATEADD(DAY, -25, CAST(GETDATE() AS DATE)), 3, 800, NULL, NULL),
(4, DATEADD(DAY, -27, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -22, CAST(GETDATE() AS DATE)), 4, 400, NULL, NULL),
(4, DATEADD(HOUR, 2, DATEADD(DAY, -27, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -22, CAST(GETDATE() AS DATE)), 4, 400, NULL, NULL),
(4, DATEADD(HOUR, 12, CAST(DATEADD(DAY, -22, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Atendida', DATEADD(DAY, -22, CAST(GETDATE() AS DATE)), 4, 400, NULL, NULL),
(5, DATEADD(DAY, -24, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -20, CAST(GETDATE() AS DATE)), 5, 950, NULL, NULL),
(5, DATEADD(HOUR, 2, DATEADD(DAY, -24, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -20, CAST(GETDATE() AS DATE)), 5, 950, NULL, NULL),
(5, DATEADD(HOUR, 16, CAST(DATEADD(DAY, -20, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Atendida', DATEADD(DAY, -20, CAST(GETDATE() AS DATE)), 5, 950, NULL, NULL),
(6, DATEADD(DAY, -22, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -18, CAST(GETDATE() AS DATE)), 6, 600, NULL, NULL),
(6, DATEADD(HOUR, 2, DATEADD(DAY, -22, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -18, CAST(GETDATE() AS DATE)), 6, 600, NULL, NULL),
(6, DATEADD(HOUR, 10, CAST(DATEADD(DAY, -18, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Atendida', DATEADD(DAY, -18, CAST(GETDATE() AS DATE)), 6, 600, NULL, NULL),
(7, DATEADD(DAY, -20, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -15, CAST(GETDATE() AS DATE)), 7, 800, NULL, NULL),
(7, DATEADD(HOUR, 2, DATEADD(DAY, -20, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -15, CAST(GETDATE() AS DATE)), 7, 800, NULL, NULL),
(7, DATEADD(HOUR, 18, CAST(DATEADD(DAY, -15, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Atendida', DATEADD(DAY, -15, CAST(GETDATE() AS DATE)), 7, 800, NULL, NULL),
(8, DATEADD(DAY, -16, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -12, CAST(GETDATE() AS DATE)), 8, 1200, NULL, NULL),
(8, DATEADD(HOUR, 2, DATEADD(DAY, -16, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -12, CAST(GETDATE() AS DATE)), 8, 1200, NULL, NULL),
(8, DATEADD(HOUR, 9, CAST(DATEADD(DAY, -12, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Atendida', DATEADD(DAY, -12, CAST(GETDATE() AS DATE)), 8, 1200, NULL, NULL),
(9, DATEADD(DAY, -14, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -10, CAST(GETDATE() AS DATE)), 10, 650, NULL, NULL),
(9, DATEADD(HOUR, 2, DATEADD(DAY, -14, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -10, CAST(GETDATE() AS DATE)), 10, 650, NULL, NULL),
(9, DATEADD(HOUR, 11, CAST(DATEADD(DAY, -10, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Atendida', DATEADD(DAY, -10, CAST(GETDATE() AS DATE)), 10, 650, NULL, NULL),
(10, DATEADD(DAY, -12, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -8, CAST(GETDATE() AS DATE)), 9, 850, NULL, NULL),
(10, DATEADD(HOUR, 2, DATEADD(DAY, -12, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -8, CAST(GETDATE() AS DATE)), 9, 850, NULL, NULL),
(10, DATEADD(HOUR, 19, CAST(DATEADD(DAY, -8, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Atendida', DATEADD(DAY, -8, CAST(GETDATE() AS DATE)), 9, 850, NULL, NULL),
(11, DATEADD(DAY, -10, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -6, CAST(GETDATE() AS DATE)), 4, 400, NULL, NULL),
(11, DATEADD(HOUR, 2, DATEADD(DAY, -10, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -6, CAST(GETDATE() AS DATE)), 4, 400, NULL, NULL),
(11, DATEADD(HOUR, 13, CAST(DATEADD(DAY, -6, CAST(GETDATE() AS DATE)) AS DATETIME)), 'No acudio', DATEADD(DAY, -6, CAST(GETDATE() AS DATE)), 4, 400, NULL, NULL),
(12, DATEADD(DAY, -2, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, 5, CAST(GETDATE() AS DATE)), 2, 750, NULL, NULL),
(12, DATEADD(HOUR, 2, DATEADD(DAY, -2, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, 5, CAST(GETDATE() AS DATE)), 2, 750, NULL, NULL),
(13, DATEADD(DAY, -3, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, 7, CAST(GETDATE() AS DATE)), 10, 650, NULL, NULL),
(13, DATEADD(HOUR, 2, DATEADD(DAY, -3, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, 7, CAST(GETDATE() AS DATE)), 10, 650, NULL, NULL),
(14, DATEADD(DAY, -1, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, 10, CAST(GETDATE() AS DATE)), 1, 900, NULL, NULL),
(14, DATEADD(HOUR, 2, DATEADD(DAY, -1, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, 10, CAST(GETDATE() AS DATE)), 1, 900, NULL, NULL),
(15, DATEADD(HOUR, -2, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, 4, CAST(GETDATE() AS DATE)), 7, 800, NULL, NULL),
(16, DATEADD(HOUR, -1, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, 12, CAST(GETDATE() AS DATE)), 3, 800, NULL, NULL),
(17, DATEADD(DAY, -4, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, 15, CAST(GETDATE() AS DATE)), 9, 850, NULL, NULL),
(17, DATEADD(HOUR, 2, DATEADD(DAY, -4, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, 15, CAST(GETDATE() AS DATE)), 9, 850, NULL, NULL),
(17, DATEADD(DAY, -1, GETDATE()), 'Cancelada paciente', DATEADD(DAY, 15, CAST(GETDATE() AS DATE)), 9, 850, '48 h o mas: 100%', 850),
(18, DATEADD(DAY, -10, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -3, CAST(GETDATE() AS DATE)), 6, 600, NULL, NULL),
(18, DATEADD(HOUR, 2, DATEADD(DAY, -10, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -3, CAST(GETDATE() AS DATE)), 6, 600, NULL, NULL),
(18, DATEADD(HOUR, 20, CAST(DATEADD(DAY, -5, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Cancelada paciente', DATEADD(DAY, -3, CAST(GETDATE() AS DATE)), 6, 600, 'Entre 24 y 48 h: 50%', 300),
(19, DATEADD(DAY, -12, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, -4, CAST(GETDATE() AS DATE)), 1, 900, NULL, NULL),
(19, DATEADD(HOUR, 2, DATEADD(DAY, -12, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, -4, CAST(GETDATE() AS DATE)), 1, 900, NULL, NULL),
(19, DATEADD(HOUR, 2, CAST(DATEADD(DAY, -4, CAST(GETDATE() AS DATE)) AS DATETIME)), 'Cancelada paciente', DATEADD(DAY, -4, CAST(GETDATE() AS DATE)), 1, 900, 'Menos de 24 h: 0%', 0),
(20, DATEADD(HOUR, -3, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, 6, CAST(GETDATE() AS DATE)), 4, 400, NULL, NULL),
(20, DATEADD(HOUR, -1, GETDATE()), 'Cancelada paciente', DATEADD(DAY, 6, CAST(GETDATE() AS DATE)), 4, 400, 'Sin pago: 0%', 0),
(21, DATEADD(DAY, -5, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, 8, CAST(GETDATE() AS DATE)), 5, 950, NULL, NULL),
(21, DATEADD(HOUR, 2, DATEADD(DAY, -5, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, 8, CAST(GETDATE() AS DATE)), 5, 950, NULL, NULL),
(21, DATEADD(DAY, -1, GETDATE()), 'Cancelada doctor', DATEADD(DAY, 8, CAST(GETDATE() AS DATE)), 5, 950, 'Cancelacion por doctor: 100%', 950),
(22, DATEADD(DAY, -6, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, 9, CAST(GETDATE() AS DATE)), 8, 1200, NULL, NULL),
(22, DATEADD(HOUR, 2, DATEADD(DAY, -6, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, 9, CAST(GETDATE() AS DATE)), 8, 1200, NULL, NULL),
(22, DATEADD(DAY, -2, GETDATE()), 'Cancelada doctor', DATEADD(DAY, 9, CAST(GETDATE() AS DATE)), 8, 1200, 'Cancelacion por doctor: 100%', 1200),
(23, DATEADD(DAY, -4, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, 3, CAST(GETDATE() AS DATE)), 10, 650, NULL, NULL),
(23, DATEADD(HOUR, 2, DATEADD(DAY, -4, GETDATE())), 'Pagada pendiente por atender', DATEADD(DAY, 3, CAST(GETDATE() AS DATE)), 10, 650, NULL, NULL),
(23, DATEADD(DAY, -1, GETDATE()), 'Cancelada doctor', DATEADD(DAY, 3, CAST(GETDATE() AS DATE)), 10, 650, 'Cancelacion por doctor: 100%', 650),
(24, DATEADD(DAY, -2, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, 11, CAST(GETDATE() AS DATE)), 2, 750, NULL, NULL),
(24, DATEADD(HOUR, 8, DATEADD(DAY, -2, GETDATE())), 'Cancelada falta de pago', DATEADD(DAY, 11, CAST(GETDATE() AS DATE)), 2, 750, 'Falta de pago: 0%', 0),
(25, DATEADD(DAY, -3, GETDATE()), 'Agendada pendiente de pago', DATEADD(DAY, 14, CAST(GETDATE() AS DATE)), 6, 600, NULL, NULL),
(25, DATEADD(HOUR, 8, DATEADD(DAY, -3, GETDATE())), 'Cancelada falta de pago', DATEADD(DAY, 14, CAST(GETDATE() AS DATE)), 6, 600, 'Falta de pago: 0%', 0);
GO

--Bitacora del historial de citas: una por cada consulta cerrada (Atendida o No acudio)
INSERT INTO BITACORA_HISTORIAL_CITA (usuario, maquina_ip, fecha_mov, folio_cita, fecha_cita, hora_cita, id_paciente, folio_receta, id_doctor, estatus_consulta, especialidad, consultorio) VALUES
('dr.garcia', '192.168.1.21', DATEADD(HOUR, 10, CAST(DATEADD(DAY, -30, CAST(GETDATE() AS DATE)) AS DATETIME)), 1, DATEADD(DAY, -30, CAST(GETDATE() AS DATE)), '09:00', 1, 1, 3, 'Atendida', 'Cardiología', 'C-101'),
('dr.ibarra', '192.168.1.22', DATEADD(HOUR, 17, CAST(DATEADD(DAY, -28, CAST(GETDATE() AS DATE)) AS DATETIME)), 2, DATEADD(DAY, -28, CAST(GETDATE() AS DATE)), '16:00', 2, 2, 8, 'Atendida', 'Dermatología', 'C-103'),
('dr.vazquez', '192.168.1.23', DATEADD(HOUR, 11, CAST(DATEADD(DAY, -25, CAST(GETDATE() AS DATE)) AS DATETIME)), 3, DATEADD(DAY, -25, CAST(GETDATE() AS DATE)), '10:00', 3, 3, 11, 'Atendida', 'Ginecología', 'C-105'),
('dr.zamora', '192.168.1.24', DATEADD(HOUR, 12, CAST(DATEADD(DAY, -22, CAST(GETDATE() AS DATE)) AS DATETIME)), 4, DATEADD(DAY, -22, CAST(GETDATE() AS DATE)), '11:30', 4, 4, 17, 'Atendida', 'Medicina General', 'C-108'),
('dr.ponce', '192.168.1.25', DATEADD(HOUR, 16, CAST(DATEADD(DAY, -20, CAST(GETDATE() AS DATE)) AS DATETIME)), 5, DATEADD(DAY, -20, CAST(GETDATE() AS DATE)), '15:00', 5, 5, 20, 'Atendida', 'Nefrología', 'C-109'),
('dr.barrera', '192.168.1.26', DATEADD(HOUR, 10, CAST(DATEADD(DAY, -18, CAST(GETDATE() AS DATE)) AS DATETIME)), 6, DATEADD(DAY, -18, CAST(GETDATE() AS DATE)), '09:30', 6, 6, 23, 'Atendida', 'Nutriología', 'C-201'),
('dr.valencia', '192.168.1.27', DATEADD(HOUR, 18, CAST(DATEADD(DAY, -15, CAST(GETDATE() AS DATE)) AS DATETIME)), 7, DATEADD(DAY, -15, CAST(GETDATE() AS DATE)), '17:00', 7, 7, 30, 'Atendida', 'Oftalmología', 'C-204'),
('dr.esquivel', '192.168.1.28', DATEADD(HOUR, 9, CAST(DATEADD(DAY, -12, CAST(GETDATE() AS DATE)) AS DATETIME)), 8, DATEADD(DAY, -12, CAST(GETDATE() AS DATE)), '08:00', 8, 8, 31, 'Atendida', 'Oncología', 'C-205'),
('dr.delgado', '192.168.1.29', DATEADD(HOUR, 11, CAST(DATEADD(DAY, -10, CAST(GETDATE() AS DATE)) AS DATETIME)), 9, DATEADD(DAY, -10, CAST(GETDATE() AS DATE)), '10:30', 11, 9, 39, 'Atendida', 'Pediatría', 'C-209'),
('dr.bautista', '192.168.1.30', DATEADD(HOUR, 19, CAST(DATEADD(DAY, -8, CAST(GETDATE() AS DATE)) AS DATETIME)), 10, DATEADD(DAY, -8, CAST(GETDATE() AS DATE)), '18:30', 9, 10, 36, 'Atendida', 'Ortopedia', 'C-207'),
('dr.pacheco', '192.168.1.31', DATEADD(HOUR, 13, CAST(DATEADD(DAY, -6, CAST(GETDATE() AS DATE)) AS DATETIME)), 11, DATEADD(DAY, -6, CAST(GETDATE() AS DATE)), '12:00', 10, NULL, 15, 'No acudio', 'Medicina General', 'C-107');
GO
