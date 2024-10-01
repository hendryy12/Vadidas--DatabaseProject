--4.	Query to simulate the transactions processes 

--Retrieves the transaction details for a specific transaction ID:
SELECT th.TransactionId, th.StaffId, th.CustomerId, td.ShoeId, td.Quantity
FROM TransactionHeader th
JOIN TransactionDetail td ON th.TransactionId = td.TransactionId
WHERE th.TransactionId = 'TR031';

-- New Transaction
INSERT INTO TransactionHeader (TransactionId, StaffId, CustomerId, TransactionDate)
VALUES ('TR051', 'ST015', 'CU015', '2023-06-02');

INSERT INTO TransactionDetail (TransactionId, ShoeId, Quantity)
VALUES ('TR051', 'SH018', 5);

--Update transaction details:
UPDATE TransactionDetail
SET Quantity = 10
WHERE TransactionId = 'TR031' AND ShoeId = 'SH001';

--Delete a transaction:
DELETE FROM TransactionDetail
WHERE TransactionId = 'TR051';

DELETE FROM TransactionHeader
WHERE TransactionId = 'TR051';


