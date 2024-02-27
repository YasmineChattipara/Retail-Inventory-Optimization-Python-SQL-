USE Retail_Inventory;

--Display Sales Table
SELECT * FROM Sales;

--Delete NULL Values
SELECT *
FROM Sales
WHERE SalesDollars Is NULL;


SELECT *
FROM Sales
WHERE ExciseTax Is NULL;

DELETE FROM Sales
WHERE SalesDollars IS NULL OR ExciseTax IS NULL;

--Checking for Duplicate Rows in Sales Table
SELECT InventoryId,
	Store,
	Brand,
	Description,
	Size,
	SalesQuantity,
	SalesDollars,
	SalesPrice,
	SalesDate,
	Volume,
	Classification,
	ExciseTax,
	VendorNo,
	VendorName,
	COUNT(*)
FROM Sales
GROUP BY InventoryId,
	Store,
	Brand,
	Description,
	Size,
	SalesQuantity,
	SalesDollars,
	SalesPrice,
	SalesDate,
	Volume,
	Classification,
	ExciseTax,
	VendorNo,
	VendorName
HAVING COUNT(*) > 1;

--Standardize Text Column
--Remove Training and leading spaces in Description,Vendor Name
UPDATE Sales 
SET Description = TRIM(Description),
	VendorName = TRIM(VendorName);

--Standardize Date Column
UPDATE Sales
SET SalesDate = CONVERT(date, SalesDate, 101);

--Standardize Size into a uniform unit (mL)
ALTER TABLE Sales
ALTER COLUMN Size NVARCHAR(50) NULL;

--Standardize Size into a uniform unit (mL)
ALTER TABLE Sales
ALTER COLUMN Size NVARCHAR(50) NULL;

-- Update the Size column with standardized values, avoiding setting NULL values
--Standardize Size into a uniform unit (mL)
ALTER TABLE Sales
ALTER COLUMN Size NVARCHAR(50) NULL;

-- Update the Size column with standardized values, avoiding setting NULL values
UPDATE Sales
SET Size = 
    CASE 
        -- Remove leading and trailing spaces
        WHEN Size LIKE '%+%' THEN TRIM(SUBSTRING(Size, 1, CHARINDEX('+', Size) - 1))  -- If '+' sign, consider only main component
        -- Convert 'oz' to mL by multiplying by 29.5735
        WHEN Size LIKE '%oz%' THEN TRY_CONVERT(VARCHAR(255), FLOOR(TRY_CONVERT(DECIMAL, REPLACE(Size, 'oz', '')) * 29.5735)) + 'mL'
        -- Extract number of packs and calculate total volume
        WHEN Size LIKE '% mL % Pk' THEN 
            TRY_CONVERT(VARCHAR(255), FLOOR(TRY_CONVERT(DECIMAL, SUBSTRING(Size, 1, CHARINDEX(' ', Size) - 1)) * TRY_CONVERT(DECIMAL, SUBSTRING(Size, CHARINDEX(' ', Size) + 1, CHARINDEX('Pk', Size) - CHARINDEX(' ', Size) - 1)))) + 'mL'
        -- Convert 'gal' to mL by multiplying by 3785.41
        WHEN Size LIKE '%gal%' THEN TRY_CONVERT(VARCHAR(255), FLOOR(TRY_CONVERT(DECIMAL, REPLACE(Size, 'gal', '')) * 3785.41)) + 'mL'
        -- Strip away units and convert to milliliters
        WHEN Size LIKE '%l%' THEN TRY_CONVERT(VARCHAR(255), FLOOR(TRY_CONVERT(DECIMAL, REPLACE(Size, 'l', '')) * 1000)) + 'mL'
        ELSE TRIM(REPLACE(Size, 'ml', ''))  -- Strip away 'ml' and keep numeric part
    END
WHERE Size IS NOT NULL; -- Add condition to avoid setting Size column to NULL

-- Update the Size column with NULL values for the rows where Size is NULL
UPDATE Sales
SET Size = NULL
WHERE Size IS NULL;

select * from sales where size is not null;

--Display Inventory Start Table
SELECT * FROM Inventory_Begin;

--Delete NULL Values
SELECT *
FROM Inventory_Begin
WHERE Price Is NULL;

DELETE FROM Inventory_Begin
WHERE Price IS NULL

--Checking for Duplicate Rows in Inventory Start Table
SELECT InventoryId,
	Store,
	City,
	Brand,
	Description,
	Size,
	onHand,
	Price,
	StartDate,
	COUNT(*)
FROM Inventory_Begin
GROUP BY InventoryId,
	Store,
	City,
	Brand,
	Description,
	Size,
	onHand,
	Price,
	StartDate
HAVING COUNT(*) > 1;

--Standardize Text Column
--Remove Training and leading spaces in City, Description
UPDATE Inventory_Begin
SET City = TRIM(City),
	Description = TRIM(Description);

--Standardize Date Column
UPDATE Inventory_Begin
SET startDate = CONVERT(date, startDate, 101);

--Standardize Size into a uniform unit (mL)
ALTER TABLE Inventory_Begin
ALTER COLUMN Size NVARCHAR(50) NULL;
UPDATE Inventory_Begin
SET Size = 
    CASE 
        -- Remove leading and trailing spaces
        WHEN Size LIKE '%+%' THEN TRIM(SUBSTRING(Size, 1, CHARINDEX('+', Size) - 1))  -- If '+' sign, consider only main component
        -- Convert 'oz' to mL by multiplying by 29.5735
        WHEN Size LIKE '%oz%' THEN TRY_CONVERT(VARCHAR(255), FLOOR(TRY_CONVERT(DECIMAL, REPLACE(Size, 'oz', '')) * 29.5735)) + 'mL'
        -- Extract number of packs and calculate total volume
        WHEN Size LIKE '% mL % Pk' THEN 
            TRY_CONVERT(VARCHAR(255), FLOOR(TRY_CONVERT(DECIMAL, SUBSTRING(Size, 1, CHARINDEX(' ', Size) - 1)) * TRY_CONVERT(DECIMAL, SUBSTRING(Size, CHARINDEX(' ', Size) + 1, CHARINDEX('Pk', Size) - CHARINDEX(' ', Size) - 1)))) + 'mL'
        -- Convert 'gal' to mL by multiplying by 3785.41
        WHEN Size LIKE '%gal%' THEN TRY_CONVERT(VARCHAR(255), FLOOR(TRY_CONVERT(DECIMAL, REPLACE(Size, 'gal', '')) * 3785.41)) + 'mL'
        -- Strip away units and convert to milliliters
        WHEN Size LIKE '%l%' THEN TRY_CONVERT(VARCHAR(255), FLOOR(TRY_CONVERT(DECIMAL, REPLACE(Size, 'l', '')) * 1000)) + 'mL'
        ELSE TRIM(REPLACE(Size, 'ml', ''))  -- Strip away 'ml' and keep numeric part
    END
WHERE Size IS NOT NULL; -- Add condition to avoid setting Size column to NULL

SELECT * FROM Inventory_Begin where size is not null;
--Display Inventory End Table

SELECT * FROM Inventory_End;

--Delete NULL Values
SELECT *
FROM Inventory_End
WHERE City Is NULL;

DELETE FROM Inventory_End
WHERE City IS NULL;

--Check for Duplicate rows in Inventory End Table
SELECT InventoryId,
	Store,
	City,
	Brand,
	Description,
	Size,
	onHand,
	Price,
	endDate,
	COUNT(*)
FROM Inventory_End
GROUP BY InventoryId,
	Store,
	City,
	Brand,
	Description,
	Size,
	onHand,
	Price,
	EndDate
HAVING COUNT(*) > 1;

--Standardize Text Column
--Remove Training and leading spaces in City, Description
UPDATE Inventory_End
SET City = TRIM(City),
	Description = TRIM(Description);

--Standardize Date Column
UPDATE Inventory_End
SET endDate = CONVERT(date, endDate, 101);

--Standardize Size into a uniform unit (mL)
ALTER TABLE Inventory_End
ALTER COLUMN Size NVARCHAR(50) NULL;
UPDATE Inventory_End
SET Size = 
    CASE 
        -- Remove leading and trailing spaces
        WHEN Size LIKE '%+%' THEN TRIM(SUBSTRING(Size, 1, CHARINDEX('+', Size) - 1))  -- If '+' sign, consider only main component
        -- Convert 'oz' to mL by multiplying by 29.5735
        WHEN Size LIKE '%oz%' THEN TRY_CONVERT(VARCHAR(255), FLOOR(TRY_CONVERT(DECIMAL, REPLACE(Size, 'oz', '')) * 29.5735)) + 'mL'
        -- Extract number of packs and calculate total volume
        WHEN Size LIKE '% mL % Pk' THEN 
            TRY_CONVERT(VARCHAR(255), FLOOR(TRY_CONVERT(DECIMAL, SUBSTRING(Size, 1, CHARINDEX(' ', Size) - 1)) * TRY_CONVERT(DECIMAL, SUBSTRING(Size, CHARINDEX(' ', Size) + 1, CHARINDEX('Pk', Size) - CHARINDEX(' ', Size) - 1)))) + 'mL'
        -- Convert 'gal' to mL by multiplying by 3785.41
        WHEN Size LIKE '%gal%' THEN TRY_CONVERT(VARCHAR(255), FLOOR(TRY_CONVERT(DECIMAL, REPLACE(Size, 'gal', '')) * 3785.41)) + 'mL'
        -- Strip away units and convert to milliliters
        WHEN Size LIKE '%l%' THEN TRY_CONVERT(VARCHAR(255), FLOOR(TRY_CONVERT(DECIMAL, REPLACE(Size, 'l', '')) * 1000)) + 'mL'
        ELSE TRIM(REPLACE(Size, 'ml', ''))  -- Strip away 'ml' and keep numeric part
    END
WHERE Size IS NOT NULL; -- Add condition to avoid setting Size column to NULL

SELECT * FROM Inventory_End;



SELECT
    ib.InventoryId,
    ib.Store,
    ib.Brand,
    ib.Description,
    COALESCE(ib.Size, ie.Size) AS Size,  -- Use COALESCE to handle null values
    ib.OnHand AS InventoryBegin,
    ie.OnHand AS InventoryEnd,
    s.SalesQuantity AS Sales,
    s.SalesDate
FROM 
    Inventory_Begin ib
JOIN 
    Inventory_End ie ON ib.InventoryId = ie.InventoryId
JOIN 
    Sales s ON ib.InventoryId = s.InventoryId
WHERE ib.Size IS NOT NULL OR ie.Size IS NOT NULL ;
