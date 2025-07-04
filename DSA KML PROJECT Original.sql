CREATE DATABASE KML_PROJECT_CASE_STUDY_DB

-----Deleting some Columns (Product_Container, Product_Base_Margin, Product_Sub_Category)
ALTER TABLE [dbo].[KML Sql Case Study Original]
	DROP COLUMN Product_Container

ALTER TABLE [dbo].[KML Sql Case Study Original]
	DROP COLUMN Product_Base_Margin


----Changed some Column Dataset------
ALTER TABLE [dbo].[KML Sql Case Study Original]
   ALTER COLUMN Shipping_Cost MONEY

   ALTER TABLE [dbo].[KML Sql Case Study Original]
   ALTER COLUMN  Unit_Price MONEY

---1---Product Category had the Highest Sales----
SELECT TOP 1 Product_Category AS [Product Category],
	SUM(Order_Quantity) As [Highest Sales]
    FROM [dbo].[KML Sql Case Study Original]
    GROUP BY Product_Category
	ORDER BY [Highest Sales] DESC

---2---Top 3 and Bottom 3 regions in terms of sales----
---Top 3
SELECT TOP 3 Region,
	SUM(Order_Quantity) As [Top 3 Sales]
    FROM [dbo].[KML Sql Case Study Original]
    GROUP BY Region
	ORDER BY [Top 3 Sales] DESC

---Bottom 3
SELECT TOP 3 Region,
	SUM(Order_Quantity) As [Top 3 Sales]
    FROM [dbo].[KML Sql Case Study Original]
    GROUP BY Region
	ORDER BY [Top 3 Sales] ASC


--- 3--- Total Sales of Appliances in Ontario----
SELECT Region, Product_Sub_Category, 
	SUM(Order_Quantity) As [Total Sales]
	FROM [dbo].[KML Sql Case Study Original]
	WHERE Region = 'Ontario' AND Product_Sub_Category = 'Appliances'
    GROUP BY Region, Product_Sub_Category
	ORDER BY [Total Sales] DESC

-------Add a Revenue Column------
ALTER TABLE [dbo].[KML Sql Case Study Original]
	ADD Revenue MONEY
	
UPDATE [dbo].[KML Sql Case Study Original]
	SET Revenue = Order_Quantity * Unit_Price



SELECT * FROM [dbo].[KML Sql Case Study Original]


-4---Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers----
SELECT TOP 10 Customer_Name AS Customers, Order_Date, Ship_Date, Order_Priority, Ship_Mode, 
	SUM(Revenue) AS [Bottom 10 Revenue],
    FROM [dbo].[KML Sql Case Study Original]
    GROUP BY Customer_Name, Order_Priority, Order_Date, Ship_Date, Ship_Mode
	ORDER BY [Bottom 10 Revenue] ASC

SELECT TOP 10 K.Customer_Name AS Customers, K.Product_Category, K.Order_Date, 
	K.Ship_Date, K.Order_Priority, K.Ship_Mode, O.[Status],
	COUNT(O.Order_ID) AS [Total No. of Returned Items by Category],
	SUM(Revenue) AS [Bottom 10 Revenue]
	FROM [KML Sql Case Study Original] K
	RIGHT JOIN Order_Status O
	ON K.Order_ID = O.Order_ID
	GROUP BY K.Product_Category, K.Customer_Name, K.Order_Date, K.Ship_Date, K.Order_Priority, 
	K.Ship_Mode, O.[Status]
	ORDER BY [Bottom 10 Revenue] ASC




-5---The most Shipping Cost using which shipping method----
SELECT TOP 1  Ship_Mode AS [Shipping Method],
	SUM(Shipping_Cost) AS [Most Shipping Cost]
    FROM [dbo].[KML Sql Case Study Original]
    GROUP BY Ship_Mode
	ORDER BY [Most Shipping Cost] DESC

-6---The most Valuable Customers, and the Products or Services do they Typically Purchase----

SELECT TOP 10 Customer_Name AS [Most Valuable Customers], Product_Category AS [Product_Purchased],
	SUM(Profit) AS [Revenue]
    FROM [dbo].[KML Sql Case Study Original]
    GROUP BY Customer_Name, Product_Category
	ORDER BY [Revenue] DESC


-7-----Small Business Customer that had the Highest Sales-----
SELECT TOP 1 Customer_Name AS Customer, Customer_Segment AS [Customer Segment],
	SUM(Order_Quantity) AS [Highest Sales]
    FROM [dbo].[KML Sql Case Study Original]
	WHERE Customer_Segment IN ('Small Business')
    GROUP BY Customer_Name, Customer_Segment
	ORDER BY [Highest Sales] DESC


-8---- Corporate Customer placed the most number of orders in 2009 – 2012-----
SELECT TOP 1 Customer_Name AS [Customer Name], Customer_Segment AS [Customer Segment], Order_Date,
	SUM(Order_Quantity) AS [Total of Orders]
    FROM [dbo].[KML Sql Case Study Original]
	WHERE Customer_Segment = 'Corporate'
    GROUP BY Customer_Name, Customer_Segment, Order_Date
	ORDER BY Order_Date DESC
	

-9---Consumer Customer that was the Most Profitable---
SELECT TOP 1 Customer_Name AS Customer, Customer_Segment AS [Customer Segment],
	SUM(Profit) AS Profit
    FROM [dbo].[KML Sql Case Study Original]
	WHERE Customer_Segment IN ('Consumer')
    GROUP BY Customer_Name, Customer_Segment
	ORDER BY Profit DESC


-10--customer returned items, and what segment do they belong to----
SELECT  K.Customer_Segment, K.Product_Category, O.[Status],
	COUNT(O.Order_ID) AS [Total No. of Returned Items by Category]
	FROM [KML Sql Case Study Original] K
	RIGHT JOIN Order_Status O
	ON K.Order_ID = O.Order_ID
	GROUP BY K.Customer_Segment, K.Product_Category, O.[Status]
	ORDER BY [Total No. of Returned Items by Category] DESC


-11---If the delivery truck is the most economical but the slowest shipping method and
Express Air is the fastest but the most expensive one, do you think the company
appropriately spent shipping costs based on the Order Priority? Explain your answer-----

SELECT Order_Priority, Ship_Mode AS [Shipping Method], 
	SUM(Shipping_Cost) AS [Shipping Costs]
	FROM [dbo].[KML Sql Case Study Original]
	GROUP BY Order_Priority,Ship_Mode 
	ORDER BY [Shipping Costs] DESC



SELECT * FROM [dbo].[Order_Status]

SELECT * FROM [dbo].[KML Sql Case Study Original]