create database project
use  project
select * from [dbo].[Orders$]

--SALES & REVENUE INSIGHTS

/* What is the total revenue generated so far?

Which product has generated the most revenue?

Show me month-by-month revenue trend for the last 10 Years

Which 5 customers have spent the most on our platform?

What is the average order value per customer? */


--1, What is the total revenue generated so far?

select 
	round(sum(profit),2)as Total_Revenue_Generated
	from
		[dbo].[Orders$]
--286397.02


--2, Which product has generated the most revenue?


select top 1
	[Product Name],
	round(sum([Quantity] * [Sales] ),2)as total_profit
from
	[dbo].[Orders$]
group by
	[Product Name]
order by 
	total_profit desc

--Canon imageCLASS 2200 Advanced Copier	253399.28

--3, Show me month-by-month revenue trend for the last 10 Years
SELECT 
  FORMAT([Order Date], 'yyyy-MM') AS [Month],
  ROUND(SUM(Sales), 2) AS monthly_revenue
FROM [dbo].[Orders$]
WHERE [Order Date] >= DATEADD(MONTH, -120,GETDATE())
GROUP BY FORMAT([Order Date], 'yyyy-MM')
ORDER BY FORMAT([Order Date], 'yyyy-MM')



--4, Which 5 customers have spent the most on our platform?

select top 5
	[Customer Name],
	[Customer ID],
	round(sum(Sales*quantity),2) as Total_order_value
from 
	[dbo].[Orders$]
group by 
	[Customer Name],
	[Customer ID]

--5, What is the average order value per customer? */

select
	[Customer Name],
	[Customer ID],
	(sum(Sales *[Quantity])/count(distinct([Order ID]))) as total_sales
from
	[dbo].[Orders$]
group by 
	[Customer Name],
	[Customer ID]

----------------------------------------------------------------------------
--PRODUCT PERFOMANCE 
/*Top 10 selling products by quantity sold?

Which product category has the highest revenue?

List products with zero sales (dead stock).
*/

select * from [dbo].[Orders$]


--1
--Top 10 selling products by quantity sold?

SELECT TOP 10 
	[Product Name],
	[Product ID],
	[category],
	round(sum([sales]*[Quantity]),2) as Total_sale
from 
	[dbo].[Orders$]
group by 
	[Product Name],
	[Product ID],
	[category]
order by  
	Total_sale desc


--2 
--Which product category has the highest revenue?

select top 1
	[category],
	Sum(sales * Quantity) as TP 
from
	[dbo].[Orders$]
Group by 
	[category]
order by 
	TP desc

--3
--List products with zero sales (dead stock).

select 
	[Product Name],
	[Product ID],
	[category],
	[Sales]
from
	[dbo].[Orders$]
where 
	sales<10
	or
	sales=0
group by 
	[Product Name],
	[Product ID],
	[category],
	[Sales]
--No Product with '0' Sale
------------------------------------------------------------------


--CUSTOMER INSIGHTS

/*Which city/state has the highest number of customers or orders?

Repeat vs one-time customers: how many are returning?
*/


select * from dbo.Orders$
--1
--Which city/state has the highest number of customers or orders?

select top 10
	[State],
	[city],
	count(distinct([Customer ID])) as Customers,
	count([Order ID]) as Orders
from 
	dbo.Orders$
group by
	[State],
	[City]
order by
	customers desc,
	orders 

--2
--Repeat vs one-time customers: how many are returning?

with customer_orders as (
  select 
    [customer id],
    count(distinct [order id]) as order_count
  from [dbo].[orders$]
  group by [customer id]
)
select
  case 
    when order_count = 1 then 'one-time customer'
    else 'repeat customer'
  end as customer_type,
  count(*) as total_customers
from customer_orders
group by 
  case 
    when order_count = 1 then 'one-time customer'
    else 'repeat customer'
  end;

------------------------------------------------------------

-- OPERATIONS & ORDERS
/*
What is the average delivery time per order?

Which ship method is used most frequently?

Which products were shipped with the highest discount?

*/

select * from dbo.Orders$

--1 
--What is the average delivery time per order?

select 
  avg(datediff(day, [order date], [ship date])) as avg_delivery_days
from 
	[dbo].[orders$]
where 
	[ship date] is not null;

--2
--Which ship method is used most frequently?

select
	[ship mode], 
	count(*) as total_orders
from 
	[dbo].[orders$]
group by 
	[ship mode]
order by 
	total_orders desc

--3
--Which products were shipped with the highest discount?

select top 5 
  [product name], 
  [discount]
from [dbo].[orders$]
order by [discount] desc;
