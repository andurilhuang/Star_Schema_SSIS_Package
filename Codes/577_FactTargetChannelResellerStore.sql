-----------------------------------FactTargetChannelResellerStore-----------------------------------

--Empty FactTargetChannelResellerStore--  
DELETE dbo.FactTargetChannelResellerStore;

--Add constraints back--
ALTER TABLE [dbo].[FactTargetChannelResellerStore] 
ADD CONSTRAINT FK_FSTCRS_Channel
FOREIGN KEY([ChannelKey])
REFERENCES [dbo].[DimChannel] ([ChannelKey])

ALTER TABLE [dbo].[FactTargetChannelResellerStore]
ADD CONSTRAINT FK_FSTCRS_Reseller
FOREIGN KEY([ResellerKey])
REFERENCES [dbo].[DimReseller] ([ResellerKey])

ALTER TABLE [dbo].[FactTargetChannelResellerStore]
ADD CONSTRAINT FK_FSTCRS_Store
FOREIGN KEY([StoreKey])
REFERENCES [dbo].[DimStore] ([StoreKey])
GO
 
--Handling abnormal values--
UPDATE dbo.StageTargetChannelResellerandStore
SET TargetName = 'On-line'
WHERE TargetName = 'Online Sales';

UPDATE dbo.StageTargetChannelResellerandStore
SET TargetName = 'Mississipi Distributors'
WHERE TargetName = 'Mississippi Distributors';
GO

--Reseed an identity column--
DBCC CHECKIDENT('dbo.FactTargetChannelResellerStore', RESEED, 0);
GO

--Load FactTargetChannelResellerStoret--
INSERT INTO dbo.FactTargetChannelResellerStore
SELECT 
ISNULL(dst.StoreKey, -1),
ISNULL(dr.ResellerKey, -1),
ISNUll(dc.ChannelKey,-1),
dd.DimDateID,
stcrs.TargetName,
CAST(stcrs.TargetSalesAmount as numeric)/365.0000

FROM dbo.StageTargetChannelResellerandStore AS stcrs
LEFT JOIN dbo.DimStore AS dst
ON SUBSTRING(stcrs.TargetName, 14, 16) = CAST(dst.StoreNumber AS NVARCHAR)
LEFT JOIN dbo.DimReseller AS dr
ON stcrs.TargetName = dr.ResellerName
LEFT JOIN dbo.DimChannel AS dc
ON stcrs.TargetName = dc.ChannelName
LEFT JOIN dbo.DimDate AS dd
ON stcrs.Year = dd.CalendarYear;
GO  

UPDATE dbo.FactTargetChannelResellerStore
 	SET ChannelKey = 1
 	WHERE StoreKey IN (2, 3, 5 ,6);

UPDATE dbo.FactTargetChannelResellerStore
 	SET ChannelKey = 3
 	WHERE StoreKey IN (1, 4);

UPDATE dbo.FactTargetChannelResellerStore
 	SET ChannelKey = 5
 	WHERE StoreKey = 1;

UPDATE dbo.FactTargetChannelResellerStore
	SET ChannelKey = 4
 	WHERE StoreKey = 2;