-- ==========================================================
-- Project:     Wallmart Black Friday Sale Analysis
-- File:        create_and_load_dim_tables.sql
-- Purpose:     Define schema and load dimension tables
-- Environment: Google BigQuery + Google Cloud Storage
-- ==========================================================

-- Create the dataset (if it doesn't already exist)
CREATE SCHEMA IF NOT EXISTS blackfriday_dw;

-- Create the products dimension table
CREATE TABLE IF NOT EXISTS blackfriday_dw.products_dim (
  product_id STRING,
  name STRING,
  category STRING,
  subcategory STRING,
  price FLOAT64,
  supplier_id STRING
);

-- Create the stores dimension table
CREATE TABLE IF NOT EXISTS blackfriday_dw.stores_dim (
  store_id STRING,
  location STRING,
  size INT64,
  manager STRING
);

-- Load data into products_dim table
-- Replace 'your-gcp-project-bucket' with your actual GCS bucket name
-- Example: gs://my-blackfriday-project/dim_table_data/products_dim_data.csv
LOAD DATA OVERWRITE blackfriday_dw.products_dim
FROM FILES (
  format = 'CSV',
  uris = ['gs://your-gcp-project-bucket/dim_table_data/products_dim_data.csv'],
  skip_leading_rows = 1
);

-- Load data into stores_dim table
-- Replace with your actual GCS bucket name
LOAD DATA OVERWRITE blackfriday_dw.stores_dim
FROM FILES (
  format = 'CSV',
  uris = ['gs://your-gcp-project-bucket/dim_table_data/stores_dim_data.csv'],
  skip_leading_rows = 1
);
