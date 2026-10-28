create database company_db;
use company_db;
CREATE TABLE Customers (
CustomerID INT,
CustomerName VARCHAR(50),
City VARCHAR(30),
JoinDate DATE
);
INSERT INTO Customers VALUES
(101,'Rahul Sharma','Bangalore','2023-01-15'),
(102,'Priya Mehta','Mumbai','2024-03-20'),
(103,'Arjun Nair','Chennai','2025-01-12'),
(104,'Sneha Gupta','Delhi','2022-07-10'),
(105,'Kavya Reddy','Hyderabad','2024-08-15'),
(106,'Amit Verma','Pune','2023-11-05'),
(107,'Rohan Singh','Kolkata','2024-05-18'),
(108,'Simran Kaur','Delhi','2025-02-01'),
(109,'Anjali Jain','Mumbai','2023-09-22'),
(110,'Vikram Patel','Ahmedabad','2022-12-30');

CREATE TABLE Orders (
OrderID INT,
CustomerID INT,
OrderDate DATE,
OrderAmount DECIMAL(10,2),
Status VARCHAR(20)
);
insert into orders values
(5001,101,'2025-01-05',12000,'Delivered'),
(5002,102,'2025-01-15',8500,'Pending'),
(5003,101,'2025-02-10',22000,'Delivered'),
(5004,104,'2025-02-15',4500,'Cancelled'),
(5005,103,'2025-03-01',17500,'Delivered'),
(5006,105,'2025-03-10',9800,'Pending'),
(5007,106,'2025-03-18',25000,'Delivered'),
(5008,107,'2025-04-02',14500,'Delivered'),
(5009,101,'2025-04-10',30000,'Delivered'),
(5010,109,'2025-04-15',6500,'Pending'),
(5011,110,'2025-05-01',42000,'Delivered'),
(5012,104,'2025-05-08',18000,'Delivered'),
(5013,106,'2025-05-15',7000,'Cancelled'),
(5014,102,'2025-05-20',27000,'Delivered'),
(5015,107,'2025-06-01',15500,'Pending');

CREATE TABLE Employees (
EmployeeID INT,
EmployeeName VARCHAR(50),
ManagerID INT,
Department VARCHAR(30),
JoiningDate DATE,
Salary DECIMAL(10,2)
);
INSERT INTO Employees VALUES
(1,'Rajesh Kumar',NULL,'Management','2018-01-10',150000),
(2,'Neha Sharma',1,'Sales','2020-03-15',90000),
(3,'Amit Gupta',1,'IT','2019-06-20',110000),
(4,'Priyanka Singh',2,'Sales','2022-01-12',65000),
(5,'Vikas Patel',2,'Sales','2021-09-18',70000),
(6,'Rohit Jain',3,'IT','2023-02-05',60000),
(7,'Anjali Verma',3,'IT','2022-11-10',62000),
(8,'Karan Mehta',1,'HR','2021-05-25',80000),
(9,'Sneha Kapoor',8,'HR','2024-01-05',50000),
(10,'Arjun Malhotra',3,'IT','2024-04-15',55000);


--   Q1- A retail company wants to reward its most valuable customers. Display the 
-- top 5 highest-value orders along with customer names.

select * from customers  ;
select c.customerName,o.orderID,o.orderAmount
from customers as c
join orders as o
on c.customerID = o.customerID  
order by o.orderAmount  desc
limit  5;
 
--  Question 2
-- The marketing team wants to send promotional emails to customers whose 
-- names start with 'A', 'R', or 'S'.

select *
from customers
where left(customername,1) in ('a','r','s');
 
--  Question 3
-- Management wants to identify customers who have placed orders worth 
-- more than ₹10,000 but whose order status is still Pending.
-- Display:
-- ● Customer Name
-- ● Order ID
-- ● Order Amount
-- ● Status

 select c.customername, o.OrderID, o.OrderAmount, o.status
 from customers AS c 
 join orders AS o
 on o.customerid= c.customerid
 where o.OrderAmount >10000
 and o.status ='pending';
 
 -- Question 4--The customer success team wants to identify customers who joined more 
-- than 365 days ago.Display the number of days each customer has been associated with the 
-- company.

select * from customers;
select customerID ,customername , joindate,
datediff(curdate() , joindate) as working
from customers
where datediff(curdate(),joindate) >365
order by working desc;

-- Question 5--The finance department wants to estimate future revenue.
-- Create a report showing:
-- ● Order ID
-- ● Current Amount
-- ● 18% GST
-- ● Total Amount After GST
-- ● Expected Collection Date (15 days after order date)

select OrderID as'order ID',
orderamount as'order Amount',
orderamount *0.18 as'GST (18%)',
orderamount *1.18 as'total Amount after GST',
date_add(orderdate,interval 15 day)as 'expected collection date'
from orders;

-- Question 6--The operations team wants to review the customers ranked between 11th and 
-- 20th highest orders.
-- Use LIMIT and OFFSET.
select * from customers;
select customername ,orderID,Orderamount
from customers as c
join orders as o
on c.customerID =o.customerID
order by Orderamount desc
limit 10 offset 10; 

-- Question 7--An e-commerce company wants to identify customers who have never 
-- placed any order despite registering on the platform.
-- Display:
-- ● Customer ID
-- ● Customer Name
-- ● Join Date
-- ● Number of Days Since Registration

select c.customerid,c.customername,c.joindate, datediff(curdate(),c.joindate) as 'number of days since registration'
from customers as c
left join orders as o
on C.customerID=O.customerID
where o.orderid is null;

-- Question 8--The HR department wants to analyze organizational hierarchy.
-- Using a JOIN, display:
-- ● Employee Name
-- ● Manager Name
-- ● Department
select* from employees;
select e.employeename as 'employee name',m.employeename as 'maneger  name',e.department
from employees as e
JOIN Employees  as m 
ON e.ManagerID = m.EmployeeID;

-- Question 9--The sales director wants a report of customers who placed orders within 30 
-- days of joining the platform.
-- Display:
-- ● Customer Name
-- ● Join Date
-- ● Order Date
-- ● Days Taken To Place First Order

select
c.customername as 'customer name',
c.joindate as 'join date',
min(o.orderdate) as 'order date',
datediff(min(o.orderdate), c.joindate) as 'days taken to place first order'
from customers as c
join orders as o 
on c.customerID=o.customerID
group by c.customerID,c.customername,c.joindate
having datediff(min(o.orderdate),c.joindate)<=30;

 --  Question 10--Business Requirement
-- Generate a report showing:
-- ● Customer Name
-- ● Total Purchase Amount
-- ● Spending Category
-- ● Loyalty Status

select
c.customername as 'customer name',
sum(o.orderamount )as 'total purchase amount',
c.joindate as 'join date'
 from customers as c
 left join orders as o
 on c.customerid=o.customerid
 group by c.customerID,c.customername,c.joindate
 order by sum(o.orderamount) desc;
 
 
-- Question 11 : An online marketplace wants to find customers whose order 
-- amount is higher than the average order amount of all orders.
-- Display:
-- ● Customer Name
-- ● Order ID
-- ● Order Amount

select
c.customername as 'customer name',
o.orderID as ' order ID',
o.orderamount as 'order amount'
from customers as c
join orders as o
on c.customerID= o.customerID
where o.orderamount > (
select AVG(orderamount) 
FROM ORDERS);


-- Question 12--The management team wants the 2nd to 6th highest orders placed by 
-- customers.
-- Display:
-- ● Customer Name
-- ● Order ID
-- ● Order Amount

select
c.customername as 'customer name',
o.orderid as 'orderID',
o.orderamount as 'order amount'
from customers as c
join orders as o
on c.customerid=o.customerid
order by o.orderamount desc
limit 1,5;




