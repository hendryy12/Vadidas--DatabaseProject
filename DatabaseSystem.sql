-- 2.	Query to create the database system 
Create Database VadidaS
Go
Use VadidaS
Go

CREATE TABLE MsVendor (
    VendorID CHAR(5) PRIMARY KEY Check (VendorId Like'VE[0-][0-9][0-9]')Not Null,
    VendorName CHAR(255)Not Null,
    VendorAddress VARCHAR(255),
    VendorEmail VARCHAR(255) CHECK (VendorEmail LIKE '%@gmail.com')Not Null,
	VendorPhoneNumber Varchar(20) Check(VendorPhoneNumber Like '%[0-9]%')Not Null,
);

CREATE TABLE MsStaff (
    StaffId CHAR(5) PRIMARY KEY CHECK (StaffId LIKE 'ST[0-9][0-9][0-9]') NOT NULL,
    StaffName VARCHAR(55) NOT NULL CHECK (LEN(StaffName) > 10),
    StaffGender CHAR(10) CHECK (StaffGender IN ('Female', 'Male')) NOT NULL,
    StaffEmail VARCHAR(255) NOT NULL CHECK (StaffEmail LIKE '%@gmail.com'),
    StaffAddress VARCHAR(255) NOT NULL,
    StaffSalary INTEGER CHECK (StaffSalary BETWEEN 120000 AND 500000) NOT NULL
);
Create Table MsCustomer (
CustomerId Char(5) Primary Key Check (CustomerId Like 'CU[0-9][0-9][0-9]')Not Null,
CustomerName Char(255) Not NULL,
CustomerGender Char(255),
CustomerDOB date Not Null,
CustomerAddress Varchar(255)Not Null,
CustomerEmail Varchar(255) Not Null
);

CREATE TABLE MsShoe (
    ShoeId CHAR(5) PRIMARY KEY CHECK (ShoeId LIKE 'SH[0-9][0-9][0-9]') NOT NULL,
    ShoeName CHAR(255) NOT NULL,
    ShoePrice INT CHECK (ShoePrice BETWEEN 50000 AND 949000) NOT NULL,
    ShoeDescription CHAR(255) NOT NULL
);


CREATE TABLE PurchaseHeader (
    PurchaseId CHAR(5) PRIMARY KEY CHECK (PurchaseId LIKE 'PU[0-9][0-9][0-9]') NOT NULL,
    StaffId CHAR(5) FOREIGN KEY REFERENCES MsStaff (StaffId)Not Null,
    VendorId CHAR(5) FOREIGN KEY REFERENCES MsVendor (VendorId)Not Null,
    PurchaseDate DATE Not Null
);
CREATE TABLE PurchaseDetail (
    PurchaseId CHAR(5) FOREIGN KEY REFERENCES PurchaseHeader(PurchaseId)Not Null,
    ShoeId CHAR(5) FOREIGN KEY REFERENCES MsShoe(ShoeId)Not Null,
    Quantity INT CHECK (Quantity >= 0) Not Null
);

CREATE TABLE SalesHeader (
    SalesId CHAR(5) PRIMARY KEY CHECK (SalesId LIKE 'SA[0-9][0-9][0-9]') NOT NULL,
    StaffId CHAR(5) FOREIGN KEY REFERENCES MsStaff(StaffId) NOT NULL,
    CustomerId CHAR(5) FOREIGN KEY REFERENCES MsCustomer(CustomerId) NOT NULL,
    SalesDate DATE NOT NULL,
    Discount INT CHECK (Discount >= 0 AND Discount <= 65)Not Null
);

Create Table SalesDetail(
SalesId Char(5) Foreign Key References SalesHeader(SalesId)Not Null,
ShoeId Char(5) Foreign Key References MsShoe(ShoeId)NOt Null,
Quantity Int CHECK(Quantity >= 0) Not nULL
) ;

Create Table TransactionHeader(
TransactionId Char(5) Primary Key Check(TransactionId Like'TR[0-9][0-9][0-9]')Not Null,
StaffId CHAR(5) FOREIGN KEY REFERENCES MsStaff(StaffId) NOT NULL,
CustomerId CHAR(5) FOREIGN KEY REFERENCES MsCustomer(CustomerId) NOT NULL,
TransactionDate DATE Not Null
);

Create Table TransactionDetail(
TransactionId Char(5) Foreign Key References TransactionHeader(TransactionId)Not Null,
ShoeId Char(5) Foreign Key References MsShoe(ShoeId) Not Null,
Quantity Int Check(Quantity >= 0) Not Null
);









