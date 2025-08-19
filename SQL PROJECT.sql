CREATE DATABASE blinkitdb;

SELECT * FROM Blinkit_Data


SELECT COUNT(*) FROM Blinkit_Data

UPDATE Blinkit_Data
SET Item_Fat_Content =
CASE
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

SELECT DISTINCT(Item_Fat_Content) FROM Blinkit_Data

-- KPI REQUIREMENTS
--1
SELECT SUM(Total_Sales) AS Total_Sales
FROM Blinkit_Data

SELECT CAST(SUM(Total_Sales)/ 1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions
FROM Blinkit_Data
WHERE Outlet_Establishment_Year = 2022

--2
SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales
FROM Blinkit_Data
WHERE Outlet_Establishment_Year = 2022

--3
SELECT COUNT(*) AS No_Of_Items FROM Blinkit_Data
WHERE Outlet_Establishment_Year = 2022

--4
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) Avg_Rating FROM Blinkit_Data

--GRANULAR REQUIREMENTS

--1
SELECT Item_Fat_Content, 
        CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_Thousands,
        CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) Avg_Rating
FROM Blinkit_Data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC

--2
SELECT TOP 5 Item_Type, 
        CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
        CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) Avg_Rating
FROM Blinkit_Data
GROUP BY Item_Type
ORDER BY Total_Sales ASC

--3
SELECT Outlet_Location_Type, Item_Fat_Content, 
        CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
        CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) Avg_Rating
FROM Blinkit_Data
GROUP BY Outlet_Location_Type, Item_Fat_Content 
ORDER BY Total_Sales ASC

SELECT Outlet_Location_Type,
       ISNULL([Low Fat],0) AS Low_Fat,
       ISNULL([Regular],0) AS Regular
From
(
     SELECT Outlet_Location_Type, Item_Fat_Content, 
        CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
     FROM Blinkit_Data
GROUP BY Outlet_Location_Type, Item_Fat_Content 
) AS SourseTable
PIVOT                              -- pivot help to transform the row to column 
(
    SUM(Total_Sales)
    FOR Item_Fat_Content IN ([Low Fat],[Regular])
)AS PivotTable
ORDER BY Outlet_Location_Type;

--4
SELECT Outlet_Establishment_Year, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) Avg_Rating
FROM Blinkit_Data
GROUP BY Outlet_Establishment_Year 
ORDER BY Total_Sales DESC


--Chart's Requirement

--1
SELECT 
     Outlet_Size,
     CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
     CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL (10,2)) AS Sales_Percentage
FROM Blinkit_Data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

--2
SELECT Outlet_Location_Type, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL (10,2)) AS Sales_Percentage,
       CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) Avg_Rating
FROM Blinkit_Data
GROUP BY Outlet_Location_Type 
ORDER BY Total_Sales DESC

--3
SELECT Outlet_Type, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL (10,2)) AS Sales_Percentage,
       CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) Avg_Rating
FROM Blinkit_Data
GROUP BY Outlet_Type 
ORDER BY Total_Sales DESC