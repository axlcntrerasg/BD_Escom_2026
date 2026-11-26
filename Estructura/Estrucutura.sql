--Proyecto final Bases de Datos: SGBD Hospital
--Script 01: estructura de la base de datos (SQL Server)

CREATE DATABASE HospitalDB;
GO
USE HospitalDB;
GO

--Usuarios del sistema (modulo de login)
CREATE TABLE USUARIO (
id_usuario INT IDENTITY(1,1) PRIMARY KEY,
username VARCHAR(50) NOT NULL,
contrasena VARCHAR(50) NOT NULL,
rol VARCHAR(15) NOT NULL,
activo BIT NOT NULL DEFAULT 1,
fecha_alta DATETIME NOT NULL DEFAULT GETDATE(),
CONSTRAINT UQ_USUARIO_username UNIQUE (username),
CONSTRAINT CK_USUARIO_rol CHECK (rol IN ('Admin','Recepcionista','Doctor','Paciente','Farmaceutico')),
CONSTRAINT CK_USUARIO_contrasena CHECK (LEN(contrasena) >= 8)
);
GO

--Especialidades medicas y su costo de consulta
CREATE TABLE ESPECIALIDAD (
id_especialidad INT IDENTITY(1,1) PRIMARY KEY,
nombre VARCHAR(60) NOT NULL,
costo_consulta DECIMAL(10,2) NOT NULL,
CONSTRAINT UQ_ESPECIALIDAD_nombre UNIQUE (nombre),
CONSTRAINT CK_ESPECIALIDAD_costo CHECK (costo_consulta > 0)
);
GO

--Consultorios del hospital
CREATE TABLE CONSULTORIO (
id_consultorio INT IDENTITY(1,1) PRIMARY KEY,
numero VARCHAR(10) NOT NULL,
piso INT NOT NULL,
CONSTRAINT UQ_CONSULTORIO_numero UNIQUE (numero),
CONSTRAINT CK_CONSULTORIO_piso CHECK (piso >= 0)
);
GO

--Empleados (recepcionista, farmaceutico y doctores)
CREATE TABLE EMPLEADO (
num_empleado INT IDENTITY(1,1) PRIMARY KEY,
id_usuario INT NOT NULL,
nombre VARCHAR(60) NOT NULL,
ap_paterno VARCHAR(60) NOT NULL,
ap_materno VARCHAR(60) NULL,
curp CHAR(18) NOT NULL,
telefono CHAR(10) NOT NULL,
correo VARCHAR(100) NOT NULL,
fecha_ingreso DATE NOT NULL DEFAULT GETDATE(),
activo BIT NOT NULL DEFAULT 1,
CONSTRAINT UQ_EMPLEADO_usuario UNIQUE (id_usuario),
CONSTRAINT UQ_EMPLEADO_curp UNIQUE (curp),
CONSTRAINT UQ_EMPLEADO_correo UNIQUE (correo),
CONSTRAINT FK_EMPLEADO_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIO (id_usuario),
CONSTRAINT CK_EMPLEADO_curp CHECK (LEN(curp) = 18),
CONSTRAINT CK_EMPLEADO_telefono CHECK (LEN(telefono) = 10),
CONSTRAINT CK_EMPLEADO_correo CHECK (correo LIKE '%@%.%')
);
GO

--Doctores: una especialidad, un consultorio y su jornada de trabajo
CREATE TABLE DOCTOR (
num_empleado INT PRIMARY KEY,
cedula_profesional VARCHAR(8) NOT NULL,
id_especialidad INT NOT NULL,
id_consultorio INT NOT NULL,
hora_entrada TIME NOT NULL,
hora_salida TIME NOT NULL,
CONSTRAINT UQ_DOCTOR_cedula UNIQUE (cedula_profesional),
CONSTRAINT FK_DOCTOR_EMPLEADO FOREIGN KEY (num_empleado) REFERENCES EMPLEADO (num_empleado),
CONSTRAINT FK_DOCTOR_ESPECIALIDAD FOREIGN KEY (id_especialidad) REFERENCES ESPECIALIDAD (id_especialidad),
CONSTRAINT FK_DOCTOR_CONSULTORIO FOREIGN KEY (id_consultorio) REFERENCES CONSULTORIO (id_consultorio),
CONSTRAINT CK_DOCTOR_cedula CHECK (LEN(cedula_profesional) BETWEEN 7 AND 8),
CONSTRAINT CK_DOCTOR_jornada CHECK (hora_salida > hora_entrada)
);
GO

--Pacientes (se pueden dar de alta a si mismos)
CREATE TABLE PACIENTE (
id_paciente INT IDENTITY(1,1) PRIMARY KEY,
id_usuario INT NOT NULL,
nombre VARCHAR(60) NOT NULL,
ap_paterno VARCHAR(60) NOT NULL,
ap_materno VARCHAR(60) NULL,
curp CHAR(18) NOT NULL,
fecha_nacimiento DATE NOT NULL,
sexo CHAR(1) NOT NULL,
telefono CHAR(10) NOT NULL,
correo VARCHAR(100) NOT NULL,
fecha_registro DATETIME NOT NULL DEFAULT GETDATE(),
CONSTRAINT UQ_PACIENTE_usuario UNIQUE (id_usuario),
CONSTRAINT UQ_PACIENTE_curp UNIQUE (curp),
CONSTRAINT UQ_PACIENTE_correo UNIQUE (correo),
CONSTRAINT FK_PACIENTE_USUARIO FOREIGN KEY (id_usuario) REFERENCES USUARIO (id_usuario),
CONSTRAINT CK_PACIENTE_curp CHECK (LEN(curp) = 18),
CONSTRAINT CK_PACIENTE_sexo CHECK (sexo IN ('M','F')),
CONSTRAINT CK_PACIENTE_telefono CHECK (LEN(telefono) = 10),
CONSTRAINT CK_PACIENTE_correo CHECK (correo LIKE '%@%.%')
);
GO

--Historial medico: uno por paciente
CREATE TABLE HISTORIAL_MEDICO (
id_historial INT IDENTITY(1,1) PRIMARY KEY,
id_paciente INT NOT NULL,
tipo_sangre VARCHAR(3) NULL,
alergias VARCHAR(500) NULL,
padecimientos_previos VARCHAR(500) NULL,
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
hora_cita TIME NOT NULL,
fecha_registro DATETIME NOT NULL DEFAULT GETDATE(),
costo DECIMAL(10,2) NOT NULL,
linea_pago VARCHAR(20) NOT NULL,
estatus VARCHAR(30) NOT NULL DEFAULT 'Agendada pendiente de pago',
CONSTRAINT UQ_CITA_linea_pago UNIQUE (linea_pago),
CONSTRAINT FK_CITA_PACIENTE FOREIGN KEY (id_paciente) REFERENCES PACIENTE (id_paciente),
CONSTRAINT FK_CITA_DOCTOR FOREIGN KEY (num_empleado_doctor) REFERENCES DOCTOR (num_empleado),
CONSTRAINT FK_CITA_CONSULTORIO FOREIGN KEY (id_consultorio) REFERENCES CONSULTORIO (id_consultorio),
CONSTRAINT CK_CITA_costo CHECK (costo > 0),
CONSTRAINT CK_CITA_estatus CHECK (estatus IN ('Agendada pendiente de pago','Pagada pendiente por atender','Cancelada falta de pago','Cancelada paciente','Cancelada doctor','Atendida','No acudio'))
);
GO

--Pago de la cita (uno por cita)
CREATE TABLE PAGO (
id_pago INT IDENTITY(1,1) PRIMARY KEY,
folio_cita INT NOT NULL,
monto DECIMAL(10,2) NOT NULL,
fecha_pago DATETIME NOT NULL DEFAULT GETDATE(),
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
motivo VARCHAR(250) NULL,
fecha_solicitud DATETIME NOT NULL DEFAULT GETDATE(),
estado VARCHAR(10) NOT NULL DEFAULT 'Aprobada',
aprobada_por INT NULL,
porcentaje_devolucion INT NOT NULL DEFAULT 0,
monto_devuelto DECIMAL(10,2) NOT NULL DEFAULT 0,
CONSTRAINT FK_CANCELACION_CITA FOREIGN KEY (folio_cita) REFERENCES CITA (folio_cita),
CONSTRAINT FK_CANCELACION_EMPLEADO FOREIGN KEY (aprobada_por) REFERENCES EMPLEADO (num_empleado),
CONSTRAINT CK_CANCELACION_solicitante CHECK (solicitada_por IN ('Paciente','Doctor','Recepcionista','Sistema')),
CONSTRAINT CK_CANCELACION_estado CHECK (estado IN ('Pendiente','Aprobada','Rechazada')),
CONSTRAINT CK_CANCELACION_porcentaje CHECK (porcentaje_devolucion IN (0,50,100)),
CONSTRAINT CK_CANCELACION_monto CHECK (monto_devuelto >= 0)
);
GO

--Medicamentos (inventario de farmacia)
CREATE TABLE MEDICAMENTO (
id_medicamento INT IDENTITY(1,1) PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
presentacion VARCHAR(50) NOT NULL,
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
fecha DATETIME NOT NULL DEFAULT GETDATE(),
diagnostico VARCHAR(500) NOT NULL,
tratamiento VARCHAR(500) NULL,
observaciones VARCHAR(500) NULL,
CONSTRAINT UQ_RECETA_cita UNIQUE (folio_cita),
CONSTRAINT FK_RECETA_CITA FOREIGN KEY (folio_cita) REFERENCES CITA (folio_cita)
);
GO

--Medicamentos recetados
CREATE TABLE RECETA_MEDICAMENTO (
folio_receta INT NOT NULL,
id_medicamento INT NOT NULL,
dosis VARCHAR(100) NOT NULL,
PRIMARY KEY (folio_receta, id_medicamento),
CONSTRAINT FK_RM_RECETA FOREIGN KEY (folio_receta) REFERENCES RECETA (folio_receta),
CONSTRAINT FK_RM_MEDICAMENTO FOREIGN KEY (id_medicamento) REFERENCES MEDICAMENTO (id_medicamento)
);
GO

--Servicios extras (inyeccion, vacuna, curacion...)
CREATE TABLE SERVICIO (
id_servicio INT IDENTITY(1,1) PRIMARY KEY,
nombre VARCHAR(80) NOT NULL,
precio DECIMAL(10,2) NOT NULL,
CONSTRAINT UQ_SERVICIO_nombre UNIQUE (nombre),
CONSTRAINT CK_SERVICIO_precio CHECK (precio > 0)
);
GO

--Ticket de cobro de medicamentos y servicios (el cliente no necesita ser paciente)
CREATE TABLE VENTA (
id_venta INT IDENTITY(1,1) PRIMARY KEY,
fecha DATETIME NOT NULL DEFAULT GETDATE(),
num_empleado INT NOT NULL,
id_paciente INT NULL,
nombre_cliente VARCHAR(120) NULL,
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
fecha_mov DATETIME NOT NULL DEFAULT GETDATE(),
estatus_cita VARCHAR(30) NOT NULL,
fecha_cita DATE NOT NULL,
id_especialidad INT NOT NULL,
costo DECIMAL(10,2) NOT NULL,
politica_cancela VARCHAR(50) NULL,
monto_devuelto DECIMAL(10,2) NULL,
CONSTRAINT FK_BEC_CITA FOREIGN KEY (folio_cita) REFERENCES CITA (folio_cita),
CONSTRAINT FK_BEC_ESPECIALIDAD FOREIGN KEY (id_especialidad) REFERENCES ESPECIALIDAD (id_especialidad)
);
GO

--Bitacora del historial de citas medico-paciente (solo consulta e insercion)
CREATE TABLE BITACORA_HISTORIAL_CITA (
id_historial INT IDENTITY(1,1) PRIMARY KEY,
usuario VARCHAR(50) NOT NULL,
maquina_ip VARCHAR(50) NULL,
fecha_mov DATETIME NOT NULL DEFAULT GETDATE(),
folio_cita INT NOT NULL,
fecha_cita DATE NOT NULL,
hora_cita TIME NOT NULL,
id_paciente INT NOT NULL,
folio_receta INT NULL,
id_doctor INT NOT NULL,
estatus_consulta VARCHAR(15) NOT NULL,
especialidad VARCHAR(60) NOT NULL,
consultorio VARCHAR(10) NOT NULL,
CONSTRAINT CK_BITACORA_estatus CHECK (estatus_consulta IN ('Atendida','No acudio')),
CONSTRAINT FK_BHC_CITA FOREIGN KEY (folio_cita) REFERENCES CITA (folio_cita),
CONSTRAINT FK_BHC_PACIENTE FOREIGN KEY (id_paciente) REFERENCES PACIENTE (id_paciente),
CONSTRAINT FK_BHC_DOCTOR FOREIGN KEY (id_doctor) REFERENCES DOCTOR (num_empleado),
CONSTRAINT FK_BHC_RECETA FOREIGN KEY (folio_receta) REFERENCES RECETA (folio_receta)
);
GO

--Datos iniciales: especialidades (costos de ejemplo)
INSERT INTO ESPECIALIDAD (nombre, costo_consulta) VALUES
('Cardiología', 900),
('Dermatología', 750),
('Ginecología', 800),
('Medicina General', 400),
('Nefrología', 950),
('Nutriología', 600),
('Oftalmología', 800),
('Oncología', 1200),
('Ortopedia', 850),
('Pediatría', 650);
GO

--Datos iniciales: servicios extras (precios de ejemplo)
INSERT INTO SERVICIO (nombre, precio) VALUES
('Inyección', 80),
('Vacuna', 150),
('Curación', 250),
('Estudio de sangre', 350);
GO

--Usuario administrador inicial
INSERT INTO USUARIO (username, contrasena, rol) VALUES
('admin', 'Admin2026!', 'Admin');
GO
