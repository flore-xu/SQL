/* AdventureWorks Exercises from https://sqlzoo.net/wiki/AdventureWorks

AdventureWorks database description

10 tables: Customer, CustomerAddress, Address, SalesOrderHeader, SalesOrderDetail, Product, ProductModel, ProductCategory, ProductModelProductDescription, ProductDescription

---------------------------------------------------------------------------------
Table SalesOrderHeader
---------------------------------------------------------------------------------
core table in AdventureWorks database
each order placed by a customer have a record
each order can contain different products of different quantities.

SalesOrderID: PK. unique order id 
RevisionNumber: the number of times the order has changed
OrderDate: 
CustomerID:  FK. link to Customer table on CustomerID, link to CustomerAddress table on CustomerID
BillToAddressID: FK. billing address id. link to Address table on AddressID 
ShipToAddressID: FK. shipping address id. link to Address table on AddressID  
ShipMethod: 'CARGO TRANSPORT 5'
SubTotal:  subtotal (小计)
TaxAmt: tax amount （税）
Freight: shipping cost （运费）
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
Table Customer
---------------------------------------------------------------------------------
Each customer who has shopped has a record

CustomerID: unique customer id, link to SalesOrderHeader table and CustomerAddress on CustomerID
FirstName, 
MiddleName, 
LastName, 
CompanyName, 
EmailAddress
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
Table CustomerAddress
---------------------------------------------------------------------------------
each customer has 2 address, 'Main Office' or 'Shipping'

CustomerID:  PK, FK. link to Customer
AddressType: PK. either 'Main Office' or 'Shipping'
AddressID: FK. link to Address table on AddressID
---------------------------------------------------------------------------------



---------------------------------------------------------------------------------
Address
---------------------------------------------------------------------------------
each address has a record

AddressID: PK. link to table CustomerAddress on AddressID. link to table SalesOrderHeader on BillToAddressID or ShipToAddressID
AddressLine1, 
AddressLine2, 
City, 
StateProvince: state or province 
CountyRegion: country or region 
PostalCode
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
Table SalesOrderDetail
---------------------------------------------------------------------------------
each product purchased in an order has a record for its quantity and price

SalesOrderDetailID: PK. unique order detail id
SalesOrderID: FK. link to table SalesOrderHeader on SalesOrderID
ProductID: FK. link to table Product on ProductID
OrderQty: quantity of product, e.g., 2
UnitPrice: unit price of product （单价）, e.g., 113.00	
UnitPriceDiscount: discount of product （折扣）, e.g., 0.40
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
Table Product
---------------------------------------------------------------------------------
each product for sale has a record
each product belong to a product model.
each product is in a category

ProductID: PK. link to table  SalesOrderDetail on ProductID
Name: product name, e.g., 'HL Road Frame - Black, 58'
Color: product color, e.g., 'Black' 
StandardCost: cost （成本）, e.g., 1059.31
ListPrice: list price （定价）, e.g., 1431.50
Sze: size, e.g., 58 
Weight: weight, e.g., 1016.04 
ProductModelID: FK. link to table ProductModel on ProductModelID. 
ProductCategoryID: FK. link to ProductCategory on ProductCategoryID
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
Table ProductModel
---------------------------------------------------------------------------------
ProductModelID: PK. link to table Product on ProductModelID and table ProductModelProductDescription on ProductModelID
Name: product model name, e.g., 'Classic Vest'
CatalogDescription: Product Category description
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------
Table ProductCategory
---------------------------------------------------------------------------------
ProductCategoryID: PK 
ParentProductCategoryID: FK. link to table itself on ProductCategoryID  
Name: category name, e.g., 'Bikes'
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------
Table ProductModelProductDescription
---------------------------------------------------------------------------------
each product model has a description in specific culture

ProductModelID: PK, FK. link to table ProductModel on ProductModelID
Culture: PK. language, either 'en' (English), 'ar' (Arabic), 'fr' (French), 'th' (Thai), 'he' (Hebrew), 'zh-cht' (Chinese Traditional)
ProductDescriptionID: FK. link to table ProductDescription on ProductDescriptionID
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
Table ProductDescription
---------------------------------------------------------------------------------
ProductDescriptionID: PK. link to table 
Description: product description, e.g., description for product 'Mountain-500 Silver, 40' is 'Suitable for any type of riding, on or off-road. Fits any budget. Smooth-shifting with a comfortable ride.' 
---------------------------------------------------------------------------------

*/
-- Easy
-- 1. Show the first name and the email address of customer with CompanyName 'Bike World'
SELECT FirstName, EmailAddress
FROM Customer
WHERE CompanyName LIKE 'Bike World%';

-- 2. Show the CompanyName for all customers with an address in City 'Dallas'.
SELECT DISTINCT CompanyName
FROM Customer
JOIN CustomerAddress ON Customer.CustomerID = CustomerAddress.CustomerID
JOIN Address ON Address.AddressID = CustomerAddress.AddressID
WHERE Address.City = 'Dallas';

-- 3. How many items with ListPrice more than $1000 have been sold?
SELECT COUNT(*) AS Count
FROM SalesOrderDetail
LEFT JOIN Product ON SalesOrderDetail.ProductID = Product.ProductID
WHERE Product.ListPrice >= 1000;

-- 4. Give the CompanyName of those customers with orders over $100000. Include the subtotal plus tax plus freight.
SELECT c.CompanyName
FROM Customer c
JOIN SalesOrderHeader s ON c.CustomerID = s.CustomerID
GROUP BY c.CompanyName, c.CustomerID
HAVING SUM(s.SubTotal+s.TaxAmt+s.Freight) > 100000;

-- 5. Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'
SELECT
  SUM(SalesOrderDetail.OrderQty) As Total
FROM
  SalesOrderDetail
  JOIN
    Product
    ON SalesOrderDetail.ProductID = Product.ProductID
  JOIN
    SalesOrderHeader
    ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
  JOIN
    Customer
    ON SalesOrderHeader.CustomerID = Customer.CustomerID
WHERE
  Product.Name = 'Racing Socks, L'
  AND Customer.CompanyName = 'Riding Cycles';

--   Medium
-- 6. Single Item Order
-- A "Single Item Order" is a customer order where only one item is ordered. Show the SalesOrderID and the UnitPrice for every Single Item Order.

SELECT
  SalesOrderID,
  UnitPrice
FROM
  SalesOrderDetail
WHERE
  OrderQty = 1;

-- 7 Where did the racing socks go? 
-- List the product name and the CompanyName for all Customers who ordered ProductModel 'Racing Socks'.

SELECT
  Product.name, Customer.CompanyName
FROM
  ProductModel
  JOIN
    Product
    ON ProductModel.ProductModelID = Product.ProductModelID
  JOIN
    SalesOrderDetail
    ON SalesOrderDetail.ProductID = Product.ProductID
  JOIN
    SalesOrderHeader
    ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
  JOIN
    Customer
    ON SalesOrderHeader.CustomerID = Customer.CustomerID
WHERE
  ProductModel.Name = 'Racing Socks';

-- 8 Show the product description for culture 'fr' for product with ProductID 736.

SELECT
  ProductDescription.Description
FROM
  ProductDescription
  JOIN
     ProductModelProductDescription
     ON ProductDescription.ProductDescriptionID = ProductModelProductDescription.ProductDescriptionID
  JOIN
    ProductModel
    ON ProductModelProductDescription.ProductModelID = ProductModel.ProductModelID
  JOIN
    Product
    ON ProductModel.ProductModelID = Product.ProductModelID
WHERE
  ProductModelProductDescription.culture = 'fr'
  AND Product.ProductID = '736';

-- 9 Use the SubTotal value in SaleOrderHeader to list orders from the largest to the smallest. 
-- For each order show the CompanyName and the SubTotal and the total weight of the order.

SELECT
  Customer.CompanyName,
  SalesOrderHeader.SubTotal,
  SUM(SalesOrderDetail.OrderQty * Product.weight) AS Total_weight
FROM
  Product
  JOIN
    SalesOrderDetail
    ON Product.ProductID = SalesOrderDetail.ProductID
  JOIN
    SalesOrderHeader
    ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesorderID
  JOIN
    Customer
    ON SalesOrderHeader.CustomerID = Customer.CustomerID
GROUP BY
  SalesOrderHeader.SalesOrderID, SalesOrderHeader.SubTotal, Customer.CompanyName
ORDER BY
  SalesOrderHeader.SubTotal DESC;

-- 10 How many products in ProductCategory 'Cranksets' have been sold to an address in 'London'?

SELECT
  SUM(SalesOrderDetail.OrderQty) AS Count 
FROM
  ProductCategory
  JOIN
    Product ON ProductCategory.ProductCategoryID = Product.ProductCategoryID
  JOIN
    SalesOrderDetail ON Product.ProductID = SalesOrderDetail.ProductID
  JOIN
    SalesOrderHeader ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesorderID
  JOIN
    Address ON SalesOrderHeader.ShipToAddressID = Address.AddressID
WHERE
  Address.City = 'London'
  AND ProductCategory.Name = 'Cranksets';

-- 11 For every customer with a 'Main Office' in Dallas show AddressLine1 of the 'Main Office' and AddressLine1 of the 'Shipping' address - if there is no shipping address leave it blank. Use one row per customer.

SELECT
  Customer.CompanyName,
  MAX(CASE WHEN AddressType = 'Main Office' THEN AddressLine1 ELSE '' END) AS 'Main Office Address',
  MAX(CASE WHEN AddressType = 'Shipping' THEN AddressLine1 ELSE '' END) AS 'Shipping Address'
FROM
  Customer
  JOIN
    CustomerAddress ON Customer.CustomerID = CustomerAddress.CustomerID
  JOIN
    Address ON CustomerAddress.AddressID = Address.AddressID
WHERE
  Address.City = 'Dallas'
GROUP BY
  Customer.CompanyName;

-- 12 For each order show the SalesOrderID and SubTotal calculated three ways:
-- A) From the SalesOrderHeader
-- B) Sum of OrderQty*UnitPrice
-- C) Sum of OrderQty*ListPrice

SELECT
  SalesOrderHeader.SalesOrderID,
  SalesOrderHeader.SubTotal,
  SUM(SalesOrderDetail.OrderQty * SalesOrderDetail.UnitPrice),
  SUM(SalesOrderDetail.OrderQty * Product.ListPrice)
FROM
  SalesOrderHeader
  JOIN
    SalesOrderDetail
    ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
  JOIN
    Product
    ON SalesOrderDetail.ProductID = Product.ProductID
GROUP BY
  SalesOrderHeader.SalesOrderID,
  SalesOrderHeader.SubTotal;

-- 13 Show the best selling item by value.

SELECT
  Product.Name,
  SUM(SalesOrderDetail.OrderQty * (SalesOrderDetail.UnitPrice-SalesOrderDetail.UnitPriceDiscount)) AS Total_Sale_Value
FROM
  Product
  JOIN
    SalesOrderDetail
    ON Product.ProductID = SalesOrderDetail.ProductID
GROUP BY
  Product.Name
ORDER BY
  Total_Sale_Value DESC;

-- 14 Show how many orders are in the following ranges (in $):

--     RANGE      Num Orders      Total Value
--     0-  99
--   100- 999
--  1000-9999
-- 10000-

SELECT
    t.range AS 'RANGE',
    COUNT(t.Total) AS 'Num Orders',
    SUM(t.Total) AS 'Total Value'
FROM
  (
    SELECT
        CASE WHEN UnitPrice * OrderQty BETWEEN 0 AND 99 THEN '0-99'
            WHEN UnitPrice * OrderQty BETWEEN 100 AND 999 THEN '100-999'
            WHEN UnitPrice * OrderQty BETWEEN 1000 AND 9999 THEN '1000-9999'
            WHEN UnitPrice * OrderQty > 10000 THEN '10000-'
            ELSE 'Error'
        END AS 'Range',
        UnitPrice * OrderQty AS Total
    FROM SalesOrderDetail
  ) AS t
GROUP BY t.range;

-- 15 Identify the three most important cities. 
-- Show the break down of top level product category against city.

WITH top_cities AS (
    SELECT Address.City
    FROM Address
        JOIN SalesOrderHeader ON Address.AddressID = SalesOrderHeader.ShipToAddressID
    GROUP BY Address.City
    ORDER BY SUM(SalesOrderHeader.SubTotal) DESC
    LIMIT 3
)
SELECT Address.City,
       ProductCategory.Name AS Product_Category_Name,
       SUM(SalesOrderDetail.OrderQty * SalesOrderDetail.UnitPrice) AS Total_Sales
FROM Address
    JOIN SalesOrderHeader ON Address.AddressID = SalesOrderHeader.ShipToAddressID
    JOIN SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
    JOIN Product ON SalesOrderDetail.ProductID = Product.ProductID
    JOIN ProductCategory ON Product.ProductCategoryID = ProductCategory.ProductCategoryID
WHERE Address.City IN (SELECT City FROM top_cities)
GROUP BY Address.City, ProductCategory.Name;



-- Resit Questions


-- 1 List the SalesOrderNumber for the customer 'Good Toys' and 'Bike World'

SELECT
    SalesOrderHeader.SalesOrderID, Customer.CompanyName
FROM
    Customer
    LEFT JOIN SalesOrderHeader ON Customer.CustomerID = SalesOrderHeader.CustomerID
WHERE
  CompanyName IN ('Good Toys', 'Bike World');

-- 2 List the ProductName and the quantity of what was ordered by 'Futuristic Bikes'

SELECT
    Product.Name, SalesOrderDetail.OrderQty
FROM
    Customer
    JOIN SalesOrderHeader ON Customer.CustomerID = SalesOrderHeader.CustomerID
    JOIN SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
    JOIN Product ON SalesOrderDetail.ProductID = Product.ProductID
WHERE
    Customer.CompanyName = 'Futuristic Bikes';

-- 3 List the name and addresses of companies containing the word 'Bike' (upper or lower case) and companies containing 'cycle' (upper or lower case). 
-- Ensure that the 'bike's are listed before the 'cycles's.

SELECT
    Customer.CompanyName,
    Address.AddressLine1
FROM
    Customer 
    JOIN CustomerAddress ON Customer.CustomerID = CustomerAddress.CustomerID
    JOIN Address ON CustomerAddress.AddressID = Address.AddressID
WHERE LOWER(Customer.CompanyName) LIKE '%cycle%' OR LOWER(Customer.CompanyName) LIKE '%bike%'
ORDER BY
  LOWER(Customer.CompanyName) LIKE '%cycle%',
  Customer.CompanyName;

-- 4 Show the total order value for each CountryRegion. 
-- List by value with the highest first.

SELECT
    Address.CountyRegion, SUM(SubTotal)
FROM
    SalesOrderHeader
    JOIN Address ON SalesOrderHeader.ShipToAddressID = Address.AddressID
GROUP BY
  Address.CountyRegion
ORDER BY
  SUM(SubTotal) DESC;

-- 5 Find the best customer in each region.

WITH temp AS (
  SELECT countyregion, companyname, SUM(subtotal) total,
    RANK() OVER (PARTITION BY countyregion ORDER BY total DESC) rnk
  FROM Address a 
    JOIN SalesOrderHeader sh ON a.addressid = sh.shiptoaddressid
    JOIN Customer c ON sh.customerid = c.customerid
  GROUP BY countyregion, companyname
)
SELECT countyregion, companyname, total
FROM temp
WHERE rnk = 1;