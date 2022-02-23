USE Bejibun
GO

-- Case 1
SELECT ItemName, ItemPrice, [Item Total] = SUM(ItemQuantity)
FROM Items i
JOIN PurchaseOrders po ON i.ItemId = po.ItemId
JOIN PurchaseTransactions pt ON po.PurchaseTransactionId = pt.PurchaseTransactionId
WHERE ArrivalDate IS NULL
GROUP BY i.ItemId, ItemName, ItemPrice   --kita groupby itemid untuk jaga2 kalo ada nama dan harga yang sama. jd id harus digroup meskipun ga ditampilkan dalam dalam querynya
HAVING SUM(ItemQuantity) > 100
ORDER BY [Item Total] DESC

-- Case 2
SELECT VendorName, 
[Domain Name] = RIGHT(VendorEmail, CHARINDEX('@', REVERSE(VendorEmail)) - 1),
[Average Purchased Item] = AVG(ItemQuantity)
FROM Vendors v
JOIN PurchaseTransactions pt ON v.VendorId = pt.VendorId
JOIN PurchaseOrders po ON pt.PurchaseTransactionId = po.PurchaseTransactionId
WHERE VendorAddress LIKE 'Food Street' 
AND RIGHT(VendorEmail, CHARINDEX('@', REVERSE(VendorEmail)) - 1) NOT LIKE 'gmail.com'
GROUP BY v.VendorId, VendorName, VendorEmail  -- disini jg groupby vendorid supaya menghindari kalo ada vendor yg punya name sama email yg sama jd 1 row

-- Case 3
SELECT MONTH (st.SalesDate) as [Month],MIN(co.ItemQuantity) [Minimum Quantity Sold], MAX(co.ItemQuantity) [Maximum Quantity Sold]
FROM SalesTransactions as st
JOIN CustomerOrders as co on st.SalesTransactionId=co.SalesTransactionId
JOIN Items i ON co.ItemId = i.ItemId
JOIN ItemTypes it ON i.ItemTypeId = it.ItemTypeId
WHERE YEAR(st.SalesDate)=2019 AND it.ItemTypeName NOT IN ('Food','Drink')
GROUP BY st.SalesDate, st.SalesTransactionId
-- nmor 3 ini kita menganggap bahwa setiap transaksi di 2019 yang bukan food atau drink kita cari minimal item dan maximalnya itemnya

-- Case 4
SELECT
[Staff Number] = REPLACE(s.StaffId,'ST', 'Staff '),
StaffName,
[Salary] = CONCAT('Rp.', StaffSalary),
[Sales Count] = COUNT(DISTINCT st.SalesTransactionId),
[Average Sales Quantity] = SUM(ItemQuantity) / COUNT(DISTINCT st.SalesTransactionId) -- kita gunakan cara ini untuk melihat rata-rata quantity transaksi yang dilakukan. karena function AVG() bakal melakukan (SUM(Quantity)/banyaknya row yang muncul dalam tabel customerOrder) bukan dibagi byk transaksi. secara logika bakal aneh kalo dibagi brp banyak row, jadi kita gunakan cara ini.
FROM Staffs s
JOIN SalesTransactions st ON s.StaffId = st.StaffId
JOIN CustomerOrders co ON st.SalesTransactionId = co.SalesTransactionId
JOIN Customers c ON st.CustomerId = c.CustomerId
WHERE MONTH(SalesDate) = 2
AND StaffGender NOT LIKE CustomerGender
GROUP BY s.StaffId, s.StaffName, s.StaffSalary

-- 5
SELECT
[Customer Initial] = CONCAT(LEFT(CustomerName, 1), RIGHT(CustomerName, 1)),
[Transaction Date] = CONVERT(VARCHAR, SalesDate, 107),
[Sales Quantity] = SUM(ItemQuantity)
FROM SalesTransactions st
JOIN Customers c ON st.CustomerId = c.CustomerId
JOIN CustomerOrders co ON st.SalesTransactionId = co.SalesTransactionId,
(
	SELECT SUM(ItemQuantity) / COUNT(DISTINCT SalesTransactionId) AS average
	FROM CustomerOrders
	--kita cari dlu avg per transaction dengan subquery karena tdk bsa menggunakan function AVG() secara langsung
) AS a
WHERE CustomerGender LIKE 'Female'
GROUP BY CustomerName, SalesDate, st.SalesTransactionId, a.average
HAVING SUM(ItemQuantity) > a.average

-- 6
SELECT
[ID] = LOWER(pt.VendorId),
VendorName,
[Phone Number] = STUFF(VendorPhone, 1, 1, '+62')
FROM PurchaseTransactions pt
JOIN Vendors v ON pt.VendorId = v.VendorId
JOIN PurchaseOrders po ON pt.PurchaseTransactionId = po.PurchaseTransactionId,
(
	SELECT SUM(ItemQuantity) AS qty
	FROM PurchaseOrders
	GROUP BY PurchaseTransactionid 
) AS a
WHERE CAST(RIGHT(ItemId, 3) AS INT) % 2 != 0
GROUP BY pt.PurchaseTransactionid, pt.VendorId, VendorName, VendorPhone 
HAVING SUM(ItemQuantity) > MIN(qty)

-- 7
SELECT 
StaffName, 
VendorName, 
[PurchaseID] = pt.PurchaseTransactionId,
[Total Purchased Quantity] = SUM(ItemQuantity),
[Ordered Day] = CONCAT(DATEDIFF(DAY, PurchaseDate, GETDATE()), ' Days ago')
FROM PurchaseTransactions pt
JOIN Staffs s ON pt.StaffId = s.StaffId
JOIN Vendors v ON pt.VendorId = v.VendorId
JOIN PurchaseOrders po ON pt.PurchaseTransactionId = po.PurchaseTransactionId,
(
	SELECT MAX(qty) AS maxQty
	FROM
	(
		SELECT SUM(ItemQuantity) AS qty
		FROM PurchaseOrders po
		JOIN PurchaseTransactions pt ON po.PurchaseTransactionId = pt.PurchaseTransactionId
		WHERE DATEDIFF(DAY, PurchaseDate, ArrivalDate) < 7
		GROUP BY po.PurchaseTransactionId
	) AS b
) AS a
GROUP BY StaffName, VendorName, pt.PurchaseTransactionId, PurchaseDate, maxQty
HAVING SUM(ItemQuantity) > maxQty

-- 8
SELECT TOP (2)
[Day] = DATENAME(WEEKDAY, SalesDate),
[Item Sales Amount] = COUNT(co.ItemId)
FROM SalesTransactions st
JOIN CustomerOrders co ON st.SalesTransactionId = co.SalesTransactionId
JOIN Items i ON co.ItemId = i.ItemId,
(
	SELECT AVG(ItemPrice) AS average
	FROM Items i
	JOIN ItemTypes it ON i.ItemTypeId = it.ItemTypeId
	WHERE ItemTypeName IN ('Electronic','Gadgets')
) AS a
WHERE ItemPrice < average
GROUP BY st.SalesTransactionId, SalesDate
ORDER BY [Item Sales Amount]

GO
-- 9
CREATE VIEW [Customer Statistic by Gender] AS
SELECT 
[CustomerGender] = a.gender,
[Maximum Sales] = MAX(a.Qty),
[Minimum Sales] = MIN(a.Qty)
FROM
(
	SELECT CustomerGender AS gender,
	SUM(ItemQuantity) AS Qty
	FROM SalesTransactions st
	JOIN CustomerOrders co ON st.SalesTransactionId = co.SalesTransactionId
	JOIN Customers c ON st.CustomerId = c.CustomerId
	WHERE YEAR(CustomerDOB) BETWEEN 1998 AND 1999
	GROUP BY st.SalesTransactionId, CustomerGender
	HAVING SUM(ItemQuantity) BETWEEN 10 AND 50
) AS a
GROUP BY a.gender
GO

-- 10
CREATE VIEW [Item Type Statistic] AS
SELECT UPPER(itt.ItemTypeName) as [Item Type],AVG(it.ItemPrice) [Average Price], COUNT(it.ItemId) [Number of Item Variety]
FROM Items as it
JOIN ItemTypes as itt ON itt.ItemTypeId =it.ItemTypeId
WHERE itt.ItemTypeName LIKE('F%') AND it.MinimumQty>5
GROUP BY UPPER(itt.ItemTypeName), itt.ItemTypeId -- kita juga group berdasarkan item type id untuk jaga-jaga kalo ada itemtype yang namanya sama meskipun tidak dipilih sebagai column dlm hasil query

GO