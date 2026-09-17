USE retail_supply_chain;

-- =============================================================================
-- 1. Warehouse Order Volume & Financial Spend Summary
-- =============================================================================

SELECT 
    w.warehouse_id,
    w.warehouse_name,
    COUNT(po.po_id)              AS total_purchase_orders,
    SUM(po.total_cost)           AS total_order_cost,
    ROUND(AVG(po.total_cost), 2) AS avg_order_cost,
    SUM(po.quantity_ordered)     AS total_units_ordered
FROM warehouses w
LEFT JOIN purchase_orders po 
    ON w.warehouse_id = po.warehouse_id
GROUP BY 
    w.warehouse_id, 
    w.warehouse_name
ORDER BY total_order_cost DESC;


-- =============================================================================
-- 2. Regional Procurement Comparison
-- =============================================================================

SELECT 
    w.region,
    COUNT(DISTINCT w.warehouse_id)                                AS active_warehouses,
    COUNT(po.po_id)                                               AS total_purchase_orders,
    SUM(po.total_cost)                                            AS regional_total_cost,
    ROUND(AVG(po.total_cost), 2)                                  AS regional_avg_order_cost,
    ROUND(SUM(po.total_cost) / COUNT(DISTINCT w.warehouse_id), 2) AS avg_cost_per_warehouse
FROM warehouses w
LEFT JOIN purchase_orders po 
    ON w.warehouse_id = po.warehouse_id
GROUP BY w.region
ORDER BY regional_total_cost DESC;


-- =============================================================================
-- 3. Warehouse Type Ordering Profiles
-- =============================================================================

SELECT 
    w.warehouse_type,
    COUNT(DISTINCT w.warehouse_id) AS warehouse_count,
    COUNT(po.po_id)                AS total_orders,
    SUM(po.total_cost)             AS total_spend,
    ROUND(AVG(po.total_cost), 2)   AS avg_order_cost
FROM warehouses w
JOIN purchase_orders po 
    ON w.warehouse_id = po.warehouse_id
GROUP BY w.warehouse_type
ORDER BY total_spend DESC;


-- =============================================================================
-- 4. Monthly Ordering Patterns & Seasonality Over Time
-- =============================================================================

SELECT 
    DATE_FORMAT(po.order_date, '%Y-%m') AS order_month,
    COUNT(po.po_id)                     AS total_orders_placed,
    SUM(po.total_cost)                  AS monthly_spend,
    COUNT(DISTINCT po.warehouse_id)     AS active_ordering_warehouses,
    SUM(po.quantity_ordered)            AS total_quantity_procured
FROM purchase_orders po
GROUP BY DATE_FORMAT(po.order_date, '%Y-%m')
ORDER BY order_month ASC;


-- =============================================================================
-- 5. Top Orderers by Warehouse Type & Category
-- =============================================================================

SELECT 
    w.warehouse_type,
    w.warehouse_name,
    po.product_category,
    COUNT(po.po_id)    AS total_orders,
    SUM(po.total_cost) AS total_spend,
    RANK() OVER (
        PARTITION BY w.warehouse_type 
        ORDER BY SUM(po.total_cost) DESC
    )                  AS rank_within_type
FROM warehouses w
JOIN purchase_orders po 
    ON w.warehouse_id = po.warehouse_id
GROUP BY 
    w.warehouse_type,
    w.warehouse_name,
    po.product_category
ORDER BY 
    w.warehouse_type, 
    rank_within_type ASC;