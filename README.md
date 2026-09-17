# 📊 Retail Supply Chain & Warehousing Data Analytics

![MySQL](https://img.shields.io/badge/Database-MySQL-blue?style=flat&logo=mysql)
![Domain](https://img.shields.io/badge/Domain-Supply%20Chain%20%26%20Logistics-orange)
![Focus](https://img.shields.io/badge/Focus-Data%20Analysis%20%26%20Business%20Insights-green)

An end-to-end SQL data analysis project exploring procurement spending, warehouse ordering behavior, delivery fulfillment metrics, and fleet performance for **North Peak Retail Supply Co.**[cite: 1]

---

## 📌 Business Overview

North Peak Retail Supply Co. runs a network of **30 regional warehouses** replenishing store inventory from **150 external suppliers**[cite: 1]. 

Managing a high volume of orders requires clear visibility into spend distribution, supplier reliability, and fulfillment efficiency[cite: 1]. This project uses **MySQL** to evaluate **$4.09 Billion** in total order spend across **5,000 purchase orders** and **5,800 shipment logs** to pinpoint operational bottlenecks and uncover actionable data-driven solutions[cite: 1].

---

## 🗄️ Database Architecture & Dataset Summary

The relational database (`retail_supply_chain`) connects 6 tables through primary and foreign key relationships[cite: 1]:

| Table Name | Records | Key Information Tracked |
| :--- | :--- | :--- |
| `warehouses` | 30 | Warehouse name, region, storage type, capacity[cite: 1] |
| `suppliers` | 150 | Supplier details, reliability ratings, categories[cite: 1] |
| `vehicles` | 90 | Fleet types, fuel profiles, payload capacities[cite: 1] |
| `purchase_orders` | 5,000 | Order costs, item quantities, priority levels, categories[cite: 1] |
| `shipments` | 5,800 | Transit hours, distance, status (Delivered/Delayed/Damaged), attempt counts[cite: 1] |
| `staff` | 120 | Staff names, employment status, ratings[cite: 1] |

> **Data Insight Note:** Having 5,800 shipments across 5,000 purchase orders indicates that **800+ orders required multiple delivery attempts** due to fulfillment issues[cite: 1].

---

## 📈 Key Data Analysis Insights

### 1. Purchase Order Demand & Spending
* **Top Spending Hubs:** **Hyderabad ($383.57M)** leads overall procurement spend, while **Kochi** handles the highest total order volume (399 orders)[cite: 1].
* **Procurement Channel Distribution:** Intermediaries (Distributors & Wholesalers) account for over **60% of total network spend ($2.23B)** compared to direct manufacturer purchases ($1.43B)[cite: 1].
* **Spend by Category:** **Electronics and Furniture** drive over **71% ($3.23B)** of total network spending[cite: 1]. Grocery leads in sheer order frequency (1,406 orders) but carries a lower average order cost[cite: 1].
* **Bulk Order Impact:** Bulk orders represent only **25.7%** of order volume but consume **61% ($2.77B)** of the total procurement budget[cite: 1].
* **Seasonal Demand:** Procurement spend peaks consistently every **June** ($202.66M in June 2025; $183.86M in June 2026)[cite: 1].

### 2. Delivery & Supplier Performance
* **Fulfillment Success Rate:** Overall delivery success rate sits at **63.5%**[cite: 1]. Roughly **33%** of all shipments suffer from delays or physical damage[cite: 1].
* **Impact of Delays/Damage:** Damaged (**37.16 hrs**) and Delayed (**36.27 hrs**) shipments take **~13–14 hours longer** to complete than successful deliveries (**23.24 hrs**), despite covering nearly identical travel distances (~893–936 km)[cite: 1].
* **Supplier Risk Gap:** Supplier issue rates vary widely[cite: 1]. For example, *Downs-Lee* recorded a high problem rate (~69%), whereas *Yates, Long & Ross* maintained a low issue rate (~18.5%)[cite: 1].
* **Rating Misalignment:** Supplier reliability ratings do not consistently match actual fulfillment outcomes (e.g., suppliers rated 4.0+ still experience 50%+ delay/damage rates)[cite: 1].

### 3. Fleet & Staff Performance
* **Fleet Workhorse:** **Mini Trucks** handle the highest shipment volume (1,675 trips across 26 active vehicles)[cite: 1].
* **Retry Recovery:** Orders requiring multiple shipment attempts show an **86.3% final delivery success rate**, proving that multi-attempt retry protocols successfully recover lost orders[cite: 1].

---

## 💡 Key Business Recommendations

1. **Review Supplier Quality Standards:** Audit high-risk suppliers exceeding a 50% problem rate (*e.g., Downs-Lee*) and evaluate vendor contracts using actual delivery performance metrics rather than static ratings[cite: 1].
2. **Optimize Intermediary Procurement:** Rebalance sourcing towards direct manufacturer relationships to reduce the current **60%+ reliance on distributors and wholesalers**[cite: 1].
3. **Capacity Planning for Peak Seasons:** Increase staff and vehicle availability during the recurring **June demand peak** and January post-holiday periods to prevent fulfillment drops[cite: 1].
4. **Target Bottlenecks Over Distance:** Address package handling, warehouse loading, and transit dispatch delays, as delayed shipments are caused by operational lags rather than extra travel mileage[cite: 1].

---

## 💻 SQL Techniques Utilized

* **Aggregations & Groupings:** `SUM()`, `AVG()`, `COUNT()`, `COUNT(DISTINCT)`[cite: 1]
* **Multi-Table Joins:** `INNER JOIN`, `LEFT JOIN` linking warehouses, orders, shipments, staff, and suppliers[cite: 1]
* **Conditional Aggregations:** `CASE WHEN` logic to compute damage percentages, delay rates, and custom spend bands[cite: 1]
* **Window Functions:** `RANK() OVER()` for regional rankings and `SUM() OVER()` for running network totals[cite: 1]
* **Date Parsing:** `DATE_FORMAT()` to analyze monthly volume and seasonality trends[cite: 1]

---

## 👤 Author & Acknowledgments

* **Author:** Yashwanth Ch[cite: 1]
