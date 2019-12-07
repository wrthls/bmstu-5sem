/* Ограничения */
USE VinylShop;
GO

/* Изменяем определение таблицы поставщиков Supliers путем добавления ограничения
первичного ключа и ключа уникальности */
ALTER TABLE dbo.Supliers ADD
CONSTRAINT PK_S PRIMARY KEY (Sno),
CONSTRAINT UK_S UNIQUE (Sname);
GO

/****** Изменяем определение таблицы магазинов Shops путем добавления ограничения
первичного ключа, и ключа CHECK ******/
ALTER TABLE dbo.Shops ADD
CONSTRAINT PK_SH PRIMARY KEY (SHno),
CONSTRAINT Rating_chk CHECK (Rating BETWEEN 1 AND 10);
GO

/****** Изменяем определение таблицы пластинок Disks путем добавления ограничений
ограничений первичного ключа и ключа уникальности ******/
ALTER TABLE dbo.Disks ADD
CONSTRAINT PK_D PRIMARY KEY (Dno);
GO

/****** Изменяем определение таблицы поставок SDSH путем добавления ограничений
первичного ключа и внешних ключей и ограничения CHECK ******/
ALTER TABLE dbo.SDSH ADD
CONSTRAINT SDSHno PRIMARY KEY ( Sno, Dno, SHno ),
CONSTRAINT FK_SP_S FOREIGN KEY(Sno) REFERENCES dbo.Supliers (Sno) ,
CONSTRAINT FK_SP_D FOREIGN KEY(Dno) REFERENCES [dbo].Disks (Dno) ,
CONSTRAINT FK_SP_SH FOREIGN KEY(SHno) REFERENCES dbo.Shops (SHno),
CONSTRAINT Qty_chk CHECK (Qty > 0);
GO