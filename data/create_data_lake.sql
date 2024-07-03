DROP TABLE IF EXISTS fact_sales_order;
CREATE TABLE fact_sales_order 
    (
    sales_record_id SERIAL PRIMARY KEY,
    sales_order_id INT,
    created_date DATE,
    created_time TIME,
    last_updated_date DATE,
    last_updated_time TIME,
    sales_staff_id INT,
    counterparty_id INT,
    units_sold INT,
    unit_price NUMERIC(10,2),
    currency_id INT,
    design_id INT,
    agreed_payment_date DATE,
    agreed_Delivery_date DATE,
    agreed_delivery_location_id INT
    );

DROP TABLE IF EXISTS dim_staff;
CREATE TABLE dim_staff 
    (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    department_name VARCHAR(100),
    location VARCHAR(100),
    email_address VARCHAR(100)
    );

DROP TABLE IF EXISTS dim_counterparty;
CREATE TABLE dim_counterparty
    (
    counterparty_id SERIAL PRIMARY KEY,
    counterparty_legal_name VARCHAR(255),
    counterparty_legal_address_line_1 VARCHAR(255),
    counterparty_legal_address_line_2 VARCHAR(255),
    counterparty_legal_district VARCHAR(255),
    counterparty_legal_city VARCHAR(255),
    counterparty_legal_postcode VARCHAR(255),
    counterparty_legal_country VARCHAR(255),
    counterparty_legal_phone_number VARCHAR(255)
    );

DROP TABLE IF EXISTS dim_currency;
CREATE TABLE dim_currency
    (
    currency_id SERIAL PRIMARY KEY,
    currency_code VARCHAR(3),
    currency_name VARCHAR(10)
    );

DROP TABLE IF EXISTS dim_design;
CREATE TABLE dim_design
    (
    design_id SERIAL PRIMARY KEY,
    design_name VARCHAR,
    file_location VARCHAR,
    file_name VARCHAR
    );

DROP TABLE IF EXISTS dim_location;
CREATE TABLE dim_location
    (
    location_id SERIAL PRIMARY KEY,
    address_line_1 VARCHAR,
    address_line_2 VARCHAR,
    district VARCHAR,
    city VARCHAR,
    postal_code VARCHAR,
    country VARCHAR,
    phone VARCHAR
    );

DROP TABLE IF EXISTS dim_date;
CREATE TABLE dim_date
    (
     date_id SERIAL PRIMARY KEY,
     year INT,
     month INT,
     day INT,
     day_of_week INT,
     day_name VARCHAR,
     month_name VARCHAR,
     quarter INT   
    );