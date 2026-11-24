--Proyecto final Bases de Datos: SGBD Hospital
--Script 01: estructura de la base de datos (SQL Server)

USE master;
GO
IF DB_ID('HospitalDB') IS NULL
CREATE DATABASE HospitalDB;
GO
USE HospitalDB;
GO

--Usuarios del sistema (modulo de login)
CREATE TABLE USUARIO (
id_usuario INT IDENTITY(1,1) PRIMARY KEY,
username NVARCHAR(50) NOT NULL,
password_hash VARBINARY(32) NOT NULL,
sal VARBINARY(16) NOT NULL,
rol VARCHAR(15) NOT NULL,
activo BIT NOT NULL DEFAULT 1,
fecha_alta DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
CONSTRAINT UQ_USUARIO_username UNIQUE (username),
CONSTRAINT CK_USUARIO_rol CHECK (rol IN ('Admin','Recepcionista','Doctor','Paciente','Cajero','Farmaceutico'))
);
GO

--Especialidades medicas y su costo de consulta
CREATE TABLE ESPECIALIDAD (
id_especialidad INT IDENTITY(1,1) PRIMARY KEY,
nombre NVARCHAR(60) NOT NULL,
costo_consulta DECIMAL(10,2) NOT NULL,
CONSTRAINT UQ_ESPECIALIDAD_nombre UNIQUE (nombre),
CONSTRAINT CK_ESPECIALIDAD_costo CHECK (costo_consulta > 0)
);
GO

--Consultorios del hospital
CREATE TABLE CONSULTORIO (
id_consultorio INT IDENTITY(1,1) PRIMARY KEY,
numero NVARCHAR(10) NOT NULL,
piso TINYINT NOT NULL,
CONSTRAINT UQ_CONSULTORIO_numero UNIQUE (numero)
);
GO

--Empleados (recepcionistas, doctores, cajeros, farmaceuticos)
CREATE TABLE EMPLEADO (
num_empleado INT IDENTITY(1000,1) PRIMARY KEY,
id_usuario INT NOT NULL,
nombre NVARCHAR(60) NOT NULL,
ap_paterno NVARCHAR(60) NOT NULL,
ap_materno NVARCHAR(60) NULL,
curp CHAR(18) NOT NULL,
telefono CHAR(10) NOT NULL,
correo NVARCHAR(100) NOT NULL,
fecha_ingreso DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE)),
activo BIT NOT NULL DEFAULT 1,
CONSTRAINT UQ_EMPLEADO_usuario UNIQUE (id_usuario),
CONSTRAINT UQ_EMPLEADO_curp UNIQUE (curp),
CONSTRAINT UQ_EMPLEADO_correo UNIQUE (correo),
CONSTRAINT FK_EMPLEADO_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIO (id_usuario),
CONSTRAINT CK_EMPLEADO_curp CHECK (LEN(curp) = 18),
CONSTRAINT CK_EMPLEADO_telefono CHECK (telefono NOT LIKE '%[^0-9]%'),
CONSTRAINT CK_EMPLEADO_correo CHECK (correo LIKE '%_@_%._%')
);
GO

--Doctores: una especialidad, un consultorio y su jornada de trabajo
CREATE TABLE DOCTOR (
num_empleado INT PRIMARY KEY,
cedula_profesional VARCHAR(8) NOT NULL,
id_especialidad INT NOT NULL,
id_consultorio INT NOT NULL,
hora_entrada TIME(0) NOT NULL,
hora_salida TIME(0) NOT NULL,
CONSTRAINT UQ_DOCTOR_cedula UNIQUE (cedula_profesional),
CONSTRAINT FK_DOCTOR_EMPLEADO FOREIGN KEY (num_empleado) REFERENCES EMPLEADO (num_empleado),
CONSTRAINT FK_DOCTOR_ESPECIALIDAD FOREIGN KEY (id_especialidad) REFERENCES ESPECIALIDAD (id_especialidad),
CONSTRAINT FK_DOCTOR_CONSULTORIO FOREIGN KEY (id_consultorio) REFERENCES CONSULTORIO (id_consultorio),
CONSTRAINT CK_DOCTOR_cedula CHECK (cedula_profesional NOT LIKE '%[^0-9]%' AND LEN(cedula_profesional) BETWEEN 7 AND 8),
CONSTRAINT CK_DOCTOR_jornada CHECK (hora_salida > hora_entrada),
--La jornada empieza y termina en bloques de 30 min
CONSTRAINT CK_DOCTOR_bloques CHECK (DATEPART(MINUTE, hora_entrada) IN (0,30) AND DATEPART(MINUTE, hora_salida) IN (0,30))
);
GO

--Pacientes (se pueden dar de alta a si mismos)
CREATE TABLE PACIENTE (
id_paciente INT IDENTITY(1,1) PRIMARY KEY,
id_usuario INT NOT NULL,
nombre NVARCHAR(60) NOT NULL,
ap_paterno NVARCHAR(60) NOT NULL,
ap_materno NVARCHAR(60) NULL,
curp CHAR(18) NOT NULL,
fecha_nacimiento DATE NOT NULL,
sexo CHAR(1) NOT NULL,
telefono CHAR(10) NOT NULL,
correo NVARCHAR(100) NOT NULL,
fecha_registro DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
CONSTRAINT UQ_PACIENTE_usuario UNIQUE (id_usuario),
CONSTRAINT UQ_PACIENTE_curp UNIQUE (curp),
CONSTRAINT UQ_PACIENTE_correo UNIQUE (correo),
CONSTRAINT FK_PACIENTE_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIO (id_usuario),
CONSTRAINT CK_PACIENTE_curp CHECK (LEN(curp) = 18),
CONSTRAINT CK_PACIENTE_sexo CHECK (sexo IN ('M','F')),
CONSTRAINT CK_PACIENTE_telefono CHECK (telefono NOT LIKE '%[^0-9]%'),
CONSTRAINT CK_PACIENTE_correo CHECK (correo LIKE '%_@_%._%')
);
GO

--Historial medico: uno por paciente
CREATE TABLE HISTORIAL_MEDICO (
id_historial INT IDENTITY(1,1) PRIMARY KEY,
id_paciente INT NOT NULL,
tipo_sangre VARCHAR(3) NULL,
alergias NVARCHAR(500) NULL,
padecimientos_previos NVARCHAR(500) NULL,
peso DECIMAL(5,2) NULL,
estatura DECIMAL(3,2) NULL,
CONSTRAINT UQ_HISTORIAL_paciente UNIQUE (id_paciente),
CONSTRAINT FK_HISTORIAL_PACIENTE FOREIGN KEY (id_paciente) REFERENCES PACIENTE (id_paciente),
CONSTRAINT CK_HISTORIAL_sangre CHECK (tipo_sangre IN ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
CONSTRAINT CK_HISTORIAL_peso CHECK (peso > 0),
CONSTRAINT CK_HISTORIAL_estatura CHECK (estatura > 0)
);
GO

--Citas
CREATE TABLE CITA (
folio_cita INT IDENTITY(1,1) PRIMARY KEY,
id_paciente INT NOT NULL,
num_empleado_doctor INT NOT NULL,
id_consultorio INT NOT NULL,
fecha_cita DATE NOT NULL,
hora_cita TIME(0) NOT NULL,
fecha_registro DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
costo DECIMAL(10,2) NOT NULL,
linea_pago CHAR(20) NOT NULL,
estatus VARCHAR(30) NOT NULL DEFAULT 'Agendada pendiente de pago',
--Limite para pagar: 8 horas despues de agendar
fecha_limite_pago AS DATEADD(HOUR, 8, fecha_registro),
CONSTRAINT UQ_CITA_linea_pago UNIQUE (linea_pago),
CONSTRAINT FK_CITA_PACIENTE FOREIGN KEY (id_paciente) REFERENCES PACIENTE (id_paciente),
CONSTRAINT FK_CITA_DOCTOR FOREIGN KEY (num_empleado_doctor) REFERENCES DOCTOR (num_empleado),
CONSTRAINT FK_CITA_CONSULTORIO FOREIGN KEY (id_consultorio) REFERENCES CONSULTORIO (id_consultorio),
CONSTRAINT CK_CITA_costo CHECK (costo > 0),
CONSTRAINT CK_CITA_bloque CHECK (DATEPART(MINUTE, hora_cita) IN (0,30)),
CONSTRAINT CK_CITA_fecha CHECK (fecha_cita > CAST(fecha_registro AS DATE)),
CONSTRAINT CK_CITA_estatus CHECK (estatus IN ('Agendada pendiente de pago','Pagada pendiente por atender','Cancelada falta de pago','Cancelada paciente','Cancelada doctor','Atendida','No acudio'))
);
GO
--El doctor no puede tener dos citas activas a la misma hora
CREATE UNIQUE INDEX UX_CITA_doctor_horario ON CITA (num_empleado_doctor, fecha_cita, hora_cita) WHERE estatus IN ('Agendada pendiente de pago','Pagada pendiente por atender');
--El paciente no puede tener dos citas activas a la misma hora
CREATE UNIQUE INDEX UX_CITA_paciente_horario ON CITA (id_paciente, fecha_cita, hora_cita) WHERE estatus IN ('Agendada pendiente de pago','Pagada pendiente por atender');
--El paciente solo puede tener una cita pendiente con el mismo doctor
CREATE UNIQUE INDEX UX_CITA_paciente_doctor ON CITA (id_paciente, num_empleado_doctor) WHERE estatus IN ('Agendada pendiente de pago','Pagada pendiente por atender');
GO

--Pago de la cita (uno por cita)
CREATE TABLE PAGO (
id_pago INT IDENTITY(1,1) PRIMARY KEY,
folio_cita INT NOT NULL,
monto DECIMAL(10,2) NOT NULL,
fecha_pago DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
metodo_pago VARCHAR(15) NOT NULL,
CONSTRAINT UQ_PAGO_cita UNIQUE (folio_cita),
CONSTRAINT FK_PAGO_CITA FOREIGN KEY (folio_cita) REFERENCES CITA (folio_cita),
CONSTRAINT CK_PAGO_monto CHECK (monto > 0),
CONSTRAINT CK_PAGO_metodo CHECK (metodo_pago IN ('Efectivo','Tarjeta','Transferencia'))
);
GO

--Cancelaciones: del paciente, del doctor (requiere aprobacion de recepcionista) o por falta de pago
CREATE TABLE CANCELACION (
id_cancelacion INT IDENTITY(1,1) PRIMARY KEY,
folio_cita INT NOT NULL,
solicitada_por VARCHAR(15) NOT NULL,
motivo NVARCHAR(250) NULL,
fecha_solicitud DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
estado VARCHAR(10) NOT NULL DEFAULT 'Aprobada',
aprobada_por INT NULL,
porcentaje_devolucion TINYINT NOT NULL DEFAULT 0,
monto_devuelto DECIMAL(10,2) NOT NULL DEFAULT 0,
CONSTRAINT FK_CANCELACION_CITA FOREIGN KEY (folio_cita) REFERENCES CITA (folio_cita),
CONSTRAINT FK_CANCELACION_EMPLEADO FOREIGN KEY (aprobada_por) REFERENCES EMPLEADO (num_empleado),
CONSTRAINT CK_CANCELACION_solicitante CHECK (solicitada_por IN ('Paciente','Doctor','Recepcionista','Sistema')),
CONSTRAINT CK_CANCELACION_estado CHECK (estado IN ('Pendiente','Aprobada','Rechazada')),
CONSTRAINT CK_CANCELACION_porcentaje CHECK (porcentaje_devolucion IN (0,50,100)),
CONSTRAINT CK_CANCELACION_monto CHECK (monto_devuelto >= 0)
);
GO
--Una cita solo puede tener una cancelacion pendiente o aprobada
CREATE UNIQUE INDEX UX_CANCELACION_cita ON CANCELACION (folio_cita) WHERE estado IN ('Pendiente','Aprobada');
GO

--Medicamentos (inventario de farmacia)
CREATE TABLE MEDICAMENTO (
id_medicamento INT IDENTITY(1,1) PRIMARY KEY,
nombre NVARCHAR(100) NOT NULL,
presentacion NVARCHAR(50) NOT NULL,
precio DECIMAL(10,2) NOT NULL,
stock INT NOT NULL DEFAULT 0,
CONSTRAINT UQ_MEDICAMENTO UNIQUE (nombre, presentacion),
CONSTRAINT CK_MEDICAMENTO_precio CHECK (precio > 0),
CONSTRAINT CK_MEDICAMENTO_stock CHECK (stock >= 0)
);
GO

--Recetas: una por cita
CREATE TABLE RECETA (
folio_receta INT IDENTITY(1,1) PRIMARY KEY,
folio_cita INT NOT NULL,
fecha DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
diagnostico NVARCHAR(500) NOT NULL,
tratamiento NVARCHAR(500) NULL,
observaciones NVARCHAR(500) NULL,
CONSTRAINT UQ_RECETA_cita UNIQUE (folio_cita),
CONSTRAINT FK_RECETA_CITA FOREIGN KEY (folio_cita) REFERENCES CITA (folio_cita)
);
GO

--Medicamentos recetados
CREATE TABLE RECETA_MEDICAMENTO (
folio_receta INT NOT NULL,
id_medicamento INT NOT NULL,
dosis NVARCHAR(100) NOT NULL,
PRIMARY KEY (folio_receta, id_medicamento),
CONSTRAINT FK_RM_RECETA FOREIGN KEY (folio_receta) REFERENCES RECETA (folio_receta),
CONSTRAINT FK_RM_MEDICAMENTO FOREIGN KEY (id_medicamento) REFERENCES MEDICAMENTO (id_medicamento)
);
GO

--Servicios extras (inyeccion, vacuna, curacion...)
CREATE TABLE SERVICIO (
id_servicio INT IDENTITY(1,1) PRIMARY KEY,
nombre NVARCHAR(80) NOT NULL,
precio DECIMAL(10,2) NOT NULL,
CONSTRAINT UQ_SERVICIO_nombre UNIQUE (nombre),
CONSTRAINT CK_SERVICIO_precio CHECK (precio > 0)
);
GO

--Ticket de cobro de medicamentos y servicios (el cliente no necesita ser paciente)
CREATE TABLE VENTA (
id_venta INT IDENTITY(1,1) PRIMARY KEY,
fecha DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
num_empleado INT NOT NULL,
id_paciente INT NULL,
nombre_cliente NVARCHAR(120) NULL,
metodo_pago VARCHAR(15) NOT NULL,
CONSTRAINT FK_VENTA_EMPLEADO FOREIGN KEY (num_empleado) REFERENCES EMPLEADO (num_empleado),
CONSTRAINT FK_VENTA_PACIENTE FOREIGN KEY (id_paciente) REFERENCES PACIENTE (id_paciente),
CONSTRAINT CK_VENTA_metodo CHECK (metodo_pago IN ('Efectivo','Tarjeta','Transferencia'))
);
GO

--Renglones del ticket: cada renglon es un medicamento o un servicio
CREATE TABLE DETALLE_VENTA (
id_detalle INT IDENTITY(1,1) PRIMARY KEY,
id_venta INT NOT NULL,
id_medicamento INT NULL,
id_servicio INT NULL,
cantidad INT NOT NULL,
precio_unitario DECIMAL(10,2) NOT NULL,
CONSTRAINT FK_DETALLE_VENTA FOREIGN KEY (id_venta) REFERENCES VENTA (id_venta),
CONSTRAINT FK_DETALLE_MEDICAMENTO FOREIGN KEY (id_medicamento) REFERENCES MEDICAMENTO (id_medicamento),
CONSTRAINT FK_DETALLE_SERVICIO FOREIGN KEY (id_servicio) REFERENCES SERVICIO (id_servicio),
CONSTRAINT CK_DETALLE_producto CHECK ((id_medicamento IS NOT NULL AND id_servicio IS NULL) OR (id_medicamento IS NULL AND id_servicio IS NOT NULL)),
CONSTRAINT CK_DETALLE_cantidad CHECK (cantidad > 0),
CONSTRAINT CK_DETALLE_precio CHECK (precio_unitario > 0)
);
GO

--Bitacora de cambios de estatus de las citas (solo consulta e insercion)
CREATE TABLE BITACORA_ESTATUS_CITA (
id_bitacora INT IDENTITY(1,1) PRIMARY KEY,
folio_cita INT NOT NULL,
fecha_mov DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
estatus_cita VARCHAR(30) NOT NULL,
fecha_cita DATE NOT NULL,
id_especialidad INT NOT NULL,
costo DECIMAL(10,2) NOT NULL,
politica_cancela VARCHAR(50) NULL,
monto_devuelto DECIMAL(10,2) NULL
);
GO

--Bitacora del historial de citas medico-paciente (solo consulta e insercion)
CREATE TABLE BITACORA_HISTORIAL_CITA (
id_historial INT IDENTITY(1,1) PRIMARY KEY,
usuario NVARCHAR(50) NOT NULL,
maquina_ip NVARCHAR(128) NULL DEFAULT HOST_NAME(),
fecha_mov DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
folio_cita INT NOT NULL,
fecha_cita DATE NOT NULL,
hora_cita TIME(0) NOT NULL,
id_paciente INT NOT NULL,
folio_receta INT NULL,
id_doctor INT NOT NULL,
estatus_consulta VARCHAR(15) NOT NULL,
especialidad NVARCHAR(60) NOT NULL,
consultorio NVARCHAR(10) NOT NULL,
CONSTRAINT CK_BITACORA_estatus CHECK (estatus_consulta IN ('Atendida','No acudio'))
);
GO

--Datos iniciales: especialidades (costos de ejemplo)
INSERT INTO ESPECIALIDAD (nombre, costo_consulta) VALUES
(N'Cardiología', 900),
(N'Dermatología', 750),
(N'Ginecología', 800),
(N'Medicina General', 400),
(N'Nefrología', 950),
(N'Nutriología', 600),
(N'Oftalmología', 800),
(N'Oncología', 1200),
(N'Ortopedia', 850),
(N'Pediatría', 650);

--Datos iniciales: servicios extras (precios de ejemplo)
INSERT INTO SERVICIO (nombre, precio) VALUES
(N'Inyección', 80),
(N'Vacuna', 150),
(N'Curación', 250),
(N'Estudio de sangre', 350);

--Usuario administrador inicial (cambiar la contraseña)
DECLARE @sal VARBINARY(16) = CRYPT_GEN_RANDOM(16);
INSERT INTO USUARIO (username, password_hash, sal, rol)
VALUES (N'admin', HASHBYTES('SHA2_256', CAST(N'Admin2026!' AS VARBINARY(200)) + @sal), @sal, 'Admin');
GO
