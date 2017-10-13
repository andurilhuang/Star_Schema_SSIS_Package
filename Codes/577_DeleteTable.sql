use rhuang92DW

delete dbo.FactSalesRecord
DBCC CHECKIDENT('dbo.FactSalesRecord', RESEED, 0);
GO

delete dbo.FactTargetChannelResellerStore
DBCC CHECKIDENT('dbo.FactTargetChannelResellerStore', RESEED, 0);
GO

delete dbo.FactTargetProduct
DBCC CHECKIDENT('dbo.FactTargetProduct', RESEED, 0);
GO

delete dbo.DimCustomer
DBCC CHECKIDENT('dbo.DimCustomer', RESEED, 0);
GO

delete dbo.DimReseller
DBCC CHECKIDENT('dbo.DimReseller', RESEED, 0);
GO

delete dbo.DimStore
DBCC CHECKIDENT('dbo.DimStore', RESEED, 0);
GO

delete dbo.DimLocation
DBCC CHECKIDENT('dbo.DimLocation', RESEED, 0);
GO

delete dbo.DimChannel
DBCC CHECKIDENT('dbo.DimChannel', RESEED, 0);
GO

delete dbo.DimCustomer
DBCC CHECKIDENT('dbo.DimCustomer', RESEED, 0);
GO

delete dbo.DimProduct
DBCC CHECKIDENT('dbo.DimProduct', RESEED, 0);
GO