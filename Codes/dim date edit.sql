use rhuang92DW
ALTER TABLE [dbo].[FactSalesRecord]  
DROP CONSTRAINT FK_FSR_DateKey

ALTER TABLE [dbo].[FactTargetProduct]  
DROP CONSTRAINT FK_FTP_Date

ALTER TABLE [dbo].[FactTargetChannelResellerStore] 
DROP CONSTRAINT FK_FSTCRS_Date

delete DimDate

DBCC CHECKIDENT('DimDate', RESEED, 0);
GO
EXEC InsDimDateYearly 2013

EXEC InsDimDateYearly 2014

ALTER TABLE [dbo].[FactSalesRecord] 
ADD CONSTRAINT FK_FSR_DateKey
FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([DimDateID])

ALTER TABLE [dbo].[FactTargetProduct] 
ADD CONSTRAINT FK_FTP_Date
FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([[DimDateID])

ALTER TABLE [dbo].[FactTargetChannelResellerStore] 
ADD CONSTRAINT FK_FSTCRS_Date
FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([[DimDateID])

