import time
import json
import random
from datetime import datetime, timezone
from google.cloud import pubsub_v1

# Initialize Publisher client
publisher = pubsub_v1.PublisherClient()

# GCP project and Pub/Sub topic paths 
PROJECT_ID = <YOUR_GCP_PROJECT_ID> # Replace with your actual GCP Project ID
sales_topic_path = publisher.topic_path(PROJECT_ID, "sales_topic")
inventory_topic_path = publisher.topic_path(PROJECT_ID, "inventory_topic")

# Full product list with product_id and price from your dataset
PRODUCTS = [
    ('P1001', 899.99), ('P1002', 799.99), ('P1003', 349.99), ('P1004', 1199.99), ('P1005', 49.99),
    ('P2001', 1399.99), ('P2002', 899.99), ('P2003', 149.99), ('P2004', 599.99), ('P2005', 199.99),
    ('P3001', 129.99), ('P3002', 89.99), ('P3003', 69.99), ('P3004', 59.99), ('P3005', 139.99),
    ('P3006', 99.99), ('P3007', 119.99), ('P3008', 69.99), ('P3009', 129.99), ('P3010', 89.99),
    ('P4001', 249.99), ('P4002', 499.99), ('P4003', 199.99), ('P4004', 799.99), ('P4005', 999.99),
    ('P5001', 129.99), ('P5002', 39.99), ('P5003', 79.99), ('P5004', 49.99), ('P5005', 29.99)
]

# Store IDs from W001 to W025
STORES = [f'W{str(i).zfill(3)}' for i in range(1, 26)]

transaction_counter = 1

while True:
    # Pick random product and store
    product_id, unit_price = random.choice(PRODUCTS)
    store_id = random.choice(STORES)
    
    # Random quantity sold (1 to 5 units)
    quantity = random.randint(1, 5)
    
    # Current UTC timestamp in ISO format
    timestamp = datetime.now(timezone.utc).isoformat()
    
    # Create sale event
    sale = {
        "transaction_id": f"T{transaction_counter:08d}",
        "product_id": product_id,
        "timestamp": timestamp,
        "quantity": quantity,
        "unit_price": unit_price,
        "store_id": store_id
    }
    
    # Publish sale event
    publisher.publish(sales_topic_path, json.dumps(sale).encode("utf-8"))
    print("[SALE] Published:", sale)
    
    # Create corresponding inventory update (negative quantity)
    inventory_update = {
        "product_id": product_id,
        "timestamp": timestamp,
        "quantity_change": -quantity,
        "store_id": store_id
    }
    
    # Publish inventory update
    publisher.publish(inventory_topic_path, json.dumps(inventory_update).encode("utf-8"))
    print("[INVENTORY] Published:", inventory_update)
    
    transaction_counter += 1
    
    # Random delay between o.5 to 1.5 seconds
    time.sleep(random.uniform(0.5, 1.5))
