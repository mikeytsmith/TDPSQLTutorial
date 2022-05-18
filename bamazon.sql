create DATABASE bamazon;
USE bamazon;

CREATE TABLE customer (
    cust_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    cust_name VARCHAR(100) NOT NULL,
    cust_addr VARCHAR(100) NOT NULL,
    card_no INT UNIQUE NOT NULL,
    PRIMARY KEY (cust_id)
);

SHOW TABLES;

CREATE TABLE orders (
    order_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    fk_cust_id INT NOT NULL,
    order_total DECIMAL(6 , 2 ) DEFAULT 0.00,
    order_date DATETIME DEFAULT current_timestamp,
    PRIMARY KEY (order_id),
    FOREIGN KEY (fk_cust_id)
        REFERENCES customer (cust_id)
);

describe customer;
describe orders;

INSERT INTO customer(cust_name, cust_addr, card_no) VALUES('ash','1 abc lane',1234),
('luke','2 x drive',1111),
('john','5 z road',4321);
INSERT INTO customer(cust_name, cust_addr, card_no) VALUES('mike','3 abbey road',1100),
('man','4 drury lane',1010);
SELECT * FROM customer; 

Insert INTO orders(fk_cust_id) values(3);
# If i wanted to change this order id=1 order total to £10 i could update it. update orders SET order_total = 10.00 WHERE order_id=1;
Insert INTO  orders(fk_cust_id) VALUES (5),(2),(1),(4);
SELECT * FROM orders;

SELECT * FROM orders o JOIN customer c ON o.fk_cust_id = c.cust_id;

UPDATE orders SET order_total = 50.00 where order_id=1;
UPDATE orders SET order_total = 25.50 WHERE order_id=2;
UPDATE orders SET order_total = 800 WHERE order_id=3;
UPDATE orders SET order_total = 65.00 WHERE order_id=4;
UPDATE orders SET order_total = 200 WHERE order_id=5;

CREATE TABLE items (
    item_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    stock INT DEFAULT 0,
    PRIMARY KEY (item_id)
);

describe items;
INSERT INTO items(item_name, price,stock) values('dvd',3.00,222),('book',10.00,8000),('cd',4.25,455),('tv',100.99,1000),('headphones',25.50,681);
SELECT * FROM items;

CREATE TABLE order_items (
    oi_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    fk_order_id INT NOT NULL,
    fk_item_id INT NOT NULL,
    quantity INT,
    orderline_total DECIMAL(6,2) DEFAULT 0.00,
    PRIMARY KEY (oi_id),
    FOREIGN KEY (fk_order_id)
		REFERENCES orders (order_id),
    FOREIGN KEY (fk_item_id)
		REFERENCES  items (item_id)
);

describe order_items;
INSERT INTO order_items(fk_order_id,fk_item_id,quantity) values(1,2,5),(1,5,1),(2,3,2),(3,4,1),(4,1,10),(5,1,2),(2,4,1),(2,5,2),(1,1,8),(5,3,1);
UPDATE order_items SET orderline_total = 100 WHERE oi_id=1;
UPDATE order_items SET orderline_total = 200 WHERE oi_id=2;
UPDATE order_items SET orderline_total = 300 WHERE oi_id=3;
UPDATE order_items SET orderline_total = 400 WHERE oi_id=4;
UPDATE order_items SET orderline_total = 500 WHERE oi_id=5;

SELECT * FROM order_items;

SELECT * FROM orders o JOIN Customers c ON o.fk_cust_id=c.cust_id JOIN order_items oi ON oi.fk_order_id=o.order_id JOIN items i ON oi.fk_item_id=i.item_id;
SELECT o.order_id, c.cust_id, c.cust_name, c.cust_addr, i.item_name, i.price, oi.quantity FROM orders o JOIN customer c ON o.fk_cust_id=c.cust_id JOIN order_items oi ON oi.fk_order_id=o.order_id JOIN items i ON oi.fk_item_id=i.item_id;

DELETE from orders WHERE order_id =5;

#aggregate functions
SELECT sum(stock) FROM items;
SELECT MIN(stock) from items;
SELECT MAX(stock) FROM items;
SELECT AVG(stock) FROM items;
SELECT COUNT(stock) FROM items;

#NESTED QUERY - query within a query / select within a select. 
#retrieve the customer id from the order table for the order with id = 2
#now we have customer id number we want to show the customer info from the customer table for the customer with id = 5
SELECT fk_cust_id FROM orders WHERE order_id=2;
SELECT * FROM customer WHERE cust_id=5;

#as a nested query - show customer data where the customer id is equal to customer with order id 2 from the orders table.
SELECT * FROM customer WHERE cust_id=(SELECT fk_cust_id FROM orders WHERE order_id=2);


# nested within a nested query
SELECT * FROM customer WHERE cust_ID=4;
SELECT * FROM orders WHERE fk_cust_id=4;
SELECT * FROM order_items WHERE fk_order_id=5;
#SELECT * FROM items WHERE item_id=1;
#Select * FROM items WHERE item_id=3;
SELECT * FROM items WHERE item_id=1 OR item_id=3;

#to combine above into one single query
SELECT * FROM items WHERE item_id=(SELECT fk_item_id FROM order_items WHERE fk_order_id=(SELECT order_id FROM orders WHERE fk_cust_id=4) LIMIT 1);
select fk_item_id FROM orderitems WHERE fk_order_id=(SELECT order_id FROM orders WHERE fk_cust_id=4) LIMIT 1;

select item_name from items where stock=(select  MIN(stock) from items);
SELECT item_name from items where price=(select min(price) from items);

select item_name from items where stock=(select  MAX(stock) from items);
SELECT item_name from items where price=(select MAX(price) from items);

select COUNT(cust_id) from customer;

# check this one
SELECT avg (order_total) from orders;

select sum(orderline_total) from order_items

SELECT fk_item_id FROM order_items WHERE item_id=2;
SELECT * FROM orders WHERE order_id=5;

select item_name from items where item_id=(select fk_item_id from order_items where fk_order_id=2 limit 1); 
