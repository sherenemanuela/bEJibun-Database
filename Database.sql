CREATE DATABASE Final_Project_Sell

USE Final_Project_Sell

CREATE TABLE SalesTransactions(

	SalesTransactionId CHAR(5) NOT NULL,
	StaffId CHAR(5) NOT NULL,
	CustomerId CHAR(5) NOT NULL,
	SalesDate DATE NOT NULL,

	--Primary Key
	CONSTRAINT SalesTransactionsPK 
		PRIMARY KEY(SalesTransactionID),

	--Foreign Key

	CONSTRAINT SalesTransactionFK1 
		FOREIGN KEY(StaffId)
		REFERENCES Staffs(StaffId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	CONSTRAINT SalesTransactionFK2 
		FOREIGN KEY(CustomerId)
		REFERENCES Customers(CustomerId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	--CONSTRAINT

	CONSTRAINT CheckSalesTransactionId
		Check (SalesTransactionId LIKE 'SA[0-9][0-9][0-9]')
)

CREATE TABLE Staffs(
	StaffId CHAR(5) NOT NULL,
	StaffName VARCHAR(255) NOT NULL,
	StaffGender VARCHAR(10) NOT NULL,
	StaffPhone VARCHAR(15) NOT NULL,
	StaffSalary INT NOT NULL,

	--KEY
	CONSTRAINT StaffsPK PRIMARY KEY(StaffId),

	--Constraint

	CONSTRAINT CheckStaffGender 
		CHECK (StaffGender in ('Male','Female')),

	CONSTRAINT CheckStaffId
		CHECK (StaffId LIKE 'ST[0-9][0-9][0-9]'),

	CONSTRAINT StaffSalaryCheck 
		CHECK(StaffSalary > 0)
)

CREATE TABLE Customers(
	
	CustomerId CHAR(5) NOT NULL,
	CustomerName VARCHAR (255) NOT NULL,
	CustomerGender VARCHAR (10) NOT NULL,
	CustomerPhone VARCHAR (14) NOT NULL,
	CustomerDOB DATE NOT NULL,

	--Primary Keys
	CONSTRAINT CustomersPK PRIMARY KEY (CustomerId),

	--CONSTRAINT

	CONSTRAINT CheckCustomerId
		CHECK (CustomerId LIKE 'CU[0-9][0-9][0-9]'),

	CONSTRAINT CheckCustomerGender 
		CHECK (CustomerGender in ('Male','Female')),

	CONSTRAINT CheckDOB
		CHECK (CustomerDOB >= '1-1-1990' AND CustomerDOB <= GETDATE())
)

CREATE TABLE CustomerOrders(
	SalesTransactionId CHAR(5) NOT NULL,
	ItemId CHAR (5) NOT NULL,
	ItemQuantity INT NOT NULL,

	--KEYS

	CONSTRAINT CustomerOrdersPK
		PRIMARY KEY (SalesTransactionId, ItemId),

	CONSTRAINT CustomerOrdersFK 
		FOREIGN KEY (SalesTransactionId)
		REFERENCES SalesTransactions(SalesTransactionId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	CONSTRAINT CustomerOrdersFK2 
		FOREIGN KEY (ItemId)
		REFERENCES Items(ItemId)
		ON UPDATE CASCADE
		ON DELETE CASCADE
)

CREATE TABLE Items(

	ItemId CHAR (5) NOT NULL,
	ItemTypeId CHAR(5) NOT NULL,
	ItemName VARCHAR(255) NOT NULL,
	ItemPrice INT NOT NULL,
	MinimumQty INT NOT NULL,

	--KEYS
	CONSTRAINT ItemsPK
		PRIMARY KEY (ItemId),

	CONSTRAINT ItemTypeFK 
		FOREIGN KEY (ItemTypeId)
		REFERENCES ItemTypes(ItemTypeId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	--CONSTRAINT
	CONSTRAINT CheckItemId
		CHECK (ItemId LIKE 'IT[0-9][0-9][0-9]'),

	CONSTRAINT CheckItemPrice
		CHECK (ItemPrice > 0),
)

CREATE TABLE ItemTypes (
	ItemTypeId CHAR (5) NOT NULL,
	ItemTypeName VARCHAR(255) NOT NULL,

	--KEYS
	CONSTRAINT ItemTypePK
		PRIMARY KEY (itemTypeId),

	--CONSTRAINTS
	CONSTRAINT CheckItemTypeId
		CHECK (ItemTypeId LIKE 'IP[0-9][0-9][0-9]'),
	CONSTRAINT CheckTypeName
		CHECK(LEN(ItemTypeName)>= 4)
)

CREATE TABLE Vendors(
	VendorId CHAR(5) NOT NULL,
	VendorName VARCHAR(255) NOT NULL,
	VendorPhone VARCHAR (15) NOT NULL,
	VendorAddress VARCHAR(255) NOT NULL,
	VendorEmail VARCHAR (255) NOT NULL,

	--Primary Key

	CONSTRAINT VendorsPK 
		PRIMARY KEY (VendorID),
	
	--CONSTRAINT

	CONSTRAINT CheckVendorAddress 
		CHECK (VendorAddress LIKE '% Street'),

	CONSTRAINT CheckVendorEmail
		CHECK (
			VendorEmail LIKE '%@%'AND
			NOT VendorEmail LIKE '@%' AND
			VendorEmail LIKE '%.com' AND 
			NOT VendorEmail LIKE '%@.com'
		)
)

CREATE TABLE PurchaseTransactions(
	PurchaseTransactionId CHAR (5) NOT NULL,
	StaffId CHAR (5) NOT NULL,
	VendorId CHAR (5) NOT NULL,
	PurchaseDate DATE NOT NULL,
	ArrivalDate DATE,

	--PRIMARY KEYS
	CONSTRAINT PurchaseTransactionsPK
		PRIMARY KEY (PurchaseTransactionId),

	--FOREIGN KEYS
	CONSTRAINT PurcahseTransactionsFK1
		FOREIGN KEY (StaffId)
		REFERENCES Staffs(StaffId)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	CONSTRAINT PurcahseTransactionsFK2
		FOREIGN KEY (VendorId)
		REFERENCES Vendors(VendorId)
		ON UPDATE CASCADE
		ON DELETE CASCADE
)

CREATE TABLE PurchaseOrders(
	PurchaseTransactionId CHAR(5) NOT NULL,
	ItemId CHAR (5) NOT NULL,
	ItemQuantity INT NOT NULL,

	--KEYS

	CONSTRAINT PurchaseOrdersPK
		PRIMARY KEY (PurchaseTransactionId, ItemId),

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