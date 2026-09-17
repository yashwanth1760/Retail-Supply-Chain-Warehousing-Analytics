drop database retail_supply_chain;

create database retail_supply_chain;
use retail_supply_chain;


create table suppliers(
    supplier_id varchar(10) primary key,
    supplier_name varchar(100) not null,
    city varchar(50),
    supplier_category varchar(30) not null,        
    reliability_rating decimal(3,2) default 0.0,
    contract_since date not null
);


create table staff(
    staff_id varchar(10) primary key,
    staff_name varchar(100) not null,
    hire_date date not null,
    rating decimal(3,2) default 0.0,
    employment_type varchar(30),                  
    is_active varchar(3) default 'Yes'
);


create table warehouses(
    warehouse_id varchar(10) primary key,
    warehouse_name varchar(100) not null,
    city varchar(50),
    warehouse_type varchar(20) not null,            
    storage_capacity_units int,
    region varchar(20),
    opened_date date
);


create table vehicles(
    vehicle_id varchar(10) primary key,            
    vehicle_type varchar(20) not null,
    fuel_type varchar(20),
    max_payload_kg decimal(8,2),
    depot_warehouse_id varchar(10),
    last_service_date date,                         
    is_active varchar(3) default 'Yes',
    foreign key (depot_warehouse_id)
        references warehouses(warehouse_id)
);


create table purchase_orders(
    po_id varchar(20) primary key,
    warehouse_id varchar(10) not null,
    supplier_id varchar(10) not null,
    order_date date not null,
    product_category varchar(30) not null,
    order_priority varchar(10) not null,          
    quantity_ordered int not null,
    total_cost decimal(12,2) not null,
    foreign key (warehouse_id) references warehouses(warehouse_id),
    foreign key (supplier_id) references suppliers(supplier_id)
);

create table shipments(
    shipment_id varchar(20) primary key,
    po_id varchar(20) not null,
    staff_id varchar(10) not null,
    vehicle_id varchar(10) not null,
    dispatch_date date,
    arrival_date date,
    status varchar(20) not null default 'In-Transit',
    shipment_attempt tinyint default 1,
    distance_km decimal(6,2),
    transit_duration_hrs int,
    foreign key (staff_id) references staff(staff_id),
    foreign key (vehicle_id) references vehicles(vehicle_id),
    foreign key (po_id) references purchase_orders(po_id)
);



-- IMPORT DATA INTO DATABASE