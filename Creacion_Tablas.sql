USE ABSystemsTest;
GO

CREATE TABLE Catalogo_Usuarios (
    id_usuarios INT PRIMARY KEY,
    estatus INT,
    usuario NVARCHAR(50),
    contrasena NVARCHAR(100), 
    email NVARCHAR(100),
    creacion DATE,
    ultima_conexion DATE
);
GO

-- Tabla 2: Catalogo_Estudiantes
CREATE TABLE Catalogo_Estudiantes (
    id_estudiantes INT PRIMARY KEY,
    id_usuarios INT FOREIGN KEY REFERENCES Catalogo_Usuarios(id_usuarios),
    nombres NVARCHAR(100),
    apellidos NVARCHAR(100),
    fecha_nacimiento DATE,
    direccion NVARCHAR(255),
    sexo NVARCHAR(10),
    curp NVARCHAR(20),
    telefono NVARCHAR(20),
    email NVARCHAR(100)
);
GO

-- Tabla 3: Catalogo_Materias
CREATE TABLE Catalogo_Materias (
    id_materias INT PRIMARY KEY,
    nombre_materia NVARCHAR(100),
    horario NVARCHAR(50),
    modalidad NVARCHAR(50)
);
GO

-- Tabla 4: Transaccion_Examenes
CREATE TABLE Transaccion_Examenes (
    id_examenes INT PRIMARY KEY,
    id_usuario INT FOREIGN KEY REFERENCES Catalogo_Usuarios(id_usuarios),
    id_estudiantes INT FOREIGN KEY REFERENCES Catalogo_Estudiantes(id_estudiantes),
    id_materias INT FOREIGN KEY REFERENCES Catalogo_Materias(id_materias),
    fecha DATE,
    horario NVARCHAR(50),
    modalidad NVARCHAR(50),
    estatus NVARCHAR(50),
    calificacion DECIMAL(5,2)
);
GO