# 🛒 Walmart Black Friday Real-Time Sales & Inventory Analytics

A real-time data pipeline and analytics dashboard for tracking Black Friday sales and inventory at Walmart stores using Google Cloud Platform (GCP).

## 📌 Project Overview

This project simulates real-time sales and inventory transactions, ingests data into BigQuery via Dataflow, and visualizes actionable insights through Looker Studio.

## 🧱 Architecture

- **Mock Data Generator**: Python script simulating sales and inventory events.
- **Pub/Sub**: Real-time messaging backbone.
- **Dataflow**: Streaming pipeline for ingesting and transforming data.
- **BigQuery**: Central data warehouse with fact/dim tables and analytical views.
- **Looker Studio**: Real-time dashboards and insights.

## 📂 Dataset Design

### Fact Tables
- `sales_fact`  
  - `transaction_id`, `product_id`, `timestamp`, `quantity`, `unit_price`, `store_id`
- `inventory_fact`  
  - `product_id`, `timestamp`, `quantity_change`, `store_id`

### Dimension Tables
- `products_dim`  
  - `product_id`, `name`, `category`, `subcategory`, `price`, `supplier_id`
- `stores_dim`  
  - `store_id`, `location`, `size`, `manager`

## 📊 Key Metrics & Insights

Implemented in BigQuery Views and visualized in Looker Studio:
- Hourly and daily sales trends.
- Top-selling products and categories.
- Regional sales analysis by store.
- Real-time inventory monitoring.
- Sell-through rate calculation.
- Total revenue (real-time and segmented).
- High-performing stores and locations.

## ⚙️ Technologies Used

- Google Cloud Platform (GCP)
  - Pub/Sub
  - Dataflow
  - BigQuery
  - Cloud Storage
- Python (Data Generator)
- Looker Studio (Dashboard)

## 🚀 How It Works

1. **Mock data** is generated and pushed to Pub/Sub.
2. **Dataflow** jobs stream and load data into BigQuery.
3. **Fact and dimension tables** store structured data.
4. **Views** calculate key metrics.
5. **Looker Studio** dashboards display real-time analytics.

## 📁 Folder Structure


## 🧠 Lessons Learned

- Built a streaming pipeline using only the GCP Console UI (no Apache Beam code).
- Created analytical views using pure SQL in BigQuery.
- Solved real-time analytics problems like stream lag, schema design, and data joins.

## 💰 Cost Optimization

- Used free-tier resources and budgeted VMs/zones.
- Stayed within ₹15,000 GCP credits.

## ✅ Status

🎉 **Project Complete**

---

## 📸 Demo

> Insert your Looker Studio public dashboard link or screenshots here.

---

## 📄 License

MIT License

---

