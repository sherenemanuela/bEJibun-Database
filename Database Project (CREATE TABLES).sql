CREATE DATABASE Bejibun
GO

USE Bejibun
GO

CREATE TABLE Customers(
	CustomerId CHAR(5) NOT NULL,
	CustomerName VARCHAR (50) NOT NULL,
	CustomerGender VARCHAR (10) NOT NULL,
	CustomerPhone VARCHAR (15) NOT NULL,
	CustomerDOB DATE NOT NULL,

	-- PRIMARY KEY
	CONSTRAINT CustomersPK 
		PRIMARY KEY (CustomerId),

	-- CONSTRAINTS
	CONSTRAINT CheckCustomerId
		CHECK (CustomerId LIKE 'CU[0-9][0-9][0-9]'),

	CONSTRAINT CheckCustomerGender 
		CHECK (CustomerGender in ('Male', 'Female')),

	CONSTRAINT CheckDOB
		CHECK (CustomerDOB >= '1990-01-01' AND CustomerDOB <= GETDATE())
)

CREATE TABLE Staffs(
	StaffId CHAR(5) NOT NULL,
	StaffName VARCHAR(50) NOT NULL,
	StaffGender VARCHAR(10) NOT NULL,
	StaffPhone VARCHAR(15) NOT NULL,
	StaffSalary INT NOT NULL,

	-- PRIMARY KEY
	CONSTRAINT StaffsPK 
		PRIMARY KEY(StaffId),

	-- CONSTRAINTS
	CONSTRAINT CheckStaffId
		CHECK (StaffId LIKE 'ST[0-9][0-9][0-9]'),

	CONSTRAINT CheckStaffGender 
		CHECK (StaffGender in ('Male', 'Female')),

	CONSTRAINT StaffSalaryCheck 
		CHECK(StaffSalary > 0)
)

CREATE TABLE Vendors(
	VendorId CHAR(5) NOT NULL,
	VendorName VARCHAR(50) NOT NULL,
	VendorPhone VARCHAR (15) NOT NULL,
	VendorAddress VARCHAR(50) NOT NULL,
	VendorEmail VARCHAR (50) NOT NULL,

	-- PRIMARY KEY
	CONSTRAINT VendorsPK 
		PRIMARY KEY (VendorId),
	
	-- CONSTRAINTS
	CONSTRAINT CheckVendorId
		CHECK (VendorId LIKE 'VE[0-9][0-9][0-9]'),

	CONSTRAINT CheckVendorAddress 
		CHECK (VendorAddress LIKE '% Street'),

	CONSTRAINT CheckVendorEmail
		CHECK (
			VendorEmail LIKE '%@%'AND
			VendorEmail NOT LIKE '@%' AND
			VendorEmail LIKE '%.com' AND 
			VendorEmail NOT LIKE '%@.com%'
		)
)

CREATE TABLE ItemTypes (
	ItemTypeId CHAR (5) NOT NULL,
	ItemTypeName VARCHAR(50) NOT NULL,

	-- PRIMARY KEY
	CONSTRAINT ItemTypePK
		PRIMARY KEY (itemTypeId),

	-- CONSTRAINTS
	CONSTRAINT CheckItemTypeId
		CHECK (ItemTypeId LIKE 'IP[0-9][0-9][0-9]'),
	CONSTRAINT CheckTypeName
		CHECK (LEN(ItemTypeName) >= 4)
)

CREATE TABLE Items(

	ItemId CHAR (5) NOT NULL,
	ItemTypeId CHAR(5) NOT NULL,
	ItemName VARCHAR(50) NOT NULL,
	ItemPrice INT NOT NULL,
	MinimumQty INT NOT NULL,   --minimum purchase utk customer

	-- PRIMARY KEY
	CONSTRAINT ItemsPK
		PRIMARY KEY (ItemId),
	
	-- FOREIGN KEY
	CONSTRAINT ItemTypeFK 
		FOREIGN KEY (ItemTypeId)
		REFERENCES ItemTypes(ItemTypeId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	-- CONSTRAINT
	CONSTRAINT CheckItemId
		CHECK (ItemId LIKE 'IT[0-9][0-9][0-9]'),

	CONSTRAINT CheckItemPrice
		CHECK (ItemPrice > 0),
)

CREATE TABLE SalesTransactions(

	SalesTransactionId CHAR(5) NOT NULL,
	StaffId CHAR(5) NOT NULL,
	CustomerId CHAR(5) NOT NULL,
	SalesDate DATE NOT NULL,

	-- PRIMARY KEY
	CONSTRAINT SalesTransactionsPK 
		PRIMARY KEY (SalesTransactionId),

	-- FOREIGN KEYS
	CONSTRAINT SalesTransactionFK1 
		FOREIGN KEY (StaffId)
		REFERENCES Staffs(StaffId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	CONSTRAINT SalesTransactionFK2 
		FOREIGN KEY (CustomerId)
		REFERENCES Customers(CustomerId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	-- CONSTRAINT
	CONSTRAINT CheckSalesTransactionId
		CHECK (SalesTransactionId LIKE 'SA[0-9][0-9][0-9]')
)
GO

CREATE FUNCTION GetMinimumQuantity(@ItemId CHAR(5))
RETURNS INT
AS BEGIN
	RETURN (SELECT MinimumQty FROM Items WHERE ItemId LIKE @ItemId);
END
GO

CREATE TABLE CustomerOrders(
	SalesTransactionId CHAR(5) NOT NULL,
	ItemId CHAR (5) NOT NULL,
	ItemQuantity INT NOT NULL,

	-- PRIMARY KEY
	CONSTRAINT CustomerOrdersPK
		PRIMARY KEY (SalesTransactionId, ItemId),

	-- FOREIGN KEYS
	CONSTRAINT CustomerOrdersFK 
		FOREIGN KEY (SalesTransactionId)
		REFERENCES SalesTransactions(SalesTransactionId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	CONSTRAINT CustomerOrdersFK2 
		FOREIGN KEY (ItemId)
		REFERENCES Items(ItemId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	-- CONSTRAINT
	CONSTRAINT CheckQuantity
		CHECK (ItemQuantity >= dbo.GetMinimumQuantity(ItemId))
)

CREATE TABLE PurchaseTransactions(
	PurchaseTransactionId CHAR (5) NOT NULL,
	StaffId CHAR (5) NOT NULL,
	VendorId CHAR (5) NOT NULL,
	PurchaseDate DATE NOT NULL,
	ArrivalDate DATE,

	-- PRIMARY KEY
	CONSTRAINT PurchaseTransactionsPK
		PRIMARY KEY (PurchaseTransactionId),

	-- FOREIGN KEYS
	CONSTRAINT PurchaseTransactionsFK1
		FOREIGN KEY (StaffId)
		REFERENCES Staffs(StaffId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	CONSTRAINT PurchaseTransactionsFK2
		FOREIGN KEY (VendorId)
		REFERENCES Vendors(VendorId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	-- CONSTRAINT
	CONSTRAINT CheckPurchaseTransactionId
		CHECK (PurchaseTransactionId LIKE 'PH[0-9][0-9][0-9]'),

	CONSTRAINT CheckArrivalDate
		CHECK (ArrivalDate >= PurchaseDate)
)

CREATE TABLE PurchaseOrders(
	PurchaseTransactionId CHAR(5) NOT NULL,
	ItemId CHAR (5) NOT NULL,
	ItemQuantity INT NOT NULL,

	-- PRIMARY KEY
	CONSTRAINT PurchaseOrdersPK
		PRIMARY KEY (PurchaseTransactionId, ItemId),

	-- FOREIGN KEYS
	CONSTRAINT PurchaseOrdersFK 
		FOREIGN KEY (PurchaseTransactionId)
		REFERENCES PurchaseTransactions(PurchaseTransactionId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	CONSTRAINT PurchaseOrdersFK2 
		FOREIGN KEY (ItemId)
		REFERENCES Items(ItemId)
		ON UPDATE CASCADE
		ON DELETE CASCADE
)