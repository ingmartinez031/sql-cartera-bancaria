# 🏦 Análisis de Cartera de Préstamos Bancarios

Proyecto de análisis de datos orientado al sector financiero, diseñado para evaluar el comportamiento, riesgo y distribución de una cartera de préstamos bancarios mediante consultas SQL avanzadas.

---

## 🎯 Objetivo

Diseñar una base de datos relacional que simule la cartera de préstamos de una institución bancaria y extraer indicadores clave de riesgo, mora y rendimiento por sucursal, útiles para la toma de decisiones en áreas como Riesgos, Negocios y Gestión Humana.

---

## 🧠 Habilidades demostradas

- **DDL:** Creación de tablas con claves primarias, foráneas y tipos de datos correctos
- **DML:** SELECT con JOINs, GROUP BY, HAVING, CASE WHEN y subconsultas
- **Vistas:** `CREATE VIEW` para alimentar herramientas de Business Intelligence
- **Optimización:** Creación de índices estratégicos para consultas de alto volumen
- **Modelado relacional:** Diseño normalizado (3FN) de base de datos bancaria

---

## 📐 Modelo de Datos

```
Clientes ──< Prestamos >── Sucursales
                │
              Pagos
```

| Tabla        | Descripción                                       |
|--------------|---------------------------------------------------|
| `Clientes`   | Datos personales y segmento del cliente           |
| `Sucursales` | Información geográfica de cada oficina bancaria   |
| `Prestamos`  | Cartera activa: monto, tasa, estado, días de mora |
| `Pagos`      | Historial de cuotas y prepagos realizados         |

---

## 📊 Consultas desarrolladas

| # | Consulta | Descripción |
|---|----------|-------------|
| 1 | Resumen general de cartera | Total préstamos, montos, tasas y conteo por estado |
| 2 | Tasa de mora por tipo de préstamo | Identifica qué productos tienen mayor incumplimiento |
| 3 | Cartera por sucursal | Compara el desempeño entre oficinas |
| 4 | Clientes en riesgo | TOP 10 deudores con mayor saldo en mora |
| 5 | Análisis de pagos vs cuotas | Detecta brechas entre pagos esperados y recibidos |
| 6 | Segmentación por monto | Clasifica la cartera en Micro, Pequeño, Mediano y Grande |
| 7 | Evolución mensual de desembolsos | Tendencia histórica de créditos otorgados |
| 8 | Vista para Power BI | `CREATE VIEW` con joins y columnas calculadas |

---

## 💡 Fragmento destacado

```sql
-- Tasa de mora por tipo de préstamo
SELECT
    tipo_prestamo,
    COUNT(*) AS total,
    SUM(CASE WHEN estado = 'En mora' THEN 1 ELSE 0 END) AS en_mora,
    ROUND(
        SUM(CASE WHEN estado = 'En mora' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2
    ) AS tasa_mora_pct
FROM Prestamos
GROUP BY tipo_prestamo
ORDER BY tasa_mora_pct DESC;
```

---

## 🛠️ Herramientas

- **Lenguaje:** SQL (compatible con SQL Server y MySQL)
- **Entorno:** DBeaver / SQL Server Management Studio
- **Datos de prueba:** `datos_bancarios.xlsx` (incluido, sin información sensible)
- **Integración:** Vista `vw_dashboard_prestamos` conectada a Power BI

---

## 📂 Archivos del repositorio

```
📁 sql-cartera-bancaria/
├── proyecto_sql_cartera_bancaria.sql   ← Script principal
├── datos_bancarios.xlsx                ← Datos de prueba
└── README.md
```

---

## 👨‍💻 Autor

# Richard Martinez

💻 # Ingeniero en Software / Analista de Datos  
📊 Power BI | SQL | Python | Excel

## 🌐 Conecta conmigo

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Richard%20Martinez-blue?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/ing-martinez-057b6b181/)

[![GitHub](https://img.shields.io/badge/GitHub-ingmartinez031-black?style=for-the-badge&logo=github)](https://github.com/ingmartinez031)
---

> 📌 Proyecto académico desarrollado como parte del portafolio de análisis de datos. Los datos utilizados son ficticios y no contienen información comprometida.
