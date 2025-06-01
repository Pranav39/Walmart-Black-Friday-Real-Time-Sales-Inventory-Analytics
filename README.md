# Walmart Black Friday Sale Analysis

A real-time data pipeline and analytics dashboard for tracking Black Friday sales and inventory at Walmart stores using Google Cloud Platform (GCP).

## Project Overview

This project simulates real-time sales and inventory transactions, ingests data into BigQuery via Dataflow, and visualizes actionable insights through Looker Studio.


## Technologies Used

- Google Cloud Platform (GCP)
  - Pub/Sub
  - Dataflow
  - BigQuery
  - Cloud Storage
- Python (Data Generator)
- Looker Studio (Dashboard)


## Architecture

- **Mock Data Generator**: Python script simulating sales and inventory events.
- **Pub/Sub**: Real-time messaging backbone.
- **Dataflow**: Streaming pipeline for ingesting and transforming data.
- **BigQuery**: Central data warehouse with fact/dim tables and analytical views.
- **Looker Studio**: Real-time dashboards and insights.

                      +--------------------------+
                      |  Python Mock Generator   |
                      |  (Sales & Inventory)     |
                      +--------------------------+
                                  |
                                  v
                      +--------------------------+
                      |      Pub/Sub Topics      |
                      | sales_topic & inv_topic  |
                      +--------------------------+
                                  |
                                  v
                      +--------------------------+            +--------------------------+
                      |   Dataflow Streaming Job | <--------> |   Cloud Storage (CSV)    |
                      |   (Sales & Inventory)    |            | stores.csv, products.csv |
                      +--------------------------+            +--------------------------+
                                  |
                                  v
                      +--------------------------+
                      |        BigQuery          |
                      |--------------------------|
                      | sales_fact               |
                      | inventory_fact           |
                      | stores_dim               |
                      | products_dim             |
                      | sales & inventory views  |
                      +--------------------------+
                                  |
                                  v
                      +--------------------------+
                      |      Looker Studio       |
                      | Real-time dashboards     |
                      | Sales Trends, Inventory  |
                      +--------------------------+


## Dataset Design

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


## Workflow

This project implements a real-time data analytics pipeline for Walmart’s Black Friday sales event using Google Cloud Platform. The workflow integrates data ingestion, processing, storage, and visualization in a seamless, scalable manner.

### 1. Data Generation

- **Purpose:** Simulate real-time transactional data streams to mimic Walmart’s sales and inventory systems during Black Friday.
- **Implementation:** Two Python scripts generate mock data continuously:
  - **Sales Data Generator:** Produces sales events including transaction ID, product ID, timestamp, quantity, unit price, and store ID.
  - **Inventory Data Generator:** Produces inventory updates indicating product stock changes at various stores.
- **Output:** Events are published to two separate Google Cloud Pub/Sub topics:
  - `sales_topic` for sales data.
  - `inventory_topic` for inventory changes.

### 2. Data Ingestion with Pub/Sub

- **Pub/Sub Topics:** Act as message brokers to handle real-time event streams.
- **Function:** Decouples data producers (mock generators) from consumers (Dataflow jobs) to provide asynchronous, scalable, and reliable event delivery.
- **Benefits:** Ensures data durability and smooth flow even under high load or temporary downstream failures.

### 3. Real-time Data Processing using Dataflow

- **Technology:** Apache Beam pipelines deployed on Google Cloud Dataflow.
- **Two Streaming Pipelines:**
  - **Sales Pipeline:** Consumes events from `sales_topic`, performs necessary data transformations, and writes to `sales_fact` BigQuery table.
  - **Inventory Pipeline:** Consumes events from `inventory_topic`, processes data, and writes to `inventory_fact` BigQuery table.
- **Features:**
  - Uses windowing and triggering (if needed) to aggregate streaming data.
  - Employs BigQuery Storage Write API for efficient, low-latency data ingestion.
  - Ensures fault-tolerance with automatic retries and checkpointing.

### 4. Data Storage in BigQuery

- **Fact Tables:**
  - `sales_fact`: Stores raw, streaming sales transaction records.
  - `inventory_fact`: Stores inventory adjustments reflecting stock changes.
- **Dimension Tables:**
  - `products_dim`: Contains product metadata such as name, category, subcategory, price, and supplier.
  - `stores_dim`: Stores information about Walmart locations, including location, size, and store manager.
- **Usage:** These tables form the foundational data warehouse, storing both transactional and reference data for downstream analytics.

### 5. Analytical Layer: BigQuery Views

- **Purpose:** Abstract raw data into business-friendly metrics and KPIs.
- **Views Created:**
  - `vw_daily_sales_trend`: Aggregates daily revenue and units sold.
  - `vw_hourly_sales_trend`: Tracks sales revenue by hour of the day.
  - `vw_sales_by_region_store`: Summarizes sales by store location and attributes.
  - `vw_top_selling_products`: Identifies best-selling products and categories.
  - `vw_inventory_alerts`: Highlights products with low inventory (stockout risk).
  - `vw_sell_through_rate`: Calculates sell-through rate to evaluate inventory turnover.
  - `vw_revenue_by_store_category`: Breaks down revenue by store and product category.
  - `vw_top_stores`: Lists top-performing stores by revenue and sales volume.
- **Benefits:** Provides ready-to-use, performant SQL views that power the dashboards and reports.

### 6. Visualization and Reporting with Looker Studio

- **Connection:** Looker Studio connects directly to the BigQuery views.
- **Dashboards:** Interactive dashboards are built to display:
  - Hourly and daily sales trends with peak sales periods highlighted.
  - Geographic and store-level sales insights.
  - Top-performing products and product categories.
  - Real-time inventory status with alerting for low-stock products.
  - Sell-through rates for inventory effectiveness.
  - Total and segmented revenue by store, category, and region.
  - Ranking of high-revenue stores to identify top performers.
- **Interactivity:** Users can filter reports by date ranges, product categories, stores, and regions for granular analysis.


## Key Metrics & Insights

Implemented in BigQuery Views and visualized in Looker Studio:
- Hourly and daily sales trends.
- Top-selling products and categories.
- Regional sales analysis by store.
- Real-time inventory monitoring.
- Sell-through rate calculation.
- Total revenue (real-time and segmented).
- High-performing stores and locations.


## Summary

This project enables end-to-end real-time analytics by integrating continuous data generation, scalable message processing, cloud-native data warehousing, and intuitive BI visualization. It provides Walmart with actionable insights to optimize sales strategies, manage inventory efficiently, and improve operational decision-making during high-demand events like Black Friday.

