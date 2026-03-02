USE ABSystemsTest; 
GO

-- PUNTO 1: Corrección del horario en Transaccion_Examenes
UPDATE T
SET T.horario = M.horario
FROM Transaccion_Examenes T
INNER JOIN Catalogo_Materias M ON T.id_materias = M.id_materias;
GO

-- PUNTO 2: Actualización estatus de usuarios inactivos por más de 1 año
UPDATE Catalogo_Usuarios
SET estatus = 0
WHERE ultima_conexion <= DATEADD(YEAR, -1, GETDATE());
GO

-- PUNTO 3: Nuevo campo de nota mínima en Catalogo_Materias
ALTER TABLE Catalogo_Materias
ADD nota_minima DECIMAL(5,2) CHECK (nota_minima >= 0 AND nota_minima <= 100);
GO

-- PUNTO 6: Reinicio de contraseñas inseguras
UPDATE Catalogo_Usuarios
SET contrasena = ''
WHERE LEN(contrasena) < 8 
   OR contrasena NOT LIKE '%[A-Z]%' COLLATE Latin1_General_CS_AS
   OR contrasena NOT LIKE '%[a-z]%' COLLATE Latin1_General_CS_AS
   OR contrasena NOT LIKE '%[0-9]%';
GO

-- PUNTO 7: Corrección id_usuario en Transaccion_Examenes
UPDATE TE
SET TE.id_usuario = CE.id_usuarios
FROM Transaccion_Examenes TE
INNER JOIN Catalogo_Estudiantes CE ON TE.id_estudiantes = CE.id_estudiantes
WHERE TE.id_usuario <> CE.id_usuarios;
GO

-- PUNTO 4: Estudiantes de enero 2025 que aprobaron todo en 2025 y 2026
SELECT DISTINCT CE.nombres, CE.apellidos, CE.curp, CE.email
FROM Catalogo_Estudiantes CE
JOIN Transaccion_Examenes TE ON CE.id_estudiantes = TE.id_estudiantes
WHERE YEAR(TE.fecha) = 2025 AND MONTH(TE.fecha) = 1
  AND NOT EXISTS (
      SELECT 1 
      FROM Transaccion_Examenes TE2
      JOIN Catalogo_Materias M2 ON TE2.id_materias = M2.id_materias
      WHERE TE2.id_estudiantes = CE.id_estudiantes
        AND YEAR(TE2.fecha) IN (2025, 2026)
        AND (TE2.estatus IN ('perdido', 'pendiente') OR TE2.calificacion < M2.nota_minima)
  );
GO

-- PUNTO 5: Materias con menos de 50% de aprobación en septiembre 2025
SELECT M.nombre_materia,
       COUNT(*) AS Total_Examenes_Presentados,
       SUM(CASE WHEN TE.estatus = 'finalizado' AND TE.calificacion >= M.nota_minima THEN 1 ELSE 0 END) AS Total_Aprobados,
       (SUM(CASE WHEN TE.estatus = 'finalizado' AND TE.calificacion >= M.nota_minima THEN 1.0 ELSE 0.0 END) / COUNT(*)) * 100 AS Porcentaje_Aprobacion
FROM Transaccion_Examenes TE
JOIN Catalogo_Materias M ON TE.id_materias = M.id_materias
WHERE YEAR(TE.fecha) = 2025 AND MONTH(TE.fecha) = 9
GROUP BY M.id_materias, M.nombre_materia
HAVING ((SUM(CASE WHEN TE.estatus = 'finalizado' AND TE.calificacion >= M.nota_minima THEN 1.0 ELSE 0.0 END) / COUNT(*)) * 100) < 50;
GO

-- PUNTO 8: Segundo usuario con más exámenes aprobados en 2025
SELECT U.usuario, 
       COUNT(*) AS Examenes_Aprobados
FROM Transaccion_Examenes TE
JOIN Catalogo_Usuarios U ON TE.id_usuario = U.id_usuarios
JOIN Catalogo_Materias M ON TE.id_materias = M.id_materias
WHERE YEAR(TE.fecha) = 2025 
  AND TE.estatus = 'finalizado' AND TE.calificacion >= M.nota_minima
GROUP BY U.id_usuarios, U.usuario
ORDER BY Examenes_Aprobados DESC
OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;
GO

-- PUNTO 9: Promedio de exámenes perdidos por materia
WITH ConteoPerdidos AS (
    SELECT M.nombre_materia, 
           SUM(CASE WHEN TE.estatus = 'perdido' THEN 1 ELSE 0 END) AS Total_Perdidos
    FROM Catalogo_Materias M
    LEFT JOIN Transaccion_Examenes TE ON M.id_materias = TE.id_materias
    GROUP BY M.id_materias, M.nombre_materia
)
SELECT AVG(Total_Perdidos) AS Promedio_General_Perdidos_Por_Materia
FROM ConteoPerdidos;
GO

-- PUNTO 10: Exámenes pendientes de alumnos que no han presentado nada
SELECT COUNT(*) AS Cantidad_Examenes_Pendientes
FROM Transaccion_Examenes
WHERE estatus = 'pendiente'
  AND id_estudiantes NOT IN (
      SELECT id_estudiantes 
      FROM Transaccion_Examenes 
      WHERE estatus IN ('finalizado', 'perdido')
  );
GO

-- PUNTO 11: Información de materias que están pendientes
SELECT M.nombre_materia,
       COUNT(DISTINCT TE.id_estudiantes) AS Estudiantes_Inscritos,
       SUM(CASE WHEN TE.estatus = 'finalizado' AND TE.calificacion >= M.nota_minima THEN 1 ELSE 0 END) AS Total_Aprobados,
       (SUM(CASE WHEN TE.estatus = 'finalizado' AND TE.calificacion >= M.nota_minima THEN 1.0 ELSE 0.0 END) / NULLIF(COUNT(TE.id_examenes), 0)) * 100 AS Porcentaje_Aprobacion
FROM Transaccion_Examenes TE
JOIN Catalogo_Materias M ON TE.id_materias = M.id_materias
WHERE M.id_materias IN (SELECT DISTINCT id_materias FROM Transaccion_Examenes WHERE estatus = 'pendiente')
GROUP BY M.id_materias, M.nombre_materia;
GO