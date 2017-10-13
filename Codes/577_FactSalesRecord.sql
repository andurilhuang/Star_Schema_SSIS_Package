use rhuang92DW

ALTER TABLE [dbo].[FactSalesRecord]  
ADD CONSTRAINT FK_FSR_ProductKey
FOREIGN KEY([ProductKey])
REFERENCES [dbo].[DimProduct] ([ProductKey])

ALTER TABLE [dbo].[FactSalesRecord]  
ADD CONSTRAINT FK_FSR_CustomerKey
FOREIGN KEY([CustomerKey])
REFERENCES [dbo].[DimCustomer] ([CustomerKey])

ALTER TABLE [dbo].[FactSalesRecord] 
ADD CONSTRAINT FK_FSR_StoreKey
FOREIGN KEY([StoreKey])
REFERENCES [dbo].[DimStore] ([StoreKey])

ALTER TABLE [dbo].[FactSalesRecord] 
ADD CONSTRAINT FK_FSR_ChannelKey
FOREIGN KEY([ChannelKey])
REFERENCES [dbo].[DimChannel] ([ChannelKey])

ALTER TABLE [dbo].[FactSalesRecord] 
ADD CONSTRAINT FK_FSR_ResellerKey
FOREIGN KEY([ResellerKey])
REFERENCES [dbo].[DimReseller] ([ResellerKey])

ALTER TABLE [dbo].[FactSalesRecord] 
ADD CONSTRAINT FK_FSR_LocationKey
FOREIGN KEY([LocationKey])
REFERENCES [dbo].[DimLocation] ([LocationKey])

DELETE dbo.FactSalesRecord

DBCC CHECKIDENT('dbo.FactSalesRecord', RESEED, 0);
GO

Insert into dbo.FactSalesRecord 

Select
ISNULL(dcu.CustomerKey,-1), 
dch.ChannelKey,
ISNULL(dst.StoreKey,-1), 
ISNULL(dr.ResellerKey,-1),
ISNULL(dl.LocationKey,-1), 
dp.ProductKey, dd.DimDateID, 
dp.WholeSalePrice, dp.Price, sd.SalesQuantity, sd.SalesAmount, dp.Cost
FROM dbo.StageSalesHeader AS sh
LEFT JOIN dbo.StageSalesDetail as sd
 ON sd.SalesHeaderID = sh.SalesHeaderID
LEFT JOIN dbo.DimCustomer AS dcu
 ON sh.CustomerID = dcu.Customer_ID
LEFT JOIN dbo.DimChannel AS dch
 ON sh.ChannelID = dch.Channel_ID
LEFT JOIN dbo.DimStore AS dst
 ON sh.StoreID = dst.Store_ID
LEFT JOIN dbo.DimReseller AS dr
 ON sh.ResellerID = dr.Reseller_ID
LEFT JOIN dbo.DimProduct AS dp
 ON sd.ProductID = dp.Product_ID
LEFT JOIN dbo.DimDate AS dd
 ON sh.Date = dd.FullDate
JOIN dbo.DimLocation as dl
 ON dl.LocationKey = dr.LocationKey
 or dl.LocationKey = dst.LocationKey
 or dl.LocationKey = dcu.LocationKey
 




