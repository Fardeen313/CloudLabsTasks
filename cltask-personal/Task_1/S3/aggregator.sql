SELECT
    Region,
    SUM(Amount) AS TotalSales,

    SUM(CASE WHEN Category='Electronics' THEN Amount ELSE 0 END) AS ElectronicsSales,
    SUM(CASE WHEN Category='Furniture' THEN Amount ELSE 0 END) AS FurnitureSales,
    SUM(CASE WHEN Category='Clothing' THEN Amount ELSE 0 END) AS ClothingSales

FROM Orders
GROUP BY Region
ORDER BY Region;