USE ABSystemsTest;
GO

-- Datos_Ejemplo anexado a la prueba
INSERT INTO Catalogo_Usuarios (id_usuarios, estatus, usuario, contrasena, email, creacion, ultima_conexion)VALUES 
(1, 1, 'test01', '1234', 'test01@gmail.com', '2025-01-01', '2026-02-01'),
(2, 1, 'test02', '4321', 'test02@gmail.com', '2025-01-01', '2026-01-01'),
(3, 1, 'test03', '2314', 'test03@gmail.com', '2025-01-01', '2026-01-15');

INSERT INTO Catalogo_Estudiantes (id_estudiantes, id_usuarios, nombres, apellidos, fecha_nacimiento, direccion, sexo, curp, telefono, email) VALUES 
(1, 1, 'test', '01', '1990-01-01', 'Av. Popular 1234', 'F', 'DRT012TSD', '1234567890', 'test01@email.com'),
(2, 2, 'test', '02', '1980-01-01', 'Av. Impopular 1234', 'M', 'TFRASE123', '1234567890', 'test02@email.com'),
(3, 3, 'test', '03', '2000-01-01', 'Av. Neutral 1234', 'M', 'TRS779RTD', '1234567890', 'test03@email.com');

INSERT INTO Catalogo_Materias (id_materias, nombre_materia, horario, modalidad) VALUES 
(1, 'Fisica', 'Mañana', 'Presencial'),
(2, 'Quimica', 'Todos', 'Todos'),
(3, 'Matematicas', 'Tarde', 'Remota');

INSERT INTO Transaccion_Examenes (id_examenes, id_usuario, id_estudiantes, id_materias, fecha, horario, modalidad, estatus, calificacion) VALUES 
(1, 1, 1, 1, '2026-02-01', 'mañana', 'presencial', 'finalizado', 100),
(3, 2, 2, 2, '2026-02-05', 'tarde', 'remoto', 'perdido', 0),
(2, 1, 1, 2, '2026-02-03', 'mañana', 'presencial', 'pendiente', NULL),
(4, 3, 3, 3, '2026-02-07', 'tarde', 'remoto', 'finalizado', 85);

-- Vacio de datos para realizar pruebas adicionales
DELETE FROM Transaccion_Examenes;
DELETE FROM Catalogo_Estudiantes;
DELETE FROM Catalogo_Usuarios;
DELETE FROM Catalogo_Materias;

-- Datos adicionales para pruebas
INSERT INTO Catalogo_Usuarios (id_usuarios, estatus, usuario, contrasena, email, creacion, ultima_conexion) VALUES
(1, 1, 'user_excelente', 'Fuerte123!', 'u1@mail.com', '2024-01-01', '2026-02-01'),
(2, 1, 'user_inactivo', 'Fuerte123!', 'u2@mail.com', '2023-01-01', '2024-05-01'),
(3, 1, 'user_inseguro1', '12345', 'u3@mail.com', '2025-01-01', '2026-02-01'), 
(4, 1, 'user_inseguro2', 'minusculas', 'u4@mail.com', '2025-01-01', '2026-02-01'),
(5, 1, 'user_normal', 'Fuerte123!', 'u5@mail.com', '2025-01-01', '2026-02-01'),
(6, 1, 'user_cerebrito', 'Fuerte123!', 'u6@mail.com', '2025-01-01', '2026-02-01'),
(7, 1, 'user_cerebrito', 'Fuerte123!', 'u6@mail.com', '2025-01-01', '2026-02-01'),
(8, 1, 'user_nuevo', 'Fuerte123!', 'u7@mail.com', '2026-01-01', '2026-02-01');

INSERT INTO Catalogo_Estudiantes (id_estudiantes, id_usuarios, nombres, apellidos, fecha_nacimiento, direccion, sexo, curp, telefono, email) VALUES
(1, 1, 'Luis', 'Gerardo', '1995-05-10', 'Calle 1', 'M', 'CURP001', '5551234', 'u1@mail.com'),
(2, 2, 'Ana', 'Gomez',  '1998-08-20', 'Calle 2', 'F', 'CURP002', '5551235', 'u2@mail.com'),
(3, 3, 'Luis', 'Ruiz',   '1999-11-30', 'Calle 3', 'M', 'CURP003', '5551236', 'u3@mail.com'),
(4, 4, 'Maria', 'Soto', '2000-02-15', 'Calle 4', 'F', 'CURP004', '5551237', 'u4@mail.com'),
(5, 5, 'Carlos', 'Vega', '1997-04-25', 'Calle 5', 'M', 'CURP005', '5551238', 'u5@mail.com'),
(6, 6, 'Diana', 'Luna',  '2001-07-05', 'Calle 6', 'F', 'CURP006', '5551239', 'u6@mail.com'),
(7, 7, 'Pedro', 'Mora',  '2002-09-12', 'Calle 7', 'M', 'CURP007', '5551240', 'u7@mail.com');

INSERT INTO Catalogo_Materias (id_materias, nombre_materia, horario, modalidad, nota_minima) VALUES
(1, 'Matematicas', 'Mañana', 'Presencial', 70),
(2, 'Fisica', 'Tarde', 'Remota', 70),
(3, 'Quimica', 'Todo', 'Todos', 80),
(4, 'Historia', 'Mañana', 'Presencial', 70);

INSERT INTO Transaccion_Examenes (id_examenes, id_usuario, id_estudiantes, id_materias, fecha, horario, modalidad, estatus, calificacion) VALUES
(1, 1, 1, 1, '2025-01-10', 'Tarde', 'Presencial', 'finalizado', 95), 
(2, 1, 1, 2, '2025-05-20', 'Tarde', 'Remota', 'finalizado', 85),
(3, 1, 1, 3, '2026-01-15', 'Todo',  'Todos', 'finalizado', 90),
(4, 2, 2, 3, '2025-09-15', 'Todo', 'Todos', 'finalizado', 40),
(5, 3, 3, 3, '2025-09-16', 'Todo', 'Todos', 'perdido',    0),
(6, 4, 4, 3, '2025-09-17', 'Todo', 'Todos', 'finalizado', 90),
(7, 2, 5, 1, '2025-10-10', 'Mañana', 'Presencial', 'finalizado', 75), 
(8,  6, 6, 1, '2025-03-01', 'Mañana', 'Presencial', 'finalizado', 100),
(9,  6, 6, 2, '2025-04-01', 'Tarde',  'Remota', 'finalizado', 100),
(10, 6, 6, 4, '2025-05-01', 'Mañana', 'Presencial', 'finalizado', 100),
(11, 2, 2, 2, '2025-11-01', 'Tarde', 'Remota', 'perdido', 0),
(12, 7, 7, 4, '2026-05-01', 'Mañana', 'Presencial', 'pendiente', NULL),
(13, 7, 7, 1, '2026-05-02', 'Mañana', 'Presencial', 'pendiente', NULL);