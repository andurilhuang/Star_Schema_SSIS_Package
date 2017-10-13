--Empty FactTargetProduct--
DELETE dbo.FactTargetProduct;

--Add constraints back--
ALTER TABLE [dbo].[FactTargetProduct] 
ADD CONSTRAINT FK_FTP_Product
FOREIGN KEY([ProductKey])
REFERENCES [dbo].[DimProduct] ([ProductKey])

--Reseed an identity column--
DBCC CHECKIDENT('dbo.FactTargetProduct', RESEED, 0);
GO

--Load FactTargetProduct--
INSERT INTO dbo.FactTargetProduct
SELECT dp.ProductKey, dd.DimDateID, 
CAST(tp.SalesQuantityTarget as numeric)/365.000

FROM dbo.StageTargetProduct AS tp
LEFT JOIN dbo.DimProduct AS dp
 ON tp.ProductID =  dp.ProductKey
LEFT JOIN dbo.DimDate AS dd
 ON tp.Year = dd.CalendarYear
