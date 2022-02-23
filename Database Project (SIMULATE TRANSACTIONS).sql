USE Bejibun
GO

-- Untuk setiap sales dan purchase transaction, dibutuhkan data customer, staff, vendor, dan item.
-- Maka sebelum membuat tabel untuk transaction, harus dibuat tabel yang berisi data-data tersebut terlebih dahulu.
-- Setelah itu, baru dapat dibuat tabel untuk sales dan purchase transaction.
-- Tabel untuk transaction detail juga diperlukan agar pengolahan data menjadi lebih efisien.
-- Proses pembuatan tabel sudah dibuat pada file yang bernama 'Database Project (CREATE TABLES)'.

-- Berikut ini adalah simulasi insert data secara satu per satu untuk sales dan purchase transactions
-- Untuk simulasi tiap transactionnya akan terdiri dari 2 query yaitu untuk insert ke tabel SalesTransactions/PurchaseTransactions
-- dan CustomerOrders/PurchaseOrders.

-- Transaction 1
INSERT INTO SalesTransactions VALUES
('SA016','ST003','CU008','2020-05-26');

INSERT INTO CustomerOrders VALUES
('SA016','IT011',5),
('SA016','IT001',10),
('SA016','IT002',4);


-- Transaction 2
INSERT INTO SalesTransactions VALUES
('SA017','ST009','CU004','2020-09-03');

INSERT INTO CustomerOrders VALUES
('SA017','IT003',20);


-- Transaction 3
INSERT INTO SalesTransactions VALUES
('SA018','ST005','CU005','2020-09-13');

INSERT INTO CustomerOrders VALUES
('SA018','IT010',2),
('SA018','IT005',6);


-- Transaction 4
INSERT INTO SalesTransactions VALUES
('SA019','ST001','CU010','2020-11-07');

INSERT INTO CustomerOrders VALUES
('SA019','IT011',2),
('SA019','IT005',2),
('SA019','IT003',5);


-- Transaction 5
INSERT INTO SalesTransactions VALUES
('SA020','ST006','CU008','2020-12-30');

INSERT INTO CustomerOrders VALUES
('SA020','IT013',10);


-- Transaction 6
INSERT INTO PurchaseTransactions VALUES
('PH020','ST005','VE003','2021-01-01',NULL);

INSERT INTO PurchaseOrders VALUES
('PH020','IT004',60),
('PH020','IT006',60);


-- Transaction 7
INSERT INTO SalesTransactions VALUES
('SA021','ST007','CU009','2021-01-25');

INSERT INTO CustomerOrders VALUES
('SA021','IT001',20),
('SA021','IT002',10),
('SA021','IT011',1);


-- Transaction 8
INSERT INTO PurchaseTransactions VALUES
('PH021','ST003','VE006','2021-01-25','2021-02-27');

INSERT INTO PurchaseOrders VALUES
('PH021','IT011',20),
('PH021','IT010',20);


-- Transaction 9
INSERT INTO SalesTransactions VALUES
('SA022','ST006','CU009','2021-02-17');

INSERT INTO CustomerOrders VALUES
('SA022','IT008',10),
('SA022','IT009',10);


-- Transaction 10
INSERT INTO SalesTransactions VALUES
('SA023','ST006','CU007','2021-03-01');

INSERT INTO CustomerOrders VALUES
('SA023','IT003',14);


-- Transaction 11
INSERT INTO SalesTransactions VALUES
('SA024','ST001','CU010','2021-03-01');

INSERT INTO CustomerOrders VALUES
('SA024','IT010',2),
('SA024','IT011',1),
('SA024','IT008',5),
('SA024','IT009',5),
('SA024','IT001',4);


-- Transaction 12
INSERT INTO SalesTransactions VALUES
('SA025','ST002','CU003','2021-03-01');

INSERT INTO CustomerOrders VALUES
('SA025','IT013',5);


-- Transaction 13
INSERT INTO PurchaseTransactions VALUES
('PH022','ST002','VE008','2021-03-01',NULL);

INSERT INTO PurchaseOrders VALUES
('PH022','IT013',30);


-- Transaction 14
INSERT INTO SalesTransactions VALUES
('SA026','ST008','CU005','2021-03-15');

INSERT INTO CustomerOrders VALUES
('SA026','IT015',1),
('SA026','IT011',1),
('SA026','IT010',1);


-- Transaction 15
INSERT INTO SalesTransactions VALUES
('SA027','ST008','CU009','2021-03-15');

INSERT INTO CustomerOrders VALUES
('SA027','IT001',30),
('SA027','IT005',18);


-- Transaction 16
INSERT INTO PurchaseTransactions VALUES
('PH023','ST005','VE002','2021-03-16',NULL);

INSERT INTO PurchaseOrders VALUES
('PH023','IT001',50),
('PH023','IT002',50),
('PH023','IT003',50);


-- Transaction 17
INSERT INTO PurchaseTransactions VALUES
('PH024','ST007','VE001','2021-03-16',NULL);

INSERT INTO PurchaseOrders VALUES
('PH024','IT001',70);


-- Transaction 18
INSERT INTO PurchaseTransactions VALUES
('PH025','ST008','VE003','2021-03-16',NULL);

INSERT INTO PurchaseOrders VALUES
('PH025','IT004',55),
('PH025','IT005',15),
('PH025','IT006',45);

-- Transaction 19
INSERT INTO SalesTransactions VALUES
('SA028','ST008','CU006','2021-03-16');

INSERT INTO CustomerOrders VALUES
('SA028','IT001',7),
('SA028','IT002',4);

-- Transaction 20
INSERT INTO SalesTransactions VALUES
('SA029','ST008','CU006','2021-03-18');

INSERT INTO CustomerOrders VALUES
('SA029','IT001',15);