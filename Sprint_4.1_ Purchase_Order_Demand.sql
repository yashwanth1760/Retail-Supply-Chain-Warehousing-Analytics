USE retail_supply_chain;

-- =============================================================================
-- Query 1: Demand & Spend Distribution by Warehouse & Supplier
-- =============================================================================

-- 1A: Warehouse Demand Summary
SELECT 
    w.warehouse_id,
    w.warehouse_name,
    w.city,
    COUNT(po.po_id)          AS total_orders,
    SUM(po.quantity_ordered) AS total_units_ordered,
    SUM(po.total_cost)       AS total_order_value
FROM purchase_orders po
JOIN warehouses w 
    ON po.warehouse_id = w.warehouse_id
GROUP BY 
    w.warehouse_id,
    w.warehouse_name,
    w.city
ORDER BY total_order_value DESC;

-- 1B: Top Suppliers Demand Summary
SELECT 
    s.supplier_id,
    s.supplier_name,
    s.supplier_category,
    COUNT(po.po_id)          AS total_orders,
    SUM(po.quantity_ordered) AS total_units_ordered,
    SUM(po.total_cost)       AS total_spend
FROM purchase_orders po
JOIN suppliers s 
    ON po.supplier_id = s.supplier_id
GROUP BY 
    s.supplier_id,
    s.supplier_name,
    s.supplier_category
ORDER BY total_spend DESC;


-- =============================================================================
-- Query 2: Segmentation by Supplier Category & Order Priority
-- =============================================================================

-- 2A: Demand by Supplier Category
SELECT 
    s.supplier_category,
    COUNT(po.po_id)          AS order_count,
    SUM(po.quantity_ordered) AS total_quantity,
    SUM(po.total_cost)       AS total_cost,
    AVG(po.total_cost)       AS avg_order_cost
FROM purchase_orders po
JOIN suppliers s 
    ON po.supplier_id = s.supplier_id
GROUP BY s.supplier_category
ORDER BY total_cost DESC;

-- 2B: Breakdown by Order Priority
SELECT 
    po.order_priority,
    COUNT(po.po_id)          AS order_count,
    SUM(po.quantity_ordered) AS total_quantity,
    SUM(po.total_cost)       AS total_cost,
    ROUND(AVG(po.total_cost), 2) AS avg_order_cost
FROM purchase_orders po
GROUP BY po.order_priority
ORDER BY total_cost DESC;


-- =============================================================================
-- Query 3: Monthly Order Volume & Cost Progression
-- =============================================================================

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    COUNT(po_id)                     AS monthly_order_count,
    SUM(quantity_ordered)            AS monthly_units_ordered,
    SUM(total_cost)                  AS monthly_spend,
    ROUND(AVG(total_cost), 2)        AS avg_monthly_order_cost
FROM purchase_orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month ASC;


-- =============================================================================
-- Query 4: Product Category Cost & Scale Analysis
-- =============================================================================

SELECT 
    product_category,
    COUNT(po_id)              AS total_orders,
    SUM(quantity_ordered)     AS total_units,
    SUM(total_cost)           AS total_category_spend,
    ROUND(AVG(total_cost), 2) AS avg_order_cost,
    ROUND(MIN(total_cost), 2) AS min_order_cost,
    ROUND(MAX(total_cost), 2) AS max_order_cost
FROM purchase_orders
GROUP BY product_category
ORDER BY total_category_spend DESC;


-- =============================================================================
-- Query 5: Multi-Dimensional Demand (Warehouse x Category)
-- =============================================================================

SELECT 
    w.warehouse_id,
    w.warehouse_name,
    po.product_category,
    COUNT(po.po_id)          AS total_orders,
    SUM(po.quantity_ordered) AS total_quantity,
    SUM(po.total_cost)       AS combined_spend
FROM purchase_orders po
JOIN warehouses w 
    ON po.warehouse_id = w.warehouse_id
GROUP BY 
    w.warehouse_id,
    w.warehouse_name,
    po.product_category;