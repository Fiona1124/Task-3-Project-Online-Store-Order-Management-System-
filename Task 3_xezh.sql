create database OnlineStore;
use OnlineStore;
create table Customers(CUSTOMER_ID INT primary key,NAME varchar(100), EMAIL varchar(100), PHONE varchar(30),ADDRESS varchar(200));
create table Products(PRODUCT_ID INT primary key, PRODUCT_NAME varchar(100), CATEGORY varchar(50),PRICE decimal(10,2),STOCK INT);
create table Orders(ORDER_ID INT primary key, CUSTOMER_ID INT,PRODUCT_ID INT, QUANTITY INT,ORDER_DATE DATE, foreign key(CUSTOMER_ID) references Customers(CUSTOMER_ID),foreign key (PRODUCT_ID) references Products(PRODUCT_ID));
insert into Customers(CUSTOMER_ID,NAME,EMAIL,PHONE,ADDRESS) values(1,"Alice","10100@example.com","123456","123 street"),(2,"Bob","12345@example.com","342342","Oak Avenue"),(3,"Brown","Brown@example.com","232434","999 road"),(4,"Lily","Lily@example.com","203802","YY street"),(5,"David","David@example.com","2011102","XX street"),(6,"Carol","Carol@example.com","2055502","RR street");
insert into Products(PRODUCT_ID, PRODUCT_NAME,CATEGORY,PRICE,STOCK)values(1,"TV","Electronics",8000.00,10),(2,"Headphone","Electronics",5000.00,0),(3,"desk","Home",500.00,4),(4,"chair","Home",100.00,2),(5,"T-Shirt","Clothing",200.00,10),(6,"Shorts","Clothing",50.00,8);
insert into Orders(ORDER_ID,CUSTOMER_ID,PRODUCT_ID,QUANTITY,ORDER_DATE)values(1,1,1,1,"2025-07-01"),(2,4,2,1,"2025-07-15"),(3,3,1,2,"2025-07-15"),(4,3,1,1,"2025-08-1"),(5,5,2,1,"2025-08-2"),(6,1,1,1,"2025-08-5"),(7,4,1,3,"2025-06-1"),(8,5,1,1,"2024-06-1");
select * from Customers;
select*from Products;
select*from Orders;
# Order Management
# a) Retrieve all orders placed by a specific customer.
select O.ORDER_ID,O.ORDER_DATE,P.PRODUCT_NAME,O.QUANTITY
from Customers C left join Orders O on C.CUSTOMER_ID=O.CUSTOMER_ID left join Products P on O.PRODUCT_ID=P.PRODUCT_ID 
where C.Customer_ID=1;
# b) Find products that are out of stock
select *
from Products
where STOCK=0;
# c) Calculate the total revenue generated per product.
select P.PRODUCT_ID, P.PRODUCT_NAME, SUM(O.QUANTITY*P.PRICE) as total_revenue
from Orders O left join Products P on O.PRODUCT_ID=P.PRODUCT_ID
group by P.PRODUCT_ID, P.PRODUCT_NAME
Order by total_revenue desc;
# d)Retrieve the top 5 customers by total purchase amount
select C.NAME, sum(O.QUANTITY*P.PRICE) as total_purchase_amount
from Orders O left join Customers C on C.CUSTOMER_ID=O.CUSTOMER_ID left join Products P on O.PRODUCT_ID=P.PRODUCT_ID
group by C.NAME
having sum(O.QUANTITY*P.PRICE)
order by total_purchase_amount desc
limit 5;
# e) Find customers who placed orders in at least two different product categories.
select C.NAME, C.CUSTOMER_ID, count(distinct P.CATEGORY) as category_count
from Orders O left join Customers C on C.CUSTOMER_ID=O.CUSTOMER_ID left join Products P on O.PRODUCT_ID=P.PRODUCT_ID
group by C.NAME, C.CUSTOMER_ID
having count(distinct P.CATEGORY)>=2
order by category_count desc;
# Analytics
# a)Find the month with the highest total sales.
select date_format(O.ORDER_DATE,"%Y-%m") as month,sum(O.QUANTITY*P.PRICE) as total_sales
from Orders O left join Products P on O.PRODUCT_ID=P.PRODUCT_ID
group by date_format(O.ORDER_DATE,"%Y-%m")
having sum(O.QUANTITY*P.PRICE)
order by total_sales desc
LIMIT 1;
# CTE in case there are two monthes with the same rank
with TotalSales as(
select date_format(O.ORDER_DATE,"%Y-%m") as month,sum(O.QUANTITY*P.PRICE) as total_sales
from Orders O left join Products P on O.PRODUCT_ID=P.PRODUCT_ID
group by date_format(O.ORDER_DATE,"%Y-%m")
),
SalesRnk as (select month, dense_rank()over(order by total_sales desc) as rnk
            from TotalSales)
select month
from SalesRnk
where rnk=1;
# b) Identify products with no orders in the last 6 months.
select P.*
from Products P left join Orders O on P.PRODUCT_ID=O.PRODUCT_ID
and O.ORDER_DATE>=DATE_SUB(CURDATE(),interval 6 month)
where O.ORDER_ID IS NULL;
# c) Retrieve customers who have never placed an order.
select C.NAME
from Customers C left join Orders O on C.CUSTOMER_ID=O.CUSTOMER_ID
where O.ORDER_ID is NULL;
# d) Calculate the average order value across all orders.
select AVG(O.QUANTITY*P.PRICE) as avg_order_value
from Orders O left join Products P on O.PRODUCT_ID=P.PRODUCT_ID;

