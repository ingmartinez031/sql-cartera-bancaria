-- ============================================================
-- PROYECTO: Análisis de Cartera de Préstamos Bancarios
-- Autor: [Tu Nombre]
-- Descripción: Sistema de análisis crediticio para entidad bancaria
-- ============================================================

-- ============================================================
-- 1. CREACIÓN DE BASE DE DATOS Y TABLAS
-- ============================================================

CREATE DATABASE IF NOT EXISTS cartera_bancaria;
USE cartera_bancaria;

-- Tabla de Sucursales
CREATE TABLE Sucursales (
    sucursal_id     INT PRIMARY KEY AUTO_INCREMENT,
    nombre          VARCHAR(100) NOT NULL,
    ciudad          VARCHAR(50)  NOT NULL,
    region          VARCHAR(50)  NOT NULL
);

-- Tabla de Clientes
CREATE TABLE Clientes (
    cliente_id      INT PRIMARY KEY AUTO_INCREMENT,
    nombre          VARCHAR(100) NOT NULL,
    cedula          VARCHAR(20)  UNIQUE NOT NULL,
    telefono        VARCHAR(20),
    email           VARCHAR(100),
    fecha_registro  DATE         NOT NULL,
    segmento        ENUM('Personal','PYME','Corporativo') DEFAULT 'Personal'
);

-- Tabla de Préstamos
CREATE TABLE Prestamos (
    prestamo_id         INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id          INT          NOT NULL,
    sucursal_id         INT          NOT NULL,
    tipo_prestamo       ENUM('Hipotecario','Vehicular','Personal','Comercial') NOT NULL,
    monto_original      DECIMAL(15,2) NOT NULL,
    saldo_pendiente     DECIMAL(15,2) NOT NULL,
    tasa_interes        DECIMAL(5,2)  NOT NULL,  -- porcentaje anual
    fecha_desembolso    DATE          NOT NULL,
    fecha_vencimiento   DATE          NOT NULL,
    dias_mora           INT           DEFAULT 0,
    estado              ENUM('Al día','En mora','Vencido','Cancelado') DEFAULT 'Al día',
    nivel_riesgo        ENUM('Bajo','Medio','Alto') DEFAULT 'Bajo',
    FOREIGN KEY (cliente_id)  REFERENCES Clientes(cliente_id),
    FOREIGN KEY (sucursal_id) REFERENCES Sucursales(sucursal_id)
);

-- Tabla de Transacciones
CREATE TABLE Transacciones (
    transaccion_id  INT PRIMARY KEY AUTO_INCREMENT,
    prestamo_id     INT           NOT NULL,
    fecha           DATE          NOT NULL,
    tipo            ENUM('Pago cuota','Pago mora','Desembolso','Prepago') NOT NULL,
    monto           DECIMAL(15,2) NOT NULL,
    descripcion     VARCHAR(200),
    FOREIGN KEY (prestamo_id) REFERENCES Prestamos(prestamo_id)
);

-- ============================================================
-- 2. ÍNDICES DE OPTIMIZACIÓN
-- ============================================================

CREATE INDEX idx_prestamos_estado      ON Prestamos(estado);
CREATE INDEX idx_prestamos_cliente     ON Prestamos(cliente_id);
CREATE INDEX idx_prestamos_sucursal    ON Prestamos(sucursal_id);
CREATE INDEX idx_transacciones_fecha   ON Transacciones(fecha);
CREATE INDEX idx_clientes_segmento     ON Clientes(segmento);

-- ============================================================
-- 3. INSERCIÓN DE DATOS DE MUESTRA
-- ============================================================

-- Sucursales
INSERT INTO Sucursales (nombre, ciudad, region) VALUES
('Sucursal Centro',       'Santo Domingo', 'Ozama'),
('Sucursal Norte',        'Santiago',      'Cibao Norte'),
('Sucursal Este',         'La Romana',     'Este'),
('Sucursal Sur',          'San Cristóbal', 'Valdesia'),
('Sucursal La Vega',      'La Vega',       'Cibao Sur');

-- Clientes
INSERT INTO Clientes (nombre, cedula, telefono, email, fecha_registro, segmento) VALUES
('Carlos Martínez',    '001-1234567-8', '809-555-0101', 'carlos@email.com',   '2021-03-15', 'Personal'),
('María López',        '001-2345678-9', '809-555-0102', 'maria@email.com',    '2020-07-22', 'Personal'),
('Empresa ABC SRL',    '130-0000001-0', '809-555-0103', 'abc@empresa.com',    '2019-11-10', 'PYME'),
('Juan Rodríguez',     '001-3456789-0', '809-555-0104', 'juan@email.com',     '2022-01-05', 'Personal'),
('Ana Fernández',      '001-4567890-1', '809-555-0105', 'ana@email.com',      '2021-08-30', 'Personal'),
('Inversiones XYZ',   '130-0000002-1', '809-555-0106', 'xyz@inversa.com',    '2018-05-12', 'Corporativo'),
('Pedro Sánchez',      '001-5678901-2', '809-555-0107', 'pedro@email.com',   '2023-02-14', 'Personal'),
('Luisa Gómez',        '001-6789012-3', '809-555-0108', 'luisa@email.com',    '2020-09-01', 'Personal'),
('Negocios del Norte', '130-0000003-2', '809-555-0109', 'norte@neg.com',      '2017-12-20', 'PYME'),
('Roberto Díaz',       '001-7890123-4', '809-555-0110', 'roberto@email.com',  '2022-06-18', 'Personal');

-- Préstamos (25 registros)
INSERT INTO Prestamos (cliente_id, sucursal_id, tipo_prestamo, monto_original, saldo_pendiente, tasa_interes, fecha_desembolso, fecha_vencimiento, dias_mora, estado, nivel_riesgo) VALUES
(1,  1, 'Hipotecario', 3500000.00, 3200000.00,  9.50, '2022-01-10', '2042-01-10',   0, 'Al día',   'Bajo'),
(2,  2, 'Personal',     150000.00,   85000.00, 18.00, '2021-06-15', '2024-06-15',   0, 'Al día',   'Bajo'),
(3,  1, 'Comercial',   2000000.00, 1750000.00, 12.00, '2020-03-01', '2025-03-01',  45, 'En mora',  'Medio'),
(4,  3, 'Vehicular',    600000.00,  420000.00, 14.50, '2021-09-20', '2026-09-20',   0, 'Al día',   'Bajo'),
(5,  2, 'Personal',     200000.00,  190000.00, 20.00, '2023-01-05', '2025-01-05',  90, 'En mora',  'Alto'),
(6,  1, 'Comercial',   5000000.00, 4800000.00, 10.50, '2019-07-01', '2029-07-01',   0, 'Al día',   'Bajo'),
(7,  4, 'Personal',      80000.00,   30000.00, 22.00, '2022-05-10', '2024-05-10', 120, 'Vencido',  'Alto'),
(8,  5, 'Hipotecario', 1800000.00, 1650000.00,  9.75, '2021-11-25', '2041-11-25',   0, 'Al día',   'Bajo'),
(9,  2, 'Comercial',   1200000.00,  980000.00, 13.00, '2020-08-15', '2025-08-15',  30, 'En mora',  'Medio'),
(10, 3, 'Vehicular',    450000.00,  310000.00, 15.00, '2022-02-28', '2027-02-28',   0, 'Al día',   'Bajo'),
(1,  1, 'Personal',     100000.00,   55000.00, 19.00, '2023-03-10', '2025-03-10',   0, 'Al día',   'Bajo'),
(2,  2, 'Vehicular',    380000.00,  290000.00, 14.00, '2022-07-01', '2027-07-01',  15, 'En mora',  'Medio'),
(3,  1, 'Hipotecario', 4200000.00, 4000000.00,  9.25, '2021-04-15', '2041-04-15',   0, 'Al día',   'Bajo'),
(4,  3, 'Personal',     120000.00,   45000.00, 21.00, '2021-10-20', '2023-10-20', 200, 'Vencido',  'Alto'),
(5,  2, 'Comercial',    750000.00,  600000.00, 13.50, '2022-12-01', '2027-12-01',   0, 'Al día',   'Bajo'),
(6,  1, 'Hipotecario', 8000000.00, 7500000.00,  8.75, '2018-06-10', '2038-06-10',   0, 'Al día',   'Bajo'),
(7,  4, 'Vehicular',    280000.00,  150000.00, 16.00, '2021-08-05', '2026-08-05',  60, 'En mora',  'Medio'),
(8,  5, 'Personal',      95000.00,   40000.00, 20.50, '2022-09-15', '2024-09-15',   0, 'Al día',   'Bajo'),
(9,  2, 'Hipotecario', 2500000.00, 2300000.00,  9.00, '2020-01-20', '2040-01-20',   0, 'Al día',   'Bajo'),
(10, 3, 'Personal',     175000.00,  140000.00, 18.50, '2023-04-01', '2025-04-01',  75, 'En mora',  'Alto'),
(1,  1, 'Comercial',    900000.00,  870000.00, 12.50, '2023-06-15', '2028-06-15',   0, 'Al día',   'Bajo'),
(2,  2, 'Personal',      60000.00,       0.00, 19.00, '2021-01-10', '2023-01-10',   0, 'Cancelado','Bajo'),
(3,  1, 'Vehicular',    520000.00,  350000.00, 15.50, '2022-03-20', '2027-03-20',   0, 'Al día',   'Bajo'),
(4,  3, 'Comercial',   1600000.00, 1450000.00, 11.50, '2021-05-01', '2026-05-01',  20, 'En mora',  'Medio'),
(5,  2, 'Hipotecario', 2200000.00, 2100000.00,  9.80, '2022-10-10', '2042-10-10',   0, 'Al día',   'Bajo');

-- Transacciones (50 registros)
INSERT INTO Transacciones (prestamo_id, fecha, tipo, monto, descripcion) VALUES
(1,  '2024-01-05', 'Pago cuota',  28500.00, 'Cuota enero 2024'),
(1,  '2024-02-05', 'Pago cuota',  28500.00, 'Cuota febrero 2024'),
(2,  '2024-01-15', 'Pago cuota',   5200.00, 'Cuota enero 2024'),
(3,  '2023-12-01', 'Pago cuota',  22000.00, 'Cuota diciembre 2023'),
(3,  '2024-01-20', 'Pago mora',    3300.00, 'Recargo por mora enero'),
(4,  '2024-01-20', 'Pago cuota',   9800.00, 'Cuota enero 2024'),
(4,  '2024-02-20', 'Pago cuota',   9800.00, 'Cuota febrero 2024'),
(5,  '2023-11-05', 'Pago cuota',   6500.00, 'Último pago registrado'),
(6,  '2024-01-01', 'Pago cuota',  75000.00, 'Cuota enero 2024'),
(6,  '2024-02-01', 'Pago cuota',  75000.00, 'Cuota febrero 2024'),
(7,  '2023-09-10', 'Pago cuota',   2800.00, 'Último pago registrado'),
(8,  '2024-01-25', 'Pago cuota',  18200.00, 'Cuota enero 2024'),
(8,  '2024-02-25', 'Pago cuota',  18200.00, 'Cuota febrero 2024'),
(9,  '2024-01-15', 'Pago cuota',  15500.00, 'Pago parcial enero'),
(9,  '2024-01-15', 'Pago mora',    1860.00, 'Recargo mora enero'),
(10, '2024-01-28', 'Pago cuota',   7200.00, 'Cuota enero 2024'),
(10, '2024-02-28', 'Pago cuota',   7200.00, 'Cuota febrero 2024'),
(11, '2024-01-10', 'Pago cuota',   4100.00, 'Cuota enero 2024'),
(12, '2024-01-01', 'Pago cuota',   6300.00, 'Cuota enero 2024'),
(12, '2024-01-01', 'Pago mora',     630.00, 'Recargo mora'),
(13, '2024-01-15', 'Pago cuota',  38500.00, 'Cuota enero 2024'),
(13, '2024-02-15', 'Pago cuota',  38500.00, 'Cuota febrero 2024'),
(14, '2023-07-20', 'Pago cuota',   4200.00, 'Último pago registrado'),
(15, '2024-01-01', 'Pago cuota',  12500.00, 'Cuota enero 2024'),
(15, '2024-02-01', 'Pago cuota',  12500.00, 'Cuota febrero 2024'),
(16, '2024-01-10', 'Pago cuota',  90000.00, 'Cuota enero 2024'),
(16, '2024-02-10', 'Pago cuota',  90000.00, 'Cuota febrero 2024'),
(17, '2023-12-05', 'Pago cuota',   5100.00, 'Cuota diciembre 2023'),
(17, '2024-01-05', 'Pago mora',     765.00, 'Recargo mora enero'),
(18, '2024-01-15', 'Pago cuota',   3600.00, 'Cuota enero 2024'),
(18, '2024-02-15', 'Pago cuota',   3600.00, 'Cuota febrero 2024'),
(19, '2024-01-20', 'Pago cuota',  22500.00, 'Cuota enero 2024'),
(19, '2024-02-20', 'Pago cuota',  22500.00, 'Cuota febrero 2024'),
(20, '2023-12-01', 'Pago cuota',   6800.00, 'Cuota diciembre 2023'),
(20, '2024-01-01', 'Pago mora',    1020.00, 'Recargo mora enero'),
(21, '2024-01-15', 'Pago cuota',  14200.00, 'Cuota enero 2024'),
(21, '2024-02-15', 'Pago cuota',  14200.00, 'Cuota febrero 2024'),
(22, '2023-01-10', 'Pago cuota',   3100.00, 'Cuota final - cancelado'),
(23, '2024-01-20', 'Pago cuota',   9500.00, 'Cuota enero 2024'),
(23, '2024-02-20', 'Pago cuota',   9500.00, 'Cuota febrero 2024'),
(24, '2024-01-01', 'Pago cuota',  18000.00, 'Cuota enero 2024'),
(24, '2024-01-01', 'Pago mora',    1800.00, 'Recargo mora'),
(25, '2024-01-10', 'Pago cuota',  21500.00, 'Cuota enero 2024'),
(25, '2024-02-10', 'Pago cuota',  21500.00, 'Cuota febrero 2024'),
(1,  '2024-03-05', 'Pago cuota',  28500.00, 'Cuota marzo 2024'),
(6,  '2024-03-01', 'Pago cuota',  75000.00, 'Cuota marzo 2024'),
(8,  '2024-03-25', 'Pago cuota',  18200.00, 'Cuota marzo 2024'),
(13, '2024-03-15', 'Pago cuota',  38500.00, 'Cuota marzo 2024'),
(16, '2024-03-10', 'Pago cuota',  90000.00, 'Cuota marzo 2024'),
(19, '2024-03-20', 'Pago cuota',  22500.00, 'Cuota marzo 2024');

-- ============================================================
-- 4. VISTA PARA POWER BI
-- ============================================================

CREATE OR REPLACE VIEW vw_resumen_cartera AS
SELECT
    p.prestamo_id,
    c.nombre          AS cliente,
    c.segmento,
    s.nombre          AS sucursal,
    s.region,
    p.tipo_prestamo,
    p.monto_original,
    p.saldo_pendiente,
    p.tasa_interes,
    p.fecha_desembolso,
    p.fecha_vencimiento,
    p.dias_mora,
    p.estado,
    p.nivel_riesgo,
    ROUND((p.saldo_pendiente / p.monto_original) * 100, 2) AS pct_saldo_restante
FROM Prestamos p
JOIN Clientes   c ON p.cliente_id  = c.cliente_id
JOIN Sucursales s ON p.sucursal_id = s.sucursal_id;

-- ============================================================
-- 5. CONSULTAS DE ANÁLISIS
-- ============================================================

-- 1. Tasa de mora por sucursal
SELECT
    s.nombre AS sucursal,
    COUNT(*) AS total_prestamos,
    SUM(CASE WHEN p.estado IN ('En mora','Vencido') THEN 1 ELSE 0 END) AS prestamos_mora,
    ROUND(SUM(CASE WHEN p.estado IN ('En mora','Vencido') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS tasa_mora_pct
FROM Prestamos p
JOIN Sucursales s ON p.sucursal_id = s.sucursal_id
WHERE p.estado != 'Cancelado'
GROUP BY s.nombre
ORDER BY tasa_mora_pct DESC;

-- 2. Segmentación de cartera por nivel de riesgo
SELECT
    nivel_riesgo,
    COUNT(*)                        AS cantidad,
    SUM(saldo_pendiente)            AS saldo_total,
    ROUND(AVG(tasa_interes), 2)     AS tasa_promedio,
    ROUND(AVG(dias_mora), 1)        AS mora_promedio_dias
FROM Prestamos
WHERE estado != 'Cancelado'
GROUP BY nivel_riesgo
ORDER BY FIELD(nivel_riesgo, 'Alto', 'Medio', 'Bajo');

-- 3. Distribución de préstamos por tipo y estado
SELECT
    tipo_prestamo,
    estado,
    COUNT(*)             AS cantidad,
    SUM(monto_original)  AS monto_total_desembolsado,
    SUM(saldo_pendiente) AS saldo_total_pendiente
FROM Prestamos
GROUP BY tipo_prestamo, estado
ORDER BY tipo_prestamo, estado;

-- 4. Clientes con pagos vencidos (+30 días de mora)
SELECT
    c.nombre      AS cliente,
    c.segmento,
    c.telefono,
    p.tipo_prestamo,
    p.saldo_pendiente,
    p.dias_mora,
    p.estado,
    s.nombre      AS sucursal
FROM Prestamos p
JOIN Clientes   c ON p.cliente_id  = c.cliente_id
JOIN Sucursales s ON p.sucursal_id = s.sucursal_id
WHERE p.dias_mora > 30
ORDER BY p.dias_mora DESC;

-- 5. Tasa de interés promedio por tipo de préstamo
SELECT
    tipo_prestamo,
    ROUND(AVG(tasa_interes), 2) AS tasa_promedio,
    MIN(tasa_interes)           AS tasa_minima,
    MAX(tasa_interes)           AS tasa_maxima,
    COUNT(*)                    AS cantidad
FROM Prestamos
GROUP BY tipo_prestamo
ORDER BY tasa_promedio DESC;

-- 6. Evolución mensual de desembolsos
SELECT
    DATE_FORMAT(fecha_desembolso, '%Y-%m') AS mes,
    COUNT(*)                               AS prestamos_nuevos,
    SUM(monto_original)                    AS monto_desembolsado
FROM Prestamos
GROUP BY DATE_FORMAT(fecha_desembolso, '%Y-%m')
ORDER BY mes;

-- 7. Top 5 préstamos con mayor saldo pendiente
SELECT
    c.nombre AS cliente,
    p.tipo_prestamo,
    p.monto_original,
    p.saldo_pendiente,
    p.tasa_interes,
    p.estado,
    s.nombre AS sucursal
FROM Prestamos p
JOIN Clientes   c ON p.cliente_id  = c.cliente_id
JOIN Sucursales s ON p.sucursal_id = s.sucursal_id
WHERE p.estado != 'Cancelado'
ORDER BY p.saldo_pendiente DESC
LIMIT 5;

-- 8. KPIs ejecutivos de la cartera
SELECT
    COUNT(*)                                                              AS total_prestamos,
    SUM(monto_original)                                                   AS cartera_total_desembolsada,
    SUM(saldo_pendiente)                                                  AS saldo_total_vigente,
    ROUND(AVG(tasa_interes), 2)                                           AS tasa_interes_promedio,
    SUM(CASE WHEN estado IN ('En mora','Vencido') THEN 1 ELSE 0 END)     AS prestamos_en_mora,
    ROUND(
        SUM(CASE WHEN estado IN ('En mora','Vencido') THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2)                                            AS tasa_mora_global_pct,
    SUM(CASE WHEN estado IN ('En mora','Vencido') THEN saldo_pendiente ELSE 0 END) AS saldo_en_riesgo
FROM Prestamos
WHERE estado != 'Cancelado';
