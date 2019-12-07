BULK INSERT VinylShop.dbo.Disks
FROM '/tables/D_table.txt'
WITH ( 
    DATAFILETYPE = 'char', 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR =';', 
    CHECK_CONSTRAINTS
    );
GO

BULK INSERT VinylShop.dbo.SDSH
FROM '/tables/SDSH_table.txt'
WITH ( 
    DATAFILETYPE = 'char', 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR =';', 
    CHECK_CONSTRAINTS
    );
GO

BULK INSERT VinylShop.dbo.Shops
FROM '/tables/SH_table.txt'
WITH ( 
    DATAFILETYPE = 'char', 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR =';', 
    CHECK_CONSTRAINTS
    );
GO

BULK INSERT VinylShop.dbo.Supliers
FROM '/tables/S_table.txt'
WITH ( 
    DATAFILETYPE = 'char', 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR =';', 
    CHECK_CONSTRAINTS
    );