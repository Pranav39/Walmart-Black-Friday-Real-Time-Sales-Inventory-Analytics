CREATE TABLE blackfriday_dw.sales_fact (
  transaction_id STRING,
  product_id STRING,
  timestamp TIMESTAMP,
  quantity INT64,
  unit_price FLOAT64,
  store_id STRING
);

CREATE TABLE blackfriday_dw.inventory_fact (
  product_id STRING,
  timestamp TIMESTAMP,
  quantity_change INT64,
  store_id STRING
);
