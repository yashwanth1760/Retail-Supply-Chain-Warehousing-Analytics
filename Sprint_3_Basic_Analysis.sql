use retail_supply_chain;

-- 1. What is the total number of warehouses?
select count(warehouse_id) as count_of_warehouses from warehouses;

-- 2. What is the total number of purchase orders?
select count(po_id) as total_PO from purchase_orders;

-- 3. What is the total number of shipments?
select count(shipment_id) as total_Shipments from shipments;

-- 4. What are the different product categories ordered?
select distinct product_category from purchase_orders;

-- 5. How many staff members are currently active?
select count(staff_id) as active_staff_members from staff where is_active = "Yes";

-- 6. What are the different vehicle types in the fleet?

select distinct vehicle_type from vehicles;

-- 7. What is the total cost of all purchase orders?

select sum(total_cost) as total_cost_of_orders from purchase_orders;

-- 8. What is the average quantity ordered per purchase order?

select avg(quantity_ordered) as avg_qty_per_po
from purchase_orders;

