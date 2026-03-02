# Resolución de Prueba Técnica - AB Systems S.A. de C.V.

**Autor:** Roberto Rojas Ochoa<br>
**Rol:** Estudiante de Ingeniería de Software UV Ixtaczoquitlán<br>
**Fecha:** 02 de marzo 2026<br>
**Tecnología Principal:** Microsoft SQL Server (T-SQL)

## Contexto del Proyecto
El presente repositorio contiene la solución a la asignación de base de datos para el sistema de inscripción de exámenes de AB Systems. El objetivo principal de estos scripts es estructurar la base de datos, corregir las inconsistencias de la información de prueba provista y generar los reportes analíticos solicitados aplicando reglas de negocio específicas.

## Entorno de Ejecución
- **Motor de Base de Datos:** SQL Server 2019 / SQL Server 2022 Express.
- **Herramienta recomendada:** SQL Server Management Studio (SSMS) o Azure Data Studio.

## Instrucciones de Despliegue
Para evaluar correctamente la solución, los scripts deben ejecutarse en el siguiente orden:

1. **`01_Creacion_Tablas.sql`**: Genera el esquema relacional (`Catalogo_Usuarios`, `Catalogo_Estudiantes`, `Catalogo_Materias`, `Transaccion_Examenes`).
2. **`02_Insercion_Datos.sql`**: Pobla las tablas con datos de prueba, incluyendo intencionalmente las inconsistencias descritas en el problema para verificar la eficacia de los scripts de limpieza.
3. **`03_Solucion_Ejercicios.sql`**: Ejecuta las operaciones DDL, DML y consultas DQL para resolver los 11 puntos requeridos.

---

## Análisis Técnico y Documentación de la Solución

A continuación, se detalla la lógica relacional y matemática implementada para resolver cada uno de los requerimientos:
> Notará que los 11 requerimientos solicitados no se presentan en estricto orden numérico. Como buena práctica de ingeniería de datos, el código y este análisis se agruparon por su naturaleza técnica en dos fases secuenciales:
> 1. **Fase de Preparación (DDL/DML):** Primero se ejecutaron todas las modificaciones estructurales y la limpieza de datos para sanear la información base.
> 2. **Fase de Análisis (DQL):** Una vez que la base de datos alcanzó la integridad deseada, se procedió a ejecutar los reportes analíticos e inteligencia de negocio, garantizando así que los cálculos se realizaran sobre datos limpios y precisos.

### A. Modificaciones Estructurales y Limpieza de Datos (DDL / DML)

* **Punto 3 (Nuevo campo de nota mínima en Catalogo_Materias):** Se utilizó la instrucción `ALTER TABLE` acompañada de un constraint `CHECK (nota_minima >= 0 AND nota_minima <= 100)` para garantizar la integridad de los datos a nivel de motor, impidiendo la inserción de calificaciones fuera de la escala permitida.
* **Punto 1 (Corrección del horario en Transaccion_Examenes):** Se implementó un `UPDATE` iterativo utilizando un `INNER JOIN` entre la tabla transaccional y el catálogo maestro de materias, permitiendo heredar y sobreescribir el horario correcto de forma masiva.
* **Punto 2 (Actualización estatus de usuarios inactivos por más de 1 año):** La lógica temporal se resolvió comparando la `ultima_conexion` contra la fecha actual del sistema (`GETDATE()`) restándole un año exacto mediante la función `DATEADD()`.
* **Punto 6 (Reinicio de contraseñas inseguras):** Se aplicaron expresiones de coincidencia de patrones (`LIKE`) para buscar la ausencia de mayúsculas, minúsculas o números (`'%[A-Z]%'`, etc.). Fue importante forzar el intercalamiento (`COLLATE Latin1_General_CS_AS`) para que SQL Server distinguiera correctamente entre mayúsculas y minúsculas (Case Sensitive).
* **Punto 7 (Corrección id_usuario en Transaccion_Examenes):** Se detectó la desincronización de llaves foráneas. Se resolvió con un `UPDATE` basado en un `JOIN` con el catálogo de estudiantes, igualando el `id_usuario` de la transacción con el ID real vinculado al estudiante.

### B. Reportes Analíticos e Inteligencia de Negocio (DQL)

* **Punto 4 (Estudiantes de enero 2025 que aprobaron todo en 2025 y 2026):** Para asegurar que el alumno no tuviera reprobaciones futuras, se utilizó una subconsulta con la cláusula `NOT EXISTS`. Esto filtra a cualquier estudiante que aunque haya presentado en enero, tenga registros con estatus 'perdido', 'pendiente' o calificación menor a la mínima aprobatoria durante 2025 y 2026.
* **Punto 5 (Materias con menos de 50% de aprobación en septiembre 2025):** Se agruparon los datos por materia (`GROUP BY`). El porcentaje se calculó utilizando la función `SUM()` con condicionales `CASE WHEN` para contar los aprobados, dividiendo este valor flotante entre el `COUNT(*)` total y filtrando con la cláusula `HAVING` para valores menores a 50%.
* **Punto 8 (Segundo usuario con más exámenes aprobados en 2025):** Para identificar este registro, se agruparon los exámenes aprobados por usuario y se ordenaron los conteos de mayor a menor (ORDER BY DESC). Posteriormente, se aplicó la cláusula de paginación OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY para omitir al primer lugar y extraer de forma exacta y optimizada el segundo registro.
* **Punto 9 (Promedio de exámenes perdidos por materia):** Se estructuró mediante una *Common Table Expression (CTE)*. Primero, la tabla temporal calcula los exámenes perdidos absolutos por materia, y la consulta principal extrae el `AVG()` (promedio general) de dicha métrica.
* **Punto 10 (Exámenes pendientes de alumnos que no han presentado nada):** Se utilizó un filtro `NOT IN` (o `NOT EXISTS`) para aislar a los estudiantes cuyo historial carece completamente de estatus 'finalizado' o 'perdido', contando únicamente sus registros 'pendientes'.
* **Punto 11 (Información de materias que están pendientes):** Se aplicaron funciones de agregación condicionales similares al punto 5. Se destacó el uso de `NULLIF(COUNT(id), 0)` en el divisor del cálculo de porcentajes para blindar la consulta contra errores matemáticos de división por cero en caso de falta de datos.

## Consideraciones de Diseño
Para simular un entorno real y tolerante a fallos de ingesta ("data sucia"), el esquema de tablas no abusa de restricciones `NOT NULL`. Esto permite que el sistema reciba la información inconsistente para ser posteriormente tratada, limpiada y analizada por estos scripts, manteniendo intacta la integridad referencial (`FOREIGN KEY`).
