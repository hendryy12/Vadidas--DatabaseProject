--10 CASES FOR VADIDAS

Use VadidaS
--1.Display CustomerID, First Name (obtained from the first word of CustomerName), CustomerGender, and Total Item Purchased (obtained from the total of Quantity) for each CustomerGender equals to Male and Total Item Purchased is greater than 1.
SELECT
    c.CustomerId,
    LEFT(c.CustomerName, CHARINDEX(' ', c.CustomerName + ' ') - 1) AS FirstName,
    c.CustomerGender,
    SUM(td.Quantity) AS TotalItemPurchased
FROM
    TransactionHeader th
JOIN
    TransactionDetail td ON th.TransactionId = td.TransactionId
JOIN
    MsCustomer c ON th.CustomerId = c.CustomerId
WHERE
    c.CustomerGender = 'Male'
GROUP BY
    c.CustomerId, c.CustomerName, c.CustomerGender
HAVING
    SUM(td.Quantity) > 1;

--2.	Display Shoes Id (obtained by replacing 'SH' with 'Shoes ' from ShoesID), StaffID, Transaction Day (obtained from the day of SalesDate), ShoesName, and Total Sold (obtained from the total of Quantity) for each ShoesPrice greater than 120000 and Total Sold must be even number.
SELECT 
    CONCAT('Shoes ', REPLACE(MsShoe.ShoeId, 'SH', '')) AS ShoesId,
    SalesHeader.StaffId,
    DATEPART(DAY, SalesHeader.SalesDate) AS TransactionDay,
    MsShoe.ShoeName,
    SUM(SalesDetail.Quantity) AS TotalSold
FROM 
    SalesDetail
    JOIN MsShoe ON SalesDetail.ShoeId = MsShoe.ShoeId
    JOIN SalesHeader ON SalesDetail.SalesId = SalesHeader.SalesId
WHERE 
    MsShoe.ShoePrice > 120000
GROUP BY 
    MsShoe.ShoeId, SalesHeader.StaffId, DATEPART(DAY, SalesHeader.SalesDate), MsShoe.ShoeName
HAVING 
    SUM(SalesDetail.Quantity) % 2 = 0;

--3.	Display Staff Number (obtained from displaying StaffID as integer), Staff Name (obtained from StaffName in uppercase format), StaffSalary, Total Purchase Made (obtained from total purchase made by vendor), and Max Shoes Purchased (obtained from maximum of Quantity) for each StaffSalary greater than 150000 and Total Purchase Made greater than 2.

SELECT CAST(SUBSTRING(s.StaffID, 3, LEN(s.StaffID)) AS INT) AS [Staff Number],
       UPPER(s.StaffName) AS [Staff Name],
       s.StaffSalary,
       SUM(sd.Quantity) AS [Total Purchase Made],
       MAX(sd.Quantity) AS [Max Shoes Purchased]
FROM MsStaff s
Join SalesHeader SH oN Sh.StaffId = S.StaffId
JOIN SalesDetail sd ON SD.SalesId = SH.SalesId
GROUP BY s.StaffID, s.StaffName, s.StaffSalary
HAVING s.StaffSalary > 150000 AND SUM(sd.Quantity) > 2;

--4.	Display VendorID, Vendor Name (obtained from VendorName ends with ' Vendor'), Vendor Mail (obtained by replacing ‘@gmail.com’ with ‘@mail.co.id’ from VendorEmail in uppercase format), Total Shoes Sold (obtained from total of Quantity), and Minimum Shoes Sold (obtained from minimum of Quantity) for each Total Shoes Sold greater than 13 and Minimum Shoes Sold greater than 10.
SELECT V.VendorID,
       CONCAT(V.VendorName, ' Vendor') AS [Vendor Name],
       UPPER(REPLACE(V.VendorEmail, '@gmail.com', '@mail.co.id')) AS [Vendor Mail],
       SUM(Sd.Quantity) AS [Total Shoes Sold],
       MIN(SD.Quantity) AS [Minimum Shoes Sold]
FROM MSVendor V
jOIN PurchaseHeader ph On pH.VendorId = v.VendorID
Join MsStaff MS oN ms.StaffId = ph.StaffId
JOIN SalesHeader SH on MS.StaffId = sh.StaffId
Join SalesDetail SD oN SD.SalesId = SH.SalesId

GROUP BY V.VendorID, V.VendorName, V.VendorEmail
HAVING SUM(SD.Quantity) > 13 AND MIN(SD.Quantity) > 5;


--5.	Display VendorID, Vendor Name (obtained from VendorName ends with ' Company'), VendorPhone, Purchase Month (obtained from the name of the month of PurchaseDate), and Quantity for each transaction that occurs in April and Quantity is greater than the average of all purchasing quantity.

SELECT V.VendorID,
       CONCAT(V.VendorName,'Company') AS [Vendor Name],
       V.VendorPhoneNumber,
       DATENAME(MONTH, PH.PurchaseDate) AS [Purchase Month],
       PD.Quantity
FROM PurchaseDetail PD
JOIN PurchaseHeader PH ON PD.PurchaseID = PH.PurchaseID
JOIN MSVendor V ON PH.VendorID = V.VendorID
WHERE MONTH(PH.PurchaseDate) = 4
  AND PD.Quantity > (SELECT AVG(Quantity) FROM PurchaseDetail)

 -- 6.	Display Invoice Number (obtained from replacing 'SA' with 'Invoice 'from SalesID),  Sales Year (obtained from the year of the SalesDate) ShoesName, ShoesPrice, Total Item (obtained from Quantity ends with ' piece(s)') for each ShoesName that contains 'c' and ShoesPrice is greater than average of all ShoesPrice.
 SELECT 
    REPLACE(SH.SalesID, 'SA', 'Invoice ') AS [Invoice Number],
    YEAR(SH.SalesDate) AS [Sales Year],
    S.ShoeName,
    S.ShoePrice,
    CONCAT(SD.Quantity, ' piece(s)') AS [Total Item]
FROM 
    SalesHeader SH
JOIN 
    SalesDetail SD ON SH.SalesID = SD.SalesID
JOIN 
    MsShoe S ON SD.ShoeID = S.ShoeID
WHERE 
    S.ShoeName LIKE '%c%' AND
    S.ShoePrice > (SELECT AVG(ShoePrice) FROM MsShoe)

--7.	Display PurchaseID, StaffID, Staff Name (obtained from StaffName in uppercase format), Purchase Date (obtained from PurchaseDate in 'dd/mm/yyyy' format), and Total Expenses (obtained from calculating the total of multiplication between ShoesPrice and Quantity and starts with 'Rp. ') for each Total Expenses greater than the average of multiplication between ShoesPrice and Quantity and last three digit of StaffID must be an odd number.
SELECT
    P.PurchaseID,
    P.StaffID,
    UPPER(S.StaffName) AS [Staff Name],
    FORMAT(P.PurchaseDate, 'dd/MM/yyyy') AS [Purchase Date],
    CONCAT('Rp. ', SUM(MS.ShoePrice * PD.Quantity)) AS [Total Expenses]
FROM
    PurchaseHeader P
    JOIN MsStaff S ON P.StaffID = S.StaffID
    JOIN PurchaseDetail PD ON P.PurchaseID = PD.PurchaseID
    JOIN MsShoe MS ON PD.ShoeID = MS.ShoeID
GROUP BY
    P.PurchaseID,
    P.StaffID,
    S.StaffName,
    P.PurchaseDate
HAVING
    SUM(ms.ShoePrice * pD.Quantity) > (SELECT AVG(ms.ShoePrice * PD.Quantity) FROM PurchaseDetail PD JOIN MsShoe MS ON PD.ShoeID = MS.ShoeID)
    AND RIGHT(P.StaffID, 1) % 2 = 1;


--8.	Display SalesID, StaffID, First Name (obtained from the first word of StaffName), Last Name (obtained from the last word of StaffName), and Total Revenue (obtained from the total of multiplication between Quantity and ShoesPrice) for each StaffGender that equals 'Female' and ShoesPrice is greater than the average of all shoes price.


SELECT SH.SalesID,
       SH.StaffID,
       LEFT(S.STAFFNAME, CHARINDEX(' ', S.STAFFNAME) - 1) AS [First Name],
       RIGHT(S.STAFFNAME, CHARINDEX(' ', REVERSE(S.STAFFNAME)) - 1) AS [Last Name],
       SUM(SD.Quantity * MS.ShoePrice) AS [Total Revenue]
FROM SalesHeader SH
JOIN SalesDetail SD ON SH.SalesID = SD.SalesID
JOIN MsShoe MS ON SD.ShoeID = MS.ShoeID
JOIN MsStaff S ON SH.StaffID = S.StaffID
WHERE S.StaffGender = 'Female' AND MS.ShoePrice > (SELECT AVG(ShoePrice) FROM MsShoe)
GROUP BY SH.SalesID, SH.StaffID, S.STAFFNAME ;

--9.	Create a view named 'Vendor Max Transaction View' to display Vendor Number (obtained by replacing 'VE' with 'Vendor ' from VendorID), Vendor Name (obtained from VendorName in lower case format), Total Transaction Made (obtained from the total transaction made), Maximum Quantity (obtained from maximum of Quantity) for each VendorName that contains 'a' and Maximum Quantity greater than 20.
CREATE VIEW [Vendor Max Transaction View] AS
SELECT REPLACE(V.VendorID, 'VE', 'Vendor ') AS [Vendor Number],
       LOWER(V.VendorName) AS [Vendor Name],
       COUNT(*) AS [Total Transaction Made],
       MAX(PD.Quantity) AS [Maximum Quantity]
FROM PurchaseHeader PH
JOIN MSVendor V ON PH.VendorID = V.VendorID
Join PurchaseDetail PD On Pd.PurchaseId = PH.PurchaseId
GROUP BY V.VendorID, V.VendorName
HAVING V.VendorName LIKE '%a%' AND MAX(PD.Quantity) > 20;

Go

SELECT * FROM [Vendor Max Transaction View];

--10.	Create view named 'Shoes Minimum Transaction View' to display SalesID, SalesDate, StaffName, Staff Email (obtained from StaffEmail in uppercase format), Minimum Shoes Sold (obtained from minimum of Quantity), and Total Shoes Sold (obtained from total of Quantity) for SalesDate that occurs after 2020 and ShoesPrice greater than 10000
CREATE VIEW [Shoes Minimum Transaction View] AS
SELECT SH.SalesID,
       SH.SalesDate,
       S.StaffName,
       UPPER(S.StaffEmail) AS [Staff Email],
       MIN(SD.Quantity) AS [Minimum Shoes Sold],
       SUM(SD.Quantity) AS [Total Shoes Sold]
FROM SalesHeader SH
JOIN SalesDetail SD ON SH.SalesID = SD.SalesID
JOIN MsStaff S ON SH.StaffID = S.StaffID
JOIN MsShoe MS ON SD.ShoeID = MS.ShoeID
WHERE SH.SalesDate > '2020-01-01' AND MS.ShoePrice > 10000
GROUP BY SH.SalesID, SH.SalesDate, S.StaffName, S.StaffEmail;
Go
SELECT * FROM [Shoes Minimum Transaction View];

