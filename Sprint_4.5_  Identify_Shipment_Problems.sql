USE retail_supply_chain;

-- =============================================================================
-- Query 1: Multi-Attempt Purchase Orders & Retry Lifecycle
-- Business Insight: Tracks orders requiring multiple delivery attempts along 
--                   with initial and final status transitions.
-- =============================================================================

SELECT 
    po.po_id,
    po.order_priority,
    po.product_category,
    COUNT(s.shipment_id) AS total_attempts,
    MIN(s.status)        AS initial_status,
    MAX(s.status)        AS final_status
FROM purchase_orders po
JOIN shipments s 
    ON po.po_id = s.po_id
GROUP BY 
    po.po_id, 
    po.order_priority, 
    po.product_category
HAVING COUNT(s.shipment_id) > 1
ORDER BY total_attempts DESC;


-- =============================================================================
-- Query 2: Overall Shipment Status Distribution & Transit Metrics
-- Business Insight: Provides high-level volume breakdown, percentage distribution, 
--                   and average transit duration across all shipment statuses.
-- =============================================================================

SELECT 
    status,
    COUNT(shipment_id)                                                     AS total_shipments,
    ROUND(COUNT(shipment_id) * 100.0 / SUM(COUNT(shipment_id)) OVER(), 2)  AS pct_of_total,
    ROUND(AVG(shipment_attempt), 2)                                        AS avg_attempts,
    ROUND(AVG(transit_duration_hrs), 2)                                    AS avg_transit_hours,
    ROUND(AVG(distance_km), 2)                                             AS avg_distance_km
FROM shipments
GROUP BY status
ORDER BY total_shipments DESC;


-- =============================================================================
-- Query 3: Single vs. Multiple Attempt Performance
-- Business Insight: Evaluates delivery success and incident counts comparing 
--                   first-attempt deliveries versus retry shipments.
-- =============================================================================

SELECT 
    CASE 
        WHEN shipment_attempt = 1 THEN 'Single Attempt (1)'
        ELSE 'Multiple Attempts (2+)'
    END                                              AS attempt_category,
    COUNT(DISTINCT po_id)                            AS total_orders,
    COUNT(CASE WHEN status = 'Delivered' THEN 1 END) AS delivered_count,
    COUNT(CASE WHEN status = 'Damaged'   THEN 1 END) AS damaged_count,
    COUNT(CASE WHEN status = 'Delayed'   THEN 1 END) AS delayed_count,
    ROUND(AVG(transit_duration_hrs), 2)              AS avg_total_transit_hours
FROM shipments
GROUP BY 
    CASE 
        WHEN shipment_attempt = 1 THEN 'Single Attempt (1)'
        ELSE 'Multiple Attempts (2+)'
    END;


-- =============================================================================
-- Query 4: Problematic Receiving Warehouses
-- Business Insight: Highlights fulfillment bottleneck destination warehouses 
--                   handling high proportions of damaged or delayed stock.
-- =============================================================================

SELECT 
    w.warehouse_id,
    w.warehouse_name,
    w.region,
    COUNT(s.shipment_id)                                            AS total_received,
    COUNT(CASE WHEN s.shipment_attempt > 1 THEN 1 END)              AS multi_attempt_count,
    COUNT(CASE WHEN s.status IN ('Damaged', 'Delayed') THEN 1 END)  AS problematic_count,
    ROUND(
        COUNT(CASE WHEN s.status IN ('Damaged', 'Delayed') THEN 1 END) * 100.0 / 
        COUNT(s.shipment_id), 
        2
    )                                                               AS problem_rate_pct
FROM warehouses w
JOIN purchase_orders po 
    ON w.warehouse_id = po.warehouse_id
JOIN shipments s 
    ON po.po_id = s.po_id
GROUP BY 
    w.warehouse_id, 
    w.warehouse_name, 
    w.region
HAVING COUNT(s.shipment_id) >= 50
ORDER BY problem_rate_pct DESC;


-- =============================================================================
-- Query 5: Supplier Issue & Delay Performance
-- Business Insight: Ranks supplier reliability by measuring total issue volume 
--                   (delays + damages) against overall order counts.
-- =============================================================================

SELECT 
    sup.supplier_id,
    sup.supplier_name,
    sup.reliability_rating,
    COUNT(CASE WHEN s.status = 'Delayed' THEN 1 END)               AS delayed_pos,
    COUNT(CASE WHEN s.status = 'Damaged' THEN 1 END)               AS damaged_pos,
    COUNT(CASE WHEN s.status IN ('Delayed', 'Damaged') THEN 1 END) AS total_issue_pos,
    COUNT(CASE WHEN s.status = 'Delivered' THEN 1 END)             AS on_time_pos,
    COUNT(DISTINCT po.po_id)                                       AS total_pos,
    ROUND(
        COUNT(CASE WHEN s.status IN ('Delayed', 'Damaged') THEN 1 END) * 100.0 / 
        COUNT(DISTINCT po.po_id), 
        2
    )                                                              AS issue_rate_pct
FROM suppliers sup
JOIN purchase_orders po 
    ON sup.supplier_id = po.supplier_id
JOIN shipments s 
    ON po.po_id = s.po_id
GROUP BY 
    sup.supplier_id, 
    sup.supplier_name, 
    sup.reliability_rating
HAVING COUNT(DISTINCT po.po_id) >= 20
ORDER BY issue_rate_pct DESC;