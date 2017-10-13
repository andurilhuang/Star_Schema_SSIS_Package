---Load Dim Channel----

ALTER TABLE [dbo].[FactSalesRecord]  
DROP CONSTRAINT FK_FSR_ChannelKey

ALTER TABLE [dbo].[FactTargetChannelResellerStore] 
DROP CONSTRAINT FK_FSTCRS_Channel

DELETE dbo.DimChannel;

--Load an unknown member record--
SET IDENTITY_INSERT dbo.DimChannel ON;

INSERT INTO dbo.DimChannel
(
ChannelKey,
Channel_ID,
ChannelName,
ChannelCategory_ID,
ChannelCategory
)
VALUES
(
-1, -- I use -1 as an ID for my unknown members so I always know what they are
0,
'Unknown',
0,
'Unknown'
)
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.DimChannel OFF;
GO

--Reseed an identity column--
DBCC CHECKIDENT('dbo.DimChannel', RESEED, 0);
GO

INSERT INTO dbo.DimChannel
SELECT c.ChannelID, c.Channel,
cc.ChannelCategoryID, cc.ChannelCategory

FROM dbo.StageChannel AS c
INNER JOIN dbo.StageChannelCategory AS cc
ON c.ChannelCategoryID = cc.ChannelCategoryID;
GO

----Load DimCustomer------

ALTER TABLE [dbo].[FactSalesRecord]  
DROP CONSTRAINT FK_FSR_CustomerKey

DELETE dbo.DimCustomer
SET IDENTITY_INSERT dbo.DimCustomer ON;

INSERT INTO dbo.DimCustomer
(
CustomerKey,
LocationKey,
Customer_ID,
Segment_ID,
Segment,
SubSegment_ID,
SubSegment,
FirstName,
LastName,
Gender,
EmailAddress,
PhoneNmber,
Address
)
VALUES
(
-1, -- I use -1 as an ID for my unknown members so I always know what they are
-1,
newid(),
0,
'Unknown',
0,
'Unknown',
'Unknown',
'Unknown',
'Unknown',
'Unknown',
'Unknown',
'Unknown'
)
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.DimCustomer OFF;
GO

--Reseed an identity column--
DBCC CHECKIDENT('dbo.DimCustomer', RESEED, 0);
GO

INSERT INTO dbo.DimCustomer
SELECT l.LocationKey, c.CustomerID, ss.SegmentID, ss.Segment, sss.SubSegmentID, sss.SubSegment, c.FirstName, c.LastName, c.Gender, c.EmailAddress, c.PhoneNumber, l.Address
FROM dbo.StageCustomer AS c
INNER JOIN dbo.DimLocation AS l
ON c.Address = l.Address AND c.City = l.City AND c.StateProvince = l.StateProvince AND c.Country = l.Country 
AND c.PostalCode = l.PostalCode
INNER JOIN dbo.StageSubSegment AS sss
ON sss.SubSegmentID = c.SubSegmentID
INNER JOIN dbo.StageSegment as ss
on ss.SegmentID = sss.SegmentID

GO

------Load DimLocation---

ALTER TABLE [dbo].[FactSalesRecord]  
DROP CONSTRAINT FK_FSR_LocationKey

ALTER TABLE [dbo].[DimCustomer]  
DROP CONSTRAINT FK_DimCustomer_DimLocation

ALTER TABLE [dbo].[DimReseller]  
DROP CONSTRAINT FK_DimReseller_DimLocation

ALTER TABLE [dbo].[DimStore]  
DROP CONSTRAINT FK_DimStore_DimLocation

DELETE DimLocation
SET IDENTITY_INSERT dbo.DimLocation ON;

INSERT INTO dbo.DimLocation
(
LocationKey,
PostalCode,
City,
StateProvince,
Country,
Address
)
VALUES
(
-1, -- I use -1 as an ID for my unknown members so I always know what they are
0,
'Unknown',
'Unknown',
'Unknown',
'Unknown'
)
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.DimLocation OFF;
GO

--Reseed an identity column--
DBCC CHECKIDENT('dbo.DimLocation', RESEED, 0);
GO

INSERT INTO dbo.DimLocation
SELECT PostalCode, City, StateProvince, Country, Address  FROM dbo.StageCustomer
UNION 
SELECT PostalCode, City, StateProvince, Country, Address FROM dbo.StageReseller
UNION
SELECT PostalCode, City, StateProvince, Country, Address FROM dbo.StageStore;
GO

ALTER TABLE [dbo].[DimCustomer]  
ADD CONSTRAINT FK_DimCustomer_DimLocation
FOREIGN KEY([LocationKey])
REFERENCES [dbo].[DimLocation] ([LocationKey])

ALTER TABLE [dbo].[DimReseller]  
ADD CONSTRAINT FK_DimReseller_DimLocation
FOREIGN KEY([LocationKey])
REFERENCES [dbo].[DimLocation] ([LocationKey])

ALTER TABLE [dbo].[DimStore]  
ADD CONSTRAINT FK_DimStore_DimLocation
FOREIGN KEY([LocationKey])
REFERENCES [dbo].[DimLocation] ([LocationKey])

------Load DimProduct----

ALTER TABLE [dbo].[FactSalesRecord]  
DROP CONSTRAINT FK_FSR_ProductKey
ALTER TABLE [dbo].[FactTargetProduct] 
DROP CONSTRAINT FK_FTP_Product
--Empty DimProduct--
DELETE DimProduct;

--Load an unknown member record--
SET IDENTITY_INSERT dbo.DimProduct ON;

INSERT INTO dbo.DimProduct
(
ProductKey,
Product_ID,
ProductName,
ProductCategory_ID,
ProductCategory,
ProductType_ID,
ProductType,
Color,
Style,
UnitofMeasure,
UnitofMeasure_ID,
Weight,
Price,
Cost,
WholeSalePrice
)
VALUES
(
-1, -- I use -1 as an ID for my unknown members so I always know what they are
0,
'Unknown',
0,
'Unknown',
0,
'Unknown',
'Unkwown',
'Unknown',
'Unknown',
0,
0,
0,
0,
0
)

-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.DimProduct OFF;
GO

--Reseed an identity column--
DBCC CHECKIDENT('dbo.DimProduct', RESEED, 0);
GO

INSERT INTO dbo.DimProduct
SELECT 
p.ProductID, p.Product, 
pc.ProductCategoryID, pc.ProductCategory,
pt.ProductTypeID, pt.ProductType,
p.Color, p.Style, u.UnitofMeasure, u.UnitofMeasureID,
p.Weight, p.Price, p.Cost, p.WholesalePrice
FROM dbo.StageProduct AS p
INNER JOIN dbo.StageUnitofMeasure AS u
ON p.UnitofMeasureID = u.UnitofMeasureID
INNER JOIN dbo.StageProductType AS pt
ON p.ProductTypeID = pt.ProductTypeID
INNER JOIN dbo.StageProductCategory AS pc
ON pt.ProductCategoryID = pc.ProductCategoryID;
GO

---------Load DimReseller-------

USE [rhuang92DW]

ALTER TABLE [dbo].[FactSalesRecord] 
DROP CONSTRAINT FK_FSR_ResellerKey
ALTER TABLE [dbo].[FactTargetChannelResellerStore] 
DROP CONSTRAINT FK_FSTCRS_Reseller

DELETE [dbo].[DimReseller]
SET IDENTITY_INSERT [dbo].[DimReseller] ON;

INSERT INTO [dbo].[DimReseller]
(
ResellerKey,
LocationKey,
Reseller_ID,
ResellerName,
ResellerContact,
EmailAddress,
PhoneNumber,
Address
)
VALUES
(
-1, -- I use -1 as an ID for my unknown members so I always know what they are
-1,
NEWID(),
'Unknown',
'Unknown',
'Unknown',
'Unknown',
'Unknown'
)
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.DimReseller OFF;
GO

--Reseed an identity column--
DBCC CHECKIDENT('dbo.DimReseller', RESEED, 0);
GO

INSERT INTO dbo.DimReseller
SELECT l.LocationKey, r.ResellerID, r.ResellerName,  r.Contact, r.EmailAddress, r.PhoneNumber, l.Address
FROM dbo.StageReseller AS r
INNER JOIN dbo.DimLocation AS l
ON r.Address = l.Address AND r.City = l.City AND r.StateProvince = l.StateProvince AND r.Country = l.Country 
AND r.PostalCode = l.PostalCode
GO


-------Load DimStore-------

ALTER TABLE [dbo].[FactSalesRecord] 
DROP CONSTRAINT FK_FSR_StoreKey

ALTER TABLE [dbo].[FactTargetChannelResellerStore]
DROP CONSTRAINT FK_FSTCRS_Store
--Empty DimStore--

DELETE dbo.DimStore

--Load an unknown member record--
SET IDENTITY_INSERT dbo.DimStore ON;

INSERT INTO dbo.DimStore
(
StoreKey,
LocationKey,
Store_ID,
Segment_ID,
Segment,
SubSegment_ID,
SubSegment,
StoreNumber,
PhoneNumber,
Address
)
VALUES
(
-1, -- I use -1 as an ID for my unknown members so I always know what they are
-1,
0,
0,
'Unknown',
0,
'Unknown',
0,
'Unknown',
'Unknown'
)
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.DimStore OFF;
GO

--Reseed an identity column--
DBCC CHECKIDENT('dbo.DimStore', RESEED, 0);
GO

INSERT INTO dbo.DimStore
SELECT l.LocationKey, s.StoreID, ss.SegmentID, ss.Segment, sss.SubSegmentID, sss.SubSegment, s.StoreNumber,s.PhoneNumber, s.Address
FROM dbo.StageStore AS s
INNER JOIN dbo.DimLocation AS l
ON s.Address = l.Address AND s.City = l.City AND s.StateProvince = l.StateProvince AND s.Country = l.Country 
AND s.PostalCode = l.PostalCode
INNER JOIN dbo.StageSubSegment AS sss
ON sss.SubSegmentID = s.SubSegmentID
INNER JOIN dbo.StageSegment as ss
on ss.SegmentID = sss.SegmentID
GO

