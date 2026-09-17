USE retail_supply_chain;

-- =============================================================================
-- Question 1: Which suppliers have the highest rates of problematic shipments?
-- Business Insight: Identifies high-risk suppliers by analyzing fulfillment 
--                   outcomes across total orders placed.
-- =============================================================================

SELECT 
    sup.supplier_id,
    sup.supplier_name,
    COUNT(s.shipment_id)                                                                     AS total_shipments,
    SUM(CASE WHEN s.status = 'Delivered' THEN 1 ELSE 0 END)                                  AS delivered_count,
    SUM(CASE WHEN s.status = 'Delayed' THEN 1 ELSE 0 END)                                    AS delayed_count,
    SUM(CASE WHEN s.status = 'Damaged' THEN 1 ELSE 0 END)                                    AS damaged_count,
    ROUND((SUM(CASE WHEN s.status IN ('Delayed', 'Damaged') THEN 1 ELSE 0 END) * 100.0) / 
        COUNT(s.shipment_id), 2)                                                             AS problem_rate_pct
FROM suppliers sup
JOIN purchase_orders po 
    ON sup.supplier_id = po.supplier_id
JOIN shipments s 
    ON po.po_id = s.po_id
GROUP BY 
    sup.supplier_id, 
    sup.supplier_name
HAVING COUNT(s.shipment_id) >= 5
ORDER BY problem_rate_pct DESC;


-- =============================================================================
-- Question 2: How does actual transit duration compare against distance?
-- Business Insight: Evaluates transport efficiency and average transit speeds 
--                   to distinguish operational bottlenecks from physical 
--                   distance constraints.
-- =============================================================================

SELECT 
    s.status,
    COUNT(s.shipment_id)                  AS total_shipments,
    ROUND(AVG(s.distance_km), 2)          AS avg_distance_km,
    ROUND(AVG(s.transit_duration_hrs), 2) AS avg_transit_hrs
FROM shipments s
WHERE s.transit_duration_hrs IS NOT NULL
GROUP BY s.status
ORDER BY avg_transit_hrs DESC;


-- =============================================================================
-- Question 3: What is the granular breakdown of shipment status financial 
--             impact across warehouses?
-- Business Insight: Categorizes order volume alongside total financial value 
--                   tied up in delayed, damaged, or in-transit stock for 
--                   each destination warehouse.
-- =============================================================================

SELECT 
    w.warehouse_id,
    w.warehouse_name,
    COUNT(po.po_id)                                                                         AS total_orders,
    SUM(po.total_cost)                                                                      AS total_order_value,
    SUM(CASE WHEN s.status = 'Delayed' THEN po.total_cost ELSE 0 END)                       AS delayed_value,
    SUM(CASE WHEN s.status = 'Damaged' THEN po.total_cost ELSE 0 END)                       AS damaged_value,
    ROUND((SUM(CASE WHEN s.status = 'Damaged' THEN 1 ELSE 0 END) * 100.0) / 
        COUNT(s.shipment_id), 2)                                                            AS damage_rate_pct
FROM warehouses w
JOIN purchase_orders po 
    ON w.warehouse_id = po.warehouse_id
JOIN shipments s 
    ON po.po_id = s.po_id
GROUP BY 
    w.warehouse_id, 
    w.warehouse_name
ORDER BY total_orders DESC;


-- =============================================================================
-- Question 4: How is shipment fulfillment performance trending month-over-month?
-- Business Insight: Tracks historical fulfillment performance over time using 
--                   dispatch month to flag seasonal delays or operational 
--                   improvements.
-- =============================================================================

SELECT 
    DATE_FORMAT(s.dispatch_date, '%Y-%m')                                                   AS dispatch_month,
    COUNT(s.shipment_id)                                                                    AS total_dispatched,
    SUM(CASE WHEN s.status = 'Delivered' THEN 1 ELSE 0 END)                                 AS delivered_count,
    SUM(CASE WHEN s.status = 'Delayed' THEN 1 ELSE 0 END)                                   AS delayed_count,
    SUM(CASE WHEN s.status = 'Damaged' THEN 1 ELSE 0 END)                                   AS damaged_count,
    ROUND((SUM(CASE WHEN s.status = 'Delivered' THEN 1 ELSE 0 END) * 100.0) / 
        COUNT(s.shipment_id), 2)                                                            AS on_time_delivery_rate_pct
FROM shipments s
WHERE s.dispatch_date IS NOT NULL
GROUP BY DATE_FORMAT(s.dispatch_date, '%Y-%m')
ORDER BY dispatch_month ASC;


-- =============================================================================
-- Question 5: Does the number of shipment attempts impact the likelihood 
--             of damage or higher transit duration?
-- Business Insight: Measures whether repeated fulfillment attempts directly 
--                   correlate with damaged goods or disproportionate transit 
--                   delays.
-- =============================================================================

SELECT 
    s.shipment_attempt,
    COUNT(s.shipment_id)                                                                    AS total_shipments,
    ROUND(AVG(s.transit_duration_hrs), 2)                                                   AS avg_transit_duration_hrs,
    SUM(CASE WHEN s.status = 'Damaged' THEN 1 ELSE 0 END)                                   AS damaged_count,
    ROUND((SUM(CASE WHEN s.status = 'Damaged' THEN 1 ELSE 0 END) * 100.0) / 
        COUNT(s.shipment_id), 2)                                                            AS damage_rate_pct
FROM shipments s
GROUP BY s.shipment_attempt
ORDER BY s.shipment_attempt ASC;