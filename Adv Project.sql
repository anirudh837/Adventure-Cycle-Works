# We should create the database
Create database Adv;
# then after we should active the data base
use adv;
select * from factinternetsales;
select * from fact_internet_sales_new;
select * from dimproduct;
select * from dimproductsubcategory;
select * from dimproductcategory;
# here both tables should be a union 
SELECT * FROM factinternetsales UNION SELECT * FROM fact_internet_sales_new;
#Rename the table 
CREATE TABLE  Sales AS SELECT * FROM factinternetsales UNION SELECT * FROM fact_internet_sales_new;
#after creating the sales table  name sales . it should run the table with the help of dcl commmand
select * from sales;
#merge the sales table to dimproduct + dimproductsubcategory + dimproductcategory with the help of alias name
CREATE TABLE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory AS SELECT  sales.ProductKey as salesproductkey, sales.OrderDateKey, sales.DueDateKey, sales.ShipDateKey, sales.CustomerKey, sales.PromotionKey, 
sales.CurrencyKey, sales.SalesTerritoryKey, sales.SalesOrderNumber, sales.SalesOrderLineNumber,
sales.RevisionNumber,sales.OrderQuantity,sales.UnitPrice,sales.ExtendedAmount, 
sales.UnitPriceDiscountPct, sales.DiscountAmount, sales.ProductStandardCost, 
sales.TaxAmt, sales.Freight, sales.CarrierTrackingNumber, 
sales.CustomerPONumber, sales.OrderDate, sales.DueDate, sales.ShipDate,
dimproduct.ProductKey as producttablekey, dimproduct.ProductAlternateKey, 
dimproduct.ProductSubcategoryKey, dimproduct.WeightUnitMeasureCode, 
dimproduct.SizeUnitMeasureCode, dimproduct.EnglishProductName, dimproduct.SpanishProductName, 
dimproduct.FrenchProductName, dimproduct.StandardCost, 
dimproduct.FinishedGoodsFlag, dimproduct.Color, dimproduct.SafetyStockLevel, 
dimproduct.ReorderPoint, dimproduct.ListPrice, dimproduct.Size, dimproduct.SizeRange, 
dimproduct.Weight,dimproduct.DaysToManufacture, dimproduct.ProductLine, dimproduct.DealerPrice, 
dimproduct.Class, dimproduct.Style,dimproduct.ModelName, dimproduct.EnglishDescription, 
dimproduct.FrenchDescription,dimproduct.ChineseDescription,dimproduct.ArabicDescription, 
dimproduct.HebrewDescription, dimproduct.ThaiDescription,dimproduct.GermanDescription, 
dimproduct.JapaneseDescription, dimproduct.TurkishDescription, dimproduct.StartDate,dimproduct.EndDate, 
dimproduct.Status,
dimproductsubcategory.ProductSubcategoryKey as DimProductSubcategoryKey, dimproductsubcategory.ProductSubcategoryAlternateKey, 
dimproductsubcategory.EnglishProductSubcategoryName, dimproductsubcategory.SpanishProductSubcategoryName, dimproductsubcategory.FrenchProductSubcategoryName, 
dimproductsubcategory.ProductCategoryKey, 
dimproductcategory.productcategorykey as Dimproductcategorykey,dimproductcategory.ProductCategoryAlternateKey,dimproductcategory.EnglishProductCategoryName,
dimproductcategory.SpanishProductCategoryName,dimproductcategory.FrenchProductCategoryName
FROM  sales LEFT JOIN  dimproduct ON 
    sales.productkey = dimproduct.productkey
    left join
    dimproductsubcategory on
    dimproduct.productsubcategorykey = dimproductsubcategory.productsubcategorykey
    left join 
    dimproductcategory on
    dimproductcategory.productcategorykey = dimproductsubcategory.productcategorykey;
    
select* from merged_sales_dimproduct_dimproductsubcategory_dimproductcategory;
SELECT COUNT(*) FROM  merged_sales_dimproduct_dimproductsubcategory_dimproductcategory;


update merged_sales_dimproduct_dimproductsubcategory_dimproductcategory 
set FrenchProductCategoryName ="NA" where FrenchProductCategoryName is NULL;

desc merged_sales_dimproduct_dimproductsubcategory_dimproductcategory;
# Month Wise Sales
SELECT YEAR(OrderDate) AS sales_year,MONTH(OrderDate) AS sales_month,
ROUND(SUM(UnitPrice * OrderQuantity), 0) AS total_sales
FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY sales_year, sales_month;
#Day Wise Sales
SELECT DATE(OrderDate) AS sales_date,ROUND(SUM(UnitPrice * OrderQuantity), 0) AS total_sales
FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
GROUP BY DATE(OrderDate)
ORDER BY sales_date;
#Weekend Sales  Sunday,Saturday
SELECT YEAR(OrderDate) AS sales_year,WEEK(OrderDate) AS sales_week,
ROUND(SUM(UnitPrice * OrderQuantity), 0) AS total_weekend_sales
FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
WHERE DAYOFWEEK(OrderDate) IN (1, 7) 
GROUP BY YEAR(OrderDate), WEEK(OrderDate)
ORDER BY sales_year, sales_week;
#Weekday sales
SELECT YEAR(OrderDate) AS sales_year,WEEK(OrderDate) AS sales_week,
ROUND(SUM(UnitPrice * OrderQuantity), 0) AS total_weekend_sales
FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
WHERE DAYOFWEEK(OrderDate) IN (2, 6) 
GROUP BY YEAR(OrderDate), WEEK(OrderDate)
ORDER BY sales_year, sales_week;



;

