CREATE DATABASE brightmart;
SELECT current_database();

CREATE TABLE customers(
customer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(150) NOT NULL UNIQUE,
phone VARCHAR(20),
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customers(first_name, last_name, email, phone)VALUES
('Aisha', 'Khumalo', 'aisha@example.com', '0710000001'),
('Daniel', 'Mokoena', 'daniel@example', '0720000002'),
('Motsei', 'Sefanyetso', 'motsei@example', '0720000003'),
('Karabo', 'Molefi', 'karabo@example', '0720000004'),
('Tefo', 'Mach', 'tefo@example', '0720000005'),
('Thabi', 'Xulu', 'thabi@example', '0720000006');

SELECT first_name, last_name, email
FROM customers;


CREATE TABLE products(
product_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
product_name VARCHAR(100) NOT NULL,
description TEXT,
price NUMERIC(10,2) NOT NULL CHECK (price >=0),
stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >=0),
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products(product_name, description, price, stock_quantity)VALUES
('Wireless mouse', 'Wireless computer mouse', 249.99, 30),
('Mechanical Keyboard', 'USB mechanical keyboard', 899.00, 15),
('USB-C Cable', 'One metre USB-C cable', 99.50, 50),
('PlayStation 5', 'Gaming console', 12499.99, 7),
('GTA6', 'Playstation game', 1549.99, 3000),
('HP Laptop', 'Portable eletronic', 10249.99, 13);

SELECT product_name AS product,
		price AS selling_price
FROM products
WHERE price > 300 AND stock_quantity = 15;

SELECT product_name
FROM products
WHERE product_name LIKE '%USB%';

SELECT product_name, stock_quantity, price
FROM products
ORDER BY stock_quantity ASC, price DESC;

CREATE TABLE orders(
order_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
customer_id INTEGER NOT NULL,
order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
status VARCHAR(20) NOT NULL DEFAULT 'PENDING',

CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id),
CONSTRAINT chk_order_status
CHECK (status IN ('PENDING', 'PAID', 'SHIPPED', 'CANCELLED'))
);

INSERT INTO orders(customer_id, status)VALUES
(1, 'PAID'),
(2, 'PENDING'),
(3, 'PAID'),
(4, 'PENDING'),
(5, 'PAID'),
(6, 'PAID');

SELECT order_id, customer_id
FROM orders
WHERE status = 'PENDING';

SELECT order_id, status
FROM orders
WHERE status IN ('PAID', 'SHIPPED');



CREATE TABLE order_items(
order_item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
order_id INTEGER NOT NULL,
product_id INTEGER NOT NULL,
quantity INTEGER NOT NULL CHECK(quantity>0),
unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >=0),

CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id),

CONSTRAINT fk_order_items_product
FOREIGN KEY (product_id)
REFERENCES products(product_id),

CONSTRAINT uq_order_product
UNIQUE (order_id, product_id)
);

SELECT order_id, customer_id, status FROM orders;
SELECT product_id, product_name, price FROM products;


INSERT INTO order_items(order_id, product_id, quantity, unit_price)VALUES
(1, 1, 2, 249.99),
(1, 3, 1, 99.50),
(2, 2, 1, 899.00),
(3, 4, 4, 10500.99),
(6, 6, 10, 7000.00),
(5, 5, 1500, 999.99);


SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

SELECT
    orders.order_id,
    customers.first_name,
    customers.last_name,
    orders.status
FROM orders, customers
WHERE orders.customer_id = customers.customer_id;


SELECT
    o.order_id,
    c.first_name,
    c.last_name,
    o.status
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;


SELECT
    o.order_id,
    c.first_name,
    p.product_name,
    oi.quantity,
    oi.unit_price
FROM orders o, customers c, order_items oi, products p
WHERE o.customer_id = c.customer_id
AND o.order_id = oi.order_id
AND oi.product_id = p.product_id;

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id
FROM customers c, orders o
WHERE c.customer_id = o.customer_id
ORDER BY c.customer_id;

SELECT
	order_id, first_name, last_name
FROM orders, customers
WHERE orders.customer_id= customers.customer_id;

SELECT
	p.product_name, p.description, oi.product_id, quantity
FROM products p, order_items oi
WHERE p.product_id = oi.product_id;

SELECT * FROM customers;

SELECT
	o.order_id,
	c.email,
	p.product_name,
	o.quantity
FROM order_items o, customers c, products p, orders oo
WHERE c.customer_id = oo.customer_id
AND p.product_id = o.product_id;

SELECT product_id, product_name, price
FROM products
WHERE product_name = 'USB-C Cable';


UPDATE products
SET price = 109.50
WHERE product_name = 'USB-C Cable';


ALTER TABLE customers
ADD COLUMN city VARCHAR(80);

UPDATE customers
SET city = 'Pretoria'
WHERE first_name = 'Aisha';

SELECT first_name, last_name
FROM customers
WHERE city = 'Pretoria';




