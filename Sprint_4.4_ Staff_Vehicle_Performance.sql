USE retail_supply_chain;

-- =============================================================================
-- Query 1: Staff Workload Distribution
-- Business Insight: Analyzes overall shipment volume and total distance 
--                   covered by each staff member.
-- =============================================================================

SELECT 
    s.staff_id,
    s.staff_name,
    s.employment_type,
    COUNT(sh.shipment_id)         AS total_shipments_handled,
    ROUND(SUM(sh.distance_km), 2) AS total_distance_covered_km
FROM staff s
LEFT JOIN shipments sh 
    ON s.staff_id = sh.staff_id
GROUP BY 
    s.staff_id, 
    s.staff_name, 
    s.employment_type
ORDER BY total_shipments_handled DESC;


-- =============================================================================
-- Query 2: Staff Performance Breakdown by Shipment Status
-- Business Insight: Compares how individual staff members perform across 
--                   different final shipment outcomes.
-- =============================================================================

SELECT 
    s.staff_id,
    s.staff_name,
    COUNT(sh.shipment_id)                                                                     AS total_shipments,
    SUM(CASE WHEN sh.status = 'Delivered' THEN 1 ELSE 0 END)                                  AS delivered_count,
    SUM(CASE WHEN sh.status = 'Delayed' THEN 1 ELSE 0 END)                                    AS delayed_count,
    ROUND((SUM(CASE WHEN sh.status = 'Delivered' THEN 1 ELSE 0 END) * 100.0 / 
        NULLIF(COUNT(sh.shipment_id), 0)), 2)                                                 AS success_rate_pct
FROM staff s
JOIN shipments sh 
    ON s.staff_id = sh.staff_id
GROUP BY 
    s.staff_id, 
    s.staff_name
ORDER BY success_rate_pct DESC;


-- =============================================================================
-- Query 3: Transit Duration & Attempt Metrics per Staff Member
-- Business Insight: Measures efficiency by evaluating average transit time 
--                   and delivery attempts per staff member.
-- =============================================================================

SELECT 
    s.staff_id,
    s.staff_name,
    s.rating                               AS staff_rating,
    COUNT(sh.shipment_id)                  AS completed_shipments,
    ROUND(AVG(sh.transit_duration_hrs), 2) AS avg_transit_hrs
FROM staff s
JOIN shipments sh 
    ON s.staff_id = sh.staff_id
WHERE sh.status = 'Delivered'
GROUP BY 
    s.staff_id, 
    s.staff_name, 
    s.rating
ORDER BY avg_transit_hrs ASC;


-- =============================================================================
-- Query 4: Vehicle Usage & Operational Load by Vehicle Type
-- Business Insight: Compares fleet utilization across different vehicle types, 
--                   including distance logged and average payload handled.
-- =============================================================================

SELECT 
    v.vehicle_type,
    COUNT(DISTINCT v.vehicle_id)       AS active_vehicle_count,
    COUNT(sh.shipment_id)              AS total_trips,
    ROUND(SUM(sh.distance_km), 2)      AS total_distance_km,
    ROUND(AVG(sh.distance_km), 2)      AS avg_distance_per_trip,
    ROUND(AVG(po.quantity_ordered), 2) AS avg_load_units
FROM vehicles v
JOIN shipments sh 
    ON v.vehicle_id = sh.vehicle_id
JOIN purchase_orders po 
    ON sh.po_id = po.po_id
WHERE v.is_active = 'Yes'
GROUP BY v.vehicle_type
ORDER BY total_trips DESC;


-- =============================================================================
-- Query 5: Shipment Performance & Reliability by Vehicle
-- Business Insight: Evaluates individual vehicle reliability, tracking average 
--                   transit times and issue rates against payload limits.
-- =============================================================================

SELECT 
    v.vehicle_id,
    v.vehicle_type,
    v.fuel_type,
    v.max_payload_kg,
    COUNT(sh.shipment_id)                                                                     AS total_shipments,
    ROUND(AVG(sh.transit_duration_hrs), 2)                                                   AS avg_transit_duration_hrs,
    SUM(CASE WHEN sh.status != 'Delivered' THEN 1 ELSE 0 END)                                 AS total_issues,
    ROUND((SUM(CASE WHEN sh.status != 'Delivered' THEN 1 ELSE 0 END) * 100.0 / 
        COUNT(sh.shipment_id)), 2)                                                            AS issue_rate_pct
FROM vehicles v
JOIN shipments sh 
    ON v.vehicle_id = sh.vehicle_id
GROUP BY 
    v.vehicle_id, 
    v.vehicle_type, 
    v.fuel_type, 
    v.max_payload_kg
ORDER BY total_shipments DESC;