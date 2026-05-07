CREATE DATABASE SFTMS_DB3sa;
USE SFTMS_DB3sa;

/* ===============================
0. MASTER KEY & CERTIFICATE
=============================== */

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongMasterKey@2026';

CREATE CERTIFICATE DataCert WITH SUBJECT = 'Encrypt Sensitive Data';

CREATE SYMMETRIC KEY DataKey WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE DataCert;

/* ===============================
   1. ORGANIZATION & ACCESS (1–8)
   =============================== */
   CREATE TABLE Branches(
    BranchID INT IDENTITY PRIMARY KEY,
    BranchName NVARCHAR(100),
    City NVARCHAR(50),
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive','Pending','Deleted')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50)
);

CREATE TABLE Departments(
    DepartmentID INT IDENTITY PRIMARY KEY,
    DepartmentName NVARCHAR(100),
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive','Deleted')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50)
);

CREATE TABLE Employees(
    EmployeeID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    CNIC VARBINARY(256),
    Phone VARBINARY(256),
    Email NVARCHAR(100),
    BranchID INT,
    DepartmentID INT,
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive','Suspended','Deleted')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE Roles(
    RoleID INT IDENTITY PRIMARY KEY,
    RoleName NVARCHAR(50),
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50)
);

CREATE TABLE Users(
    UserID INT IDENTITY PRIMARY KEY,
    Username NVARCHAR(50),
    PasswordHash VARBINARY(256),
    EmployeeID INT,
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive','Locked')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE UserRoles(
    UserRoleID INT IDENTITY PRIMARY KEY,
    UserID INT,
    RoleID INT,
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE LoginLogs(
    LogID INT IDENTITY PRIMARY KEY,
    UserID INT,
    LoginTime DATETIME DEFAULT GETDATE(),
    Success BIT,
    Status NVARCHAR(20)
        CHECK (Status IN ('Success','Failed','Locked')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Permissions(
    PermissionID INT IDENTITY PRIMARY KEY,
    PermissionName NVARCHAR(100),
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive','Deprecated')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50)
);

/* ===============================
   2. CUSTOMER & ACCOUNTS (9–15)
   =============================== */

   CREATE TABLE Customers(
    CustomerID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(100),
    CNIC VARBINARY(256), 
    Phone VARBINARY(256),  
    City NVARCHAR(50),
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive','Blocked')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50)
);

CREATE TABLE KYC(
    KYCID INT IDENTITY PRIMARY KEY,
    CustomerID INT,
    DocumentType NVARCHAR(50),
    Status NVARCHAR(20)
        CHECK (Status IN ('Pending','Verified','Rejected')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE AccountTypes(
    AccountTypeID INT IDENTITY PRIMARY KEY,
    TypeName NVARCHAR(50),
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50)
);

CREATE TABLE Accounts(
    AccountID INT IDENTITY PRIMARY KEY,
    CustomerID INT,
    AccountTypeID INT,
    Balance DECIMAL(18,2)
        CHECK (Balance >= 0),
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive','Dormant','Closed')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (AccountTypeID) REFERENCES AccountTypes(AccountTypeID)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE Cards(
    CardID INT IDENTITY PRIMARY KEY,
    AccountID INT,

    CardType NVARCHAR(50)
        CHECK (CardType IN ('Debit Card','Credit Card','Virtual Card')),

    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Blocked','Expired')),

    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),

    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
        ON UPDATE CASCADE 
        ON DELETE CASCADE
);

CREATE TABLE Beneficiaries(
    BeneficiaryID INT IDENTITY PRIMARY KEY,
    CustomerID INT,

    BankName NVARCHAR(100),
    AccountNo VARBINARY(256),

    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Pending','Blocked')),

    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),

    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
        ON UPDATE CASCADE 
        ON DELETE CASCADE
);

CREATE TABLE Limits(
    LimitID INT IDENTITY PRIMARY KEY,
    AccountID INT,

    DailyLimit DECIMAL(18,2)
        CHECK (DailyLimit > 0),

    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Suspended')),

    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
        ON UPDATE CASCADE 
        ON DELETE CASCADE
);


/* ===============================
   3. TRANSACTIONS (16–25)
   =============================== */

CREATE TABLE TransactionTypes(
    TransactionTypeID INT IDENTITY PRIMARY KEY,
    TypeName NVARCHAR(50),
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Created_By NVARCHAR(50)
);

CREATE TABLE Transactions(
    TransactionID INT IDENTITY PRIMARY KEY,
    AccountID INT,
    TransactionTypeID INT,
    Amount DECIMAL(18,2)
        CHECK (Amount > 0),
    TxnDate DATETIME,
    Status NVARCHAR(20)
        CHECK (Status IN ('Success','Failed','Pending')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Created_By NVARCHAR(50),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    FOREIGN KEY (TransactionTypeID) REFERENCES TransactionTypes(TransactionTypeID)
);

CREATE TABLE InternalTransfers(
    TransferID INT IDENTITY PRIMARY KEY,

    FromAccount INT,
    ToAccount INT,

    Amount DECIMAL(18,2)
        CHECK (Amount > 0),

    Status NVARCHAR(20)
        CHECK (Status IN ('Pending','Completed','Failed')),

    Is_Enable BIT,

    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,

    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),

    FOREIGN KEY (FromAccount) REFERENCES Accounts(AccountID)
        ON UPDATE CASCADE 
        ON DELETE NO ACTION,

    FOREIGN KEY (ToAccount) REFERENCES Accounts(AccountID)
);

CREATE TABLE ExternalTransfers(
    TransferID INT IDENTITY PRIMARY KEY,

    FromAccount INT,
    BeneficiaryID INT,

    Amount DECIMAL(18,2)
        CHECK (Amount > 0),

    Status NVARCHAR(20)
        CHECK (Status IN ('Pending','Completed','Rejected')),

    Is_Enable BIT,

    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,

    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),

    FOREIGN KEY (FromAccount) REFERENCES Accounts(AccountID)
        ON UPDATE CASCADE 
        ON DELETE NO ACTION,

    FOREIGN KEY (BeneficiaryID) REFERENCES Beneficiaries(BeneficiaryID)
);

CREATE TABLE BillPayments(
    BillID INT IDENTITY PRIMARY KEY,

    AccountID INT,

    Utility NVARCHAR(50)
        CHECK (Utility IN ('Electricity','Gas','Water','Internet','Telephone')),

    Amount DECIMAL(18,2)
        CHECK (Amount > 0),

    Status NVARCHAR(20)
        CHECK (Status IN ('Paid','Unpaid','Failed')),

    Is_Enable BIT,

    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,

    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),

    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE MobileTopups(
    TopupID INT IDENTITY PRIMARY KEY,

    AccountID INT,

    MobileNo NVARCHAR(20)
        CHECK (MobileNo LIKE '03%'),

    Amount DECIMAL(18,2)
        CHECK (Amount BETWEEN 50 AND 5000),

    Status NVARCHAR(20)
        CHECK (Status IN ('Success','Failed','Pending')),

    Is_Enable BIT,

    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,

    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),

    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE MerchantPayments(
    MerchantPaymentID INT IDENTITY PRIMARY KEY,

    AccountID INT,

    MerchantName NVARCHAR(100),

    Amount DECIMAL(18,2)
        CHECK (Amount > 0),

    Status NVARCHAR(20)
        CHECK (Status IN ('Success','Failed','Refunded')),

    Is_Enable BIT,

    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,

    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),

    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE ATMTransactions(
    ATMID INT IDENTITY PRIMARY KEY,

    AccountID INT,

    Amount DECIMAL(18,2)
        CHECK (Amount BETWEEN 500 AND 50000),

    Status NVARCHAR(20)
        CHECK (Status IN ('Success','Failed','Reversed')),

    Is_Enable BIT,

    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,

    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),

    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE POSTransactions(
    POSID INT IDENTITY PRIMARY KEY,

    AccountID INT,

    Amount DECIMAL(18,2)
        CHECK (Amount > 0),

    Status NVARCHAR(20)
        CHECK (Status IN ('Approved','Declined')),

    Is_Enable BIT,

    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,

    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),

    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE Charges(
    ChargeID INT IDENTITY PRIMARY KEY,

    AccountID INT,

    ChargeAmount DECIMAL(18,2)
        CHECK (ChargeAmount > 0),

    Status NVARCHAR(20)
        CHECK (Status IN ('Applied','Waived')),

    Is_Enable BIT,

    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,

    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),

    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

/* ===============================
   4. LOANS, FRAUD, AUDIT (26–40)
   =============================== */

   CREATE TABLE Loans(
    LoanID INT IDENTITY PRIMARY KEY,
    CustomerID INT,
    LoanAmount DECIMAL(18,2),
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Closed','Defaulted')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Created_By NVARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE LoanPayments(
    PaymentID INT IDENTITY PRIMARY KEY,
    LoanID INT,
    Amount DECIMAL(18,2),
    Status NVARCHAR(20)
        CHECK (Status IN ('Paid','Pending','Failed')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
        ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE FraudRules(
    RuleID INT IDENTITY PRIMARY KEY,
    RuleName NVARCHAR(100),
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50)
);

CREATE TABLE FraudAlerts(
    AlertID INT IDENTITY PRIMARY KEY,
    AccountID INT,
    RuleName NVARCHAR(100),
    AlertDate DATETIME,
    Status NVARCHAR(20)
        CHECK (Status IN ('Open','Resolved','Ignored')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Created_By NVARCHAR(50),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
CREATE TABLE AMLRules(
    AMLRuleID INT IDENTITY PRIMARY KEY,
    RuleName NVARCHAR(100),
    Status NVARCHAR(20)
        CHECK (Status IN ('Active','Inactive')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50)
);

CREATE TABLE AMLReports(
    ReportID INT IDENTITY PRIMARY KEY,
    CustomerID INT,
    ReportDate DATETIME,
    Status NVARCHAR(20)
        CHECK (Status IN ('Generated','Reviewed','Flagged')),
    Is_Enable BIT,
    Created_At DATETIME DEFAULT GETDATE(),
    Updated_At DATETIME,
    Deleted_At DATETIME,
    Created_By NVARCHAR(50),
    Updated_By NVARCHAR(50),
    Deleted_By NVARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

-------------------------------------------------------
-- =========================
-- 1. Employees Log Table
-- =========================
CREATE TABLE Employees_Log(
    LogID INT IDENTITY PRIMARY KEY,
    EmployeeID INT,
    Action NVARCHAR(10),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    CNIC NVARCHAR(20),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    BranchID INT,
    DepartmentID INT,
    Status NVARCHAR(20),
    ActionDate DATETIME DEFAULT GETDATE(),
    ActionBy NVARCHAR(50)
);

-- =========================
-- 2. Users Log Table
-- =========================
CREATE TABLE Users_Log(
    LogID INT IDENTITY PRIMARY KEY,
    UserID INT,
    Action NVARCHAR(10),
    Username NVARCHAR(50),
    PasswordHash VARBINARY(256),
    EmployeeID INT,
    Status NVARCHAR(20),
    ActionDate DATETIME DEFAULT GETDATE(),
    ActionBy NVARCHAR(50)
);

-- =========================
-- 3. Accounts Log Table
-- =========================
CREATE TABLE Accounts_Log(
    LogID INT IDENTITY PRIMARY KEY,
    AccountID INT,
    Action NVARCHAR(10),
    CustomerID INT,
    AccountTypeID INT,
    Balance DECIMAL(18,2),
    Status NVARCHAR(20),
    ActionDate DATETIME DEFAULT GETDATE(),
    ActionBy NVARCHAR(50)
);

-- =========================
-- 4. Transactions Log Table
-- =========================
CREATE TABLE Transactions_Log(
    LogID INT IDENTITY PRIMARY KEY,
    TransactionID INT,
    Action NVARCHAR(10),
    AccountID INT,
    TransactionTypeID INT,
    Amount DECIMAL(18,2),
    TxnDate DATETIME,
    Status NVARCHAR(20),
    ActionDate DATETIME DEFAULT GETDATE(),
    ActionBy NVARCHAR(50)
);

-- =========================
-- 5. Customers Log Table
-- =========================
CREATE TABLE Customers_Log(
    LogID INT IDENTITY PRIMARY KEY,
    CustomerID INT,
    Action NVARCHAR(10),
    FullName NVARCHAR(100),
    CNIC NVARCHAR(20),
    Phone NVARCHAR(20),
    City NVARCHAR(50),
    Status NVARCHAR(20),
    ActionDate DATETIME DEFAULT GETDATE(),
    ActionBy NVARCHAR(50)
);

-- =========================
-- 6. Branches Log Table
-- =========================
CREATE TABLE Branches_Log(
    LogID INT IDENTITY PRIMARY KEY,
    BranchID INT,
    Action NVARCHAR(10),
    BranchName NVARCHAR(100),
    City NVARCHAR(50),
    Status NVARCHAR(20),
    ActionDate DATETIME DEFAULT GETDATE(),
    ActionBy NVARCHAR(50)
);

-- =========================
-- 7. Loans Log Table
-- =========================
CREATE TABLE Loans_Log(
    LogID INT IDENTITY PRIMARY KEY,
    LoanID INT,
    Action NVARCHAR(10),
    CustomerID INT,
    LoanAmount DECIMAL(18,2),
    Status NVARCHAR(20),
    ActionDate DATETIME DEFAULT GETDATE(),
    ActionBy NVARCHAR(50)
);

-- =========================
-- 8. Cards Log Table
-- =========================
CREATE TABLE Cards_Log(
    LogID INT IDENTITY PRIMARY KEY,
    CardID INT,
    Action NVARCHAR(10),
    AccountID INT,
    CardType NVARCHAR(50),
    Status NVARCHAR(20),
    ActionDate DATETIME DEFAULT GETDATE(),
    ActionBy NVARCHAR(50)
);

-- =========================
-- 9. Beneficiaries Log Table
-- =========================
CREATE TABLE Beneficiaries_Log(
    LogID INT IDENTITY PRIMARY KEY,
    BeneficiaryID INT,
    Action NVARCHAR(10),
    CustomerID INT,
    BankName NVARCHAR(100),
    AccountNo NVARCHAR(50),
    Status NVARCHAR(20),
    ActionDate DATETIME DEFAULT GETDATE(),
    ActionBy NVARCHAR(50)
);

-- =========================
-- 10. LoginLogs Audit Table
-- =========================
CREATE TABLE LoginLogs_Audit(
    LogID INT IDENTITY PRIMARY KEY,
    OriginalLogID INT,
    UserID INT,
    LoginTime DATETIME,
    Success BIT,
    Status NVARCHAR(20),
    Action NVARCHAR(10),
    ActionDate DATETIME DEFAULT GETDATE(),
    ActionBy NVARCHAR(50)
);
-------------------------------------------
-- =========================
-- 1. Employees Trigger
-- =========================
CREATE TRIGGER trg_Employees_Log
ON Employees
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Employees_Log(EmployeeID, Action, FirstName, LastName, CNIC, Phone, Email, BranchID, DepartmentID, Status, ActionBy)
    SELECT 
        i.EmployeeID,
        CASE WHEN d.EmployeeID IS NULL THEN 'Insert' ELSE 'Update' END,
        i.FirstName, i.LastName, i.CNIC, i.Phone, i.Email, i.BranchID, i.DepartmentID, i.Status,
        SYSTEM_USER
    FROM inserted i
    LEFT JOIN deleted d ON i.EmployeeID = d.EmployeeID;

    INSERT INTO Employees_Log(EmployeeID, Action, FirstName, LastName, CNIC, Phone, Email, BranchID, DepartmentID, Status, ActionBy)
    SELECT 
        d.EmployeeID, 'Delete', d.FirstName, d.LastName, d.CNIC, d.Phone, d.Email, d.BranchID, d.DepartmentID, d.Status, SYSTEM_USER
    FROM deleted d
    LEFT JOIN inserted i ON i.EmployeeID = d.EmployeeID
    WHERE i.EmployeeID IS NULL;
END
-- =========================
-- 2. Users Trigger
-- =========================
CREATE TRIGGER trg_Users_Log
ON Users
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Users_Log(UserID, Action, Username, PasswordHash, EmployeeID, Status, ActionBy)
    SELECT 
        i.UserID,
        CASE WHEN d.UserID IS NULL THEN 'Insert' ELSE 'Update' END,
        i.Username, i.PasswordHash, i.EmployeeID, i.Status, SYSTEM_USER
    FROM inserted i
    LEFT JOIN deleted d ON i.UserID = d.UserID;

    INSERT INTO Users_Log(UserID, Action, Username, PasswordHash, EmployeeID, Status, ActionBy)
    SELECT 
        d.UserID, 'Delete', d.Username, d.PasswordHash, d.EmployeeID, d.Status, SYSTEM_USER
    FROM deleted d
    LEFT JOIN inserted i ON i.UserID = d.UserID
    WHERE i.UserID IS NULL;
END

-- =========================
-- 3. Accounts Trigger
-- =========================
CREATE TRIGGER trg_Accounts_Log
ON Accounts
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Accounts_Log(AccountID, Action, CustomerID, AccountTypeID, Balance, Status, ActionBy)
    SELECT 
        i.AccountID,
        CASE WHEN d.AccountID IS NULL THEN 'Insert' ELSE 'Update' END,
        i.CustomerID, i.AccountTypeID, i.Balance, i.Status, SYSTEM_USER
    FROM inserted i
    LEFT JOIN deleted d ON i.AccountID = d.AccountID;

    INSERT INTO Accounts_Log(AccountID, Action, CustomerID, AccountTypeID, Balance, Status, ActionBy)
    SELECT 
        d.AccountID, 'Delete', d.CustomerID, d.AccountTypeID, d.Balance, d.Status, SYSTEM_USER
    FROM deleted d
    LEFT JOIN inserted i ON i.AccountID = d.AccountID
    WHERE i.AccountID IS NULL;
END

-- =========================
-- 4. Transactions Trigger
-- =========================
CREATE TRIGGER trg_Transactions_Log
ON Transactions
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Transactions_Log(TransactionID, Action, AccountID, TransactionTypeID, Amount, TxnDate, Status, ActionBy)
    SELECT 
        i.TransactionID,
        CASE WHEN d.TransactionID IS NULL THEN 'Insert' ELSE 'Update' END,
        i.AccountID, i.TransactionTypeID, i.Amount, i.TxnDate, i.Status, SYSTEM_USER
    FROM inserted i
    LEFT JOIN deleted d ON i.TransactionID = d.TransactionID;

    INSERT INTO Transactions_Log(TransactionID, Action, AccountID, TransactionTypeID, Amount, TxnDate, Status, ActionBy)
    SELECT 
        d.TransactionID, 'Delete', d.AccountID, d.TransactionTypeID, d.Amount, d.TxnDate, d.Status, SYSTEM_USER
    FROM deleted d
    LEFT JOIN inserted i ON i.TransactionID = d.TransactionID
    WHERE i.TransactionID IS NULL;
END

-- =========================
-- 5. Customers Trigger
-- =========================
CREATE TRIGGER trg_Customers_Log
ON Customers
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Customers_Log(CustomerID, Action, FullName, CNIC, Phone, City, Status, ActionBy)
    SELECT 
        i.CustomerID,
        CASE WHEN d.CustomerID IS NULL THEN 'Insert' ELSE 'Update' END,
        i.FullName, i.CNIC, i.Phone, i.City, i.Status, SYSTEM_USER
    FROM inserted i
    LEFT JOIN deleted d ON i.CustomerID = d.CustomerID;

    INSERT INTO Customers_Log(CustomerID, Action, FullName, CNIC, Phone, City, Status, ActionBy)
    SELECT 
        d.CustomerID, 'Delete', d.FullName, d.CNIC, d.Phone, d.City, d.Status, SYSTEM_USER
    FROM deleted d
    LEFT JOIN inserted i ON i.CustomerID = d.CustomerID
    WHERE i.CustomerID IS NULL;
END

-- =========================
-- 6. Branches Trigger
-- =========================
CREATE TRIGGER trg_Branches_Log
ON Branches
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Branches_Log(BranchID, Action, BranchName, City, Status, ActionBy)
    SELECT 
        i.BranchID,
        CASE WHEN d.BranchID IS NULL THEN 'Insert' ELSE 'Update' END,
        i.BranchName, i.City, i.Status, SYSTEM_USER
    FROM inserted i
    LEFT JOIN deleted d ON i.BranchID = d.BranchID;

    INSERT INTO Branches_Log(BranchID, Action, BranchName, City, Status, ActionBy)
    SELECT 
        d.BranchID, 'Delete', d.BranchName, d.City, d.Status, SYSTEM_USER
    FROM deleted d
    LEFT JOIN inserted i ON i.BranchID = d.BranchID
    WHERE i.BranchID IS NULL;
END

-- =========================
-- 7. Loans Trigger
-- =========================
CREATE TRIGGER trg_Loans_Log
ON Loans
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Loans_Log(LoanID, Action, CustomerID, LoanAmount, Status, ActionBy)
    SELECT 
        i.LoanID,
        CASE WHEN d.LoanID IS NULL THEN 'Insert' ELSE 'Update' END,
        i.CustomerID, i.LoanAmount, i.Status, SYSTEM_USER
    FROM inserted i
    LEFT JOIN deleted d ON i.LoanID = d.LoanID;

    INSERT INTO Loans_Log(LoanID, Action, CustomerID, LoanAmount, Status, ActionBy)
    SELECT 
        d.LoanID, 'Delete', d.CustomerID, d.LoanAmount, d.Status, SYSTEM_USER
    FROM deleted d
    LEFT JOIN inserted i ON i.LoanID = d.LoanID
    WHERE i.LoanID IS NULL;
END

-- =========================
-- 8. Cards Trigger
-- =========================
CREATE TRIGGER trg_Cards_Log
ON Cards
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Cards_Log(CardID, Action, AccountID, CardType, Status, ActionBy)
    SELECT 
        i.CardID,
        CASE WHEN d.CardID IS NULL THEN 'Insert' ELSE 'Update' END,
        i.AccountID, i.CardType, i.Status, SYSTEM_USER
    FROM inserted i
    LEFT JOIN deleted d ON i.CardID = d.CardID;

    INSERT INTO Cards_Log(CardID, Action, AccountID, CardType, Status, ActionBy)
    SELECT 
        d.CardID, 'Delete', d.AccountID, d.CardType, d.Status, SYSTEM_USER
    FROM deleted d
    LEFT JOIN inserted i ON i.CardID = d.CardID
    WHERE i.CardID IS NULL;
END

-- =========================
-- 9. Beneficiaries Trigger
-- =========================
CREATE TRIGGER trg_Beneficiaries_Log
ON Beneficiaries
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Beneficiaries_Log(BeneficiaryID, Action, CustomerID, BankName, AccountNo, Status, ActionBy)
    SELECT 
        i.BeneficiaryID,
        CASE WHEN d.BeneficiaryID IS NULL THEN 'Insert' ELSE 'Update' END,
        i.CustomerID, i.BankName, i.AccountNo, i.Status, SYSTEM_USER
    FROM inserted i
    LEFT JOIN deleted d ON i.BeneficiaryID = d.BeneficiaryID;

    INSERT INTO Beneficiaries_Log(BeneficiaryID, Action, CustomerID, BankName, AccountNo, Status, ActionBy)
    SELECT 
        d.BeneficiaryID, 'Delete', d.CustomerID, d.BankName, d.AccountNo, d.Status, SYSTEM_USER
    FROM deleted d
    LEFT JOIN inserted i ON i.BeneficiaryID = d.BeneficiaryID
    WHERE i.BeneficiaryID IS NULL;
END

-- =========================
-- 10. LoginLogs Trigger
-- =========================
CREATE TRIGGER trg_LoginLogs_Audit
ON LoginLogs
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LoginLogs_Audit(OriginalLogID, UserID, LoginTime, Success, Status, Action, ActionBy)
    SELECT 
        i.LogID,
        i.UserID, i.LoginTime, i.Success, i.Status,
        CASE WHEN d.LogID IS NULL THEN 'Insert' ELSE 'Update' END,
        SYSTEM_USER
    FROM inserted i
    LEFT JOIN deleted d ON i.LogID = d.LogID;

    INSERT INTO LoginLogs_Audit(OriginalLogID, UserID, LoginTime, Success, Status, Action, ActionBy)
    SELECT 
        d.LogID, d.UserID, d.LoginTime, d.Success, d.Status, 'Delete', SYSTEM_USER
    FROM deleted d
    LEFT JOIN inserted i ON i.LogID = d.LogID
    WHERE i.LogID IS NULL;
END

---- insert data
INSERT INTO Branches (BranchName, City, Status, Is_Enable, Created_By) VALUES
('Main Branch Karachi','Karachi','Active',1,'Admin'),
('Gulberg Branch','Lahore','Active',1,'Admin'),
('Blue Area Branch','Islamabad','Active',1,'Admin'),
('Clifton Branch','Karachi','Inactive',0,'Admin'),
('Model Town Branch','Lahore','Pending',0,'Admin'),
('F-10 Markaz Branch','Islamabad','Active',1,'Admin'),
('North Nazimabad Branch','Karachi','Active',1,'Admin'),
('Johar Town Branch','Lahore','Active',1,'Admin'),
('G-9 Markaz Branch','Islamabad','Inactive',0,'Admin'),
('Saddar Branch','Karachi','Active',1,'Admin'),
('DHA Phase 6 Branch','Lahore','Active',1,'Admin'),
('I-8 Markaz Branch','Islamabad','Pending',0,'Admin'),
('Korangi Branch','Karachi','Active',1,'Admin'),
('Cantt Branch','Lahore','Active',1,'Admin'),
('G-11 Markaz Branch','Islamabad','Inactive',0,'Admin'),
('PECHS Branch','Karachi','Active',1,'Admin'),
('Wapda Town Branch','Lahore','Active',1,'Admin'),
('Bahria Town Branch','Islamabad','Active',1,'Admin'),
('Malir Branch','Karachi','Pending',0,'Admin'),
('Allama Iqbal Town Branch','Lahore','Active',1,'Admin');


INSERT INTO Departments (DepartmentName, Status, Is_Enable, Created_By) VALUES
('Accounts','Active',1,'Admin'),
('Operations','Active',1,'Admin'),
('Loans','Active',1,'Admin'),
('IT','Active',1,'Admin'),
('HR','Active',1,'Admin'),
('Compliance','Active',1,'Admin'),
('Support','Inactive',0,'Admin'),
('Security','Active',1,'Admin'),
('Risk','Active',1,'Admin'),
('Audit','Active',1,'Admin'),
('Treasury','Active',1,'Admin'),
('Digital Banking','Active',1,'Admin'),
('Customer Care','Active',1,'Admin'),
('Recovery','Inactive',0,'Admin'),
('Training','Active',1,'Admin'),
('Legal','Active',1,'Admin'),
('Admin','Active',1,'Admin'),
('Procurement','Active',1,'Admin'),
('Marketing','Active',1,'Admin'),
('Strategy','Active',1,'Admin');

OPEN SYMMETRIC KEY DataKey
DECRYPTION BY CERTIFICATE DataCert;
INSERT INTO Employees
(FirstName, LastName, CNIC, Phone, Email, BranchID, DepartmentID, Status, Is_Enable, Created_By)
VALUES
('Ali','Khan',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000001-1'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000001'),
 'e1@bank.com',1,1,'Active',1,'HR'),

('Ahmed','Raza',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000002-2'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000002'),
 'e2@bank.com',2,2,'Active',1,'HR'),

('Sara','Malik',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000003-3'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000003'),
 'e3@bank.com',3,3,'Active',1,'HR'),

('Hina','Iqbal',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000004-4'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000004'),
 'e4@bank.com',4,4,'Inactive',0,'HR'),

('Usman','Ali',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000005-5'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000005'),
 'e5@bank.com',5,5,'Active',1,'HR'),

('Bilal','Sheikh',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000006-6'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000006'),
 'e6@bank.com',6,6,'Suspended',0,'HR'),

('Ayesha','Noor',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000007-7'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000007'),
 'e7@bank.com',7,7,'Active',1,'HR'),

('Hamza','Khan',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000008-8'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000008'),
 'e8@bank.com',8,8,'Active',1,'HR'),

('Zain','Malik',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000009-9'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000009'),
 'e9@bank.com',9,9,'Active',1,'HR'),

('Maryam','Riaz',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000010-0'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000010'),
 'e10@bank.com',10,10,'Inactive',0,'HR'),

('Fahad','Ali',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000011-1'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000011'),
 'e11@bank.com',11,11,'Active',1,'HR'),

('Saad','Khan',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000012-2'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000012'),
 'e12@bank.com',12,12,'Active',1,'HR'),

('Nida','Malik',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000013-3'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000013'),
 'e13@bank.com',13,13,'Active',1,'HR'),

('Omer','Shah',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000014-4'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000014'),
 'e14@bank.com',14,14,'Inactive',0,'HR'),

('Laiba','Rashid',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000015-5'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000015'),
 'e15@bank.com',15,15,'Active',1,'HR'),

('Imran','Akram',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000016-6'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000016'),
 'e16@bank.com',16,16,'Active',1,'HR'),

('Kashif','Iqbal',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000017-7'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000017'),
 'e17@bank.com',17,17,'Active',1,'HR'),

('Sana','Ahmed',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000018-8'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000018'),
 'e18@bank.com',18,18,'Active',1,'HR'),

('Asad','Butt',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000019-9'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000019'),
 'e19@bank.com',19,19,'Suspended',0,'HR'),

('Rabia','Hussain',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'42101-0000020-0'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03000000020'),
 'e20@bank.com',20,20,'Active',1,'HR');
CLOSE SYMMETRIC KEY DataKey;

INSERT INTO Roles (RoleName, Status, Is_Enable, Created_By)
VALUES
('SystemAdmin','Active',1,'SYSTEM'),
('BranchManager','Active',1,'SYSTEM'),
('Teller','Active',1,'SYSTEM'),
('CustomerService','Active',1,'SYSTEM'),
('Auditor','Active',1,'SYSTEM');

INSERT INTO Users (Username, PasswordHash, EmployeeID, Status, Is_Enable, Created_By)
VALUES 
('ali_khan', HASHBYTES('SHA2_256', 'Pakistan@786'), 1, 'Active', 1, 'ADMIN'),
('Ahmed_Raza', HASHBYTES('SHA2_256', 'Lahore#2024'), 2, 'Active', 1, 'ADMIN'),
('Sara_malik', HASHBYTES('SHA2_256', 'Karachi!99'), 3, 'Inactive', 0, 'SYSTEM');

INSERT INTO UserRoles(UserID, RoleID, Status, Is_Enable, Created_By)
VALUES
(1,1,'Active',1,'SYSTEM'), -- Admin
(2,2,'Active',1,'SYSTEM'), -- Manager
(3,3,'Active',1,'SYSTEM'); -- Teller

INSERT INTO LoginLogs (UserID, Success, Status, Is_Enable, Created_By)
VALUES (1, 1, 'Success', 1, 'System'),
(2, 0, 'Failed', 1, 'System');

INSERT INTO Permissions (PermissionName, Status, Is_Enable, Created_By)
VALUES
('CREATE_ACCOUNT','Active',1,'SYSTEM'),
('VIEW_ACCOUNT','Active',1,'SYSTEM'),
('PROCESS_TRANSACTION','Active',1,'SYSTEM'),
('APPROVE_LOAN','Active',1,'SYSTEM'),
('VIEW_AUDIT_LOGS','Active',1,'SYSTEM'),
('MANAGE_USERS','Active',1,'SYSTEM');

CREATE TABLE RolePermissions(
    RolePermissionID INT IDENTITY PRIMARY KEY,
    RoleID INT,
    PermissionID INT,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    FOREIGN KEY (PermissionID) REFERENCES Permissions(PermissionID)
);
---------------------------------------------------
-- System Admin (ALL)
INSERT INTO RolePermissions
SELECT r.RoleID, p.PermissionID
FROM Roles r CROSS JOIN Permissions p
WHERE r.RoleName = 'SystemAdmin';

-- Branch Manager
INSERT INTO RolePermissions
SELECT r.RoleID, p.PermissionID
FROM Roles r JOIN Permissions p
ON p.PermissionName IN ('CREATE_ACCOUNT','VIEW_ACCOUNT','PROCESS_TRANSACTION','APPROVE_LOAN')
WHERE r.RoleName = 'BranchManager';

-- Teller
INSERT INTO RolePermissions
SELECT r.RoleID, p.PermissionID
FROM Roles r JOIN Permissions p
ON p.PermissionName IN ('VIEW_ACCOUNT','PROCESS_TRANSACTION')
WHERE r.RoleName = 'Teller';

-- Auditor
INSERT INTO RolePermissions
SELECT r.RoleID, p.PermissionID
FROM Roles r JOIN Permissions p
ON p.PermissionName IN ('VIEW_AUDIT_LOGS')
WHERE r.RoleName = 'Auditor';

OPEN SYMMETRIC KEY DataKey
DECRYPTION BY CERTIFICATE DataCert;
INSERT INTO Customers
(FullName, CNIC, Phone, City, Status, Is_Enable, Created_By)
VALUES
('Ahmed Ali',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-1111111-1'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000001'),
 'Karachi','Active',1,'CSR'),

('Usman Raza',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-1111111-2'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000002'),
 'Lahore','Active',1,'CSR'),

('Hassan Khan',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-1111111-3'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000003'),
 'Islamabad','Blocked',0,'CSR'),

('Bilal Sheikh',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-1111111-4'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000004'),
 'Karachi','Active',1,'CSR'),

('Fahad Iqbal',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-1111111-5'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000005'),
 'Lahore','Inactive',0,'CSR'),

('Ali Hamza',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-1111111-6'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000006'),
 'Islamabad','Active',1,'CSR'),

('Saad Ahmed',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-1111111-7'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000007'),
 'Karachi','Active',1,'CSR'),

('Adeel Malik',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-1111111-8'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000008'),
 'Lahore','Active',1,'CSR'),

('Zeeshan Tariq',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-1111111-9'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000009'),
 'Islamabad','Inactive',0,'CSR'),

('Imran Butt',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-1111111-0'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000010'),
 'Karachi','Active',1,'CSR'),

('Omer Farooq',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-2222222-1'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000011'),
 'Lahore','Active',1,'CSR'),

('Shahzaib Khan',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-2222222-2'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000012'),
 'Islamabad','Active',1,'CSR'),

('Kamran Akram',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-2222222-3'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000013'),
 'Karachi','Blocked',0,'CSR'),

('Noman Riaz',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-2222222-4'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000014'),
 'Lahore','Active',1,'CSR'),

('Salman Yousaf',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-2222222-5'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000015'),
 'Islamabad','Inactive',0,'CSR'),

('Asad Mehmood',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-2222222-6'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000016'),
 'Karachi','Active',1,'CSR'),

('Waqas Ahmed',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-2222222-7'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000017'),
 'Lahore','Active',1,'CSR'),

('Haris Nawaz',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-2222222-8'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000018'),
 'Islamabad','Active',1,'CSR'),

('Rizwan Anwar',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-2222222-9'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000019'),
 'Karachi','Active',1,'CSR'),

('Muneeb Khalid',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'35201-2222222-0'),
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'03100000020'),
 'Lahore','Active',1,'CSR');
 CLOSE SYMMETRIC KEY DataKey;


INSERT INTO KYC
(CustomerID, DocumentType, Status, Is_Enable, Created_By)
VALUES
(1,'CNIC','Verified',1,'CSR'),
(2,'CNIC','Verified',1,'CSR'),
(3,'CNIC','Rejected',0,'CSR'),
(4,'CNIC','Verified',1,'CSR'),
(5,'CNIC','Pending',1,'CSR'),
(6,'Passport','Verified',1,'CSR'),
(7,'CNIC','Verified',1,'CSR'),
(8,'CNIC','Pending',1,'CSR'),
(9,'CNIC','Rejected',0,'CSR'),
(10,'Passport','Verified',1,'CSR'),
(11,'CNIC','Verified',1,'CSR'),
(12,'CNIC','Verified',1,'CSR'),
(13,'CNIC','Rejected',0,'CSR'),
(14,'Passport','Verified',1,'CSR'),
(15,'CNIC','Pending',1,'CSR'),
(16,'CNIC','Verified',1,'CSR'),
(17,'CNIC','Verified',1,'CSR'),
(18,'Passport','Verified',1,'CSR'),
(19,'CNIC','Verified',1,'CSR'),
(20,'CNIC','Verified',1,'CSR');

INSERT INTO AccountTypes
(TypeName, Status, Is_Enable, Created_By)
VALUES
('Savings Account','Active',1,'Admin'),
('Current Account','Active',1,'Admin'),
('Salary Account','Active',1,'Admin'),
('Student Account','Active',1,'Admin'),
('Business Account','Inactive',0,'Admin');

INSERT INTO Accounts
(CustomerID, AccountTypeID, Balance, Status, Is_Enable, Created_By)
VALUES
(1,1,50000,'Active',1,'System'),
(2,2,120000,'Active',1,'System'),
(3,1,0,'Dormant',0,'System'),
(4,3,30000,'Active',1,'System'),
(5,2,0,'Inactive',0,'System'),
(6,1,85000,'Active',1,'System'),
(7,4,15000,'Active',1,'System'),
(8,1,40000,'Active',1,'System'),
(9,2,0,'Dormant',0,'System'),
(10,3,60000,'Active',1,'System'),
(11,1,90000,'Active',1,'System'),
(12,2,20000,'Active',1,'System'),
(13,1,0,'Closed',0,'System'),
(14,3,75000,'Active',1,'System'),
(15,4,12000,'Inactive',0,'System'),
(16,1,95000,'Active',1,'System'),
(17,2,35000,'Active',1,'System'),
(18,1,110000,'Active',1,'System'),
(19,3,50000,'Active',1,'System'),
(20,1,45000,'Active',1,'System');

INSERT INTO Cards
(AccountID, CardType, Status, Is_Enable, Created_By)
VALUES
(1,'Debit Card','Active',1,'System'),
(2,'Debit Card','Active',1,'System'),
(3,'Debit Card','Expired',0,'System'),
(4,'Credit Card','Active',1,'System'),
(5,'Debit Card','Blocked',0,'System'),
(6,'Debit Card','Active',1,'System'),
(7,'Virtual Card','Active',1,'System'),
(8,'Debit Card','Active',1,'System'),
(9,'Debit Card','Expired',0,'System'),
(10,'Credit Card','Active',1,'System'),
(11,'Debit Card','Active',1,'System'),
(12,'Debit Card','Active',1,'System'),
(13,'Debit Card','Blocked',0,'System'),
(14,'Credit Card','Active',1,'System'),
(15,'Virtual Card','Blocked',0,'System'),
(16,'Debit Card','Active',1,'System'),
(17,'Debit Card','Active',1,'System'),
(18,'Credit Card','Active',1,'System'),
(19,'Debit Card','Active',1,'System'),
(20,'Debit Card','Active',1,'System');

OPEN SYMMETRIC KEY DataKey
DECRYPTION BY CERTIFICATE DataCert;
INSERT INTO Beneficiaries
(CustomerID, BankName, AccountNo, Status, Is_Enable, Created_By)
VALUES
(1,'HBL',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'HBL-001'),
 'Active',1,'Customer'),

(2,'UBL',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'UBL-002'),
 'Active',1,'Customer'),

(3,'MCB',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'MCB-003'),
 'Blocked',0,'Customer'),

(4,'ABL',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'ABL-004'),
 'Active',1,'Customer'),

(5,'Meezan Bank',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'MEE-005'),
 'Pending',1,'Customer'),

(6,'HBL',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'HBL-006'),
 'Active',1,'Customer'),

(7,'UBL',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'UBL-007'),
 'Active',1,'Customer'),

(8,'MCB',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'MCB-008'),
 'Active',1,'Customer'),

(9,'ABL',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'ABL-009'),
 'Blocked',0,'Customer'),

(10,'Meezan Bank',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'MEE-010'),
 'Active',1,'Customer'),

(11,'HBL',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'HBL-011'),
 'Active',1,'Customer'),

(12,'UBL',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'UBL-012'),
 'Active',1,'Customer'),

(13,'MCB',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'MCB-013'),
 'Blocked',0,'Customer'),

(14,'ABL',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'ABL-014'),
 'Active',1,'Customer'),

(15,'Meezan Bank',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'MEE-015'),
 'Pending',1,'Customer'),

(16,'HBL',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'HBL-016'),
 'Active',1,'Customer'),

(17,'UBL',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'UBL-017'),
 'Active',1,'Customer'),

(18,'MCB',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'MCB-018'),
 'Active',1,'Customer'),

(19,'ABL',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'ABL-019'),
 'Active',1,'Customer'),

(20,'Meezan Bank',
 ENCRYPTBYKEY(KEY_GUID('DataKey'),'MEE-020'),
 'Active',1,'Customer');
 CLOSE SYMMETRIC KEY DataKey;

INSERT INTO Limits
(AccountID, DailyLimit, Status, Is_Enable, Created_By)
VALUES
(1,200000,'Active',1,'System'),
(2,300000,'Active',1,'System'),
(3,50000,'Suspended',0,'System'),
(4,150000,'Active',1,'System'),
(5,50000,'Suspended',0,'System'),
(6,250000,'Active',1,'System'),
(7,100000,'Active',1,'System'),
(8,200000,'Active',1,'System'),
(9,50000,'Suspended',0,'System'),
(10,300000,'Active',1,'System'),
(11,250000,'Active',1,'System'),
(12,150000,'Active',1,'System'),
(13,50000,'Suspended',0,'System'),
(14,300000,'Active',1,'System'),
(15,50000,'Suspended',0,'System'),
(16,250000,'Active',1,'System'),
(17,200000,'Active',1,'System'),
(18,300000,'Active',1,'System'),
(19,150000,'Active',1,'System'),
(20,200000,'Active',1,'System');

---insert data transaction table
INSERT INTO TransactionTypes (TypeName, Status, Is_Enable, Created_By)
VALUES
('Deposit','Active',1,'Admin'),
('Withdrawal','Active',1,'Admin'),
('Transfer','Active',1,'Admin'),
('Bill Payment','Active',1,'Admin'),
('Topup','Active',1,'Admin');

INSERT INTO Transactions
(AccountID, TransactionTypeID, Amount, TxnDate, Status, Is_Enable, Created_By)
VALUES
(1,1,10000,GETDATE(),'Success',1,'System'),
(2,2,5000,GETDATE(),'Success',1,'System'),
(3,3,2000,GETDATE(),'Failed',0,'System'),
(4,1,15000,GETDATE(),'Success',1,'System'),
(5,2,3000,GETDATE(),'Pending',1,'System'),
(6,3,7000,GETDATE(),'Success',1,'System'),
(7,1,9000,GETDATE(),'Success',1,'System'),
(8,4,2500,GETDATE(),'Success',1,'System'),
(9,5,600,GETDATE(),'Failed',0,'System'),
(10,1,20000,GETDATE(),'Success',1,'System'),
(11,2,4000,GETDATE(),'Success',1,'System'),
(12,3,5000,GETDATE(),'Success',1,'System'),
(13,1,3000,GETDATE(),'Failed',0,'System'),
(14,4,3500,GETDATE(),'Success',1,'System'),
(15,5,800,GETDATE(),'Pending',1,'System'),
(16,1,12000,GETDATE(),'Success',1,'System'),
(17,2,4500,GETDATE(),'Success',1,'System'),
(18,3,10000,GETDATE(),'Success',1,'System'),
(19,4,2000,GETDATE(),'Success',1,'System'),
(20,5,1000,GETDATE(),'Success',1,'System');

INSERT INTO InternalTransfers
(FromAccount, ToAccount, Amount, Status, Is_Enable, Created_By)
VALUES
(1,2,5000,'Completed',1,'System'),
(3,4,3000,'Failed',0,'System'),
(5,6,2000,'Pending',1,'System'),
(7,8,4000,'Completed',1,'System'),
(9,10,2500,'Completed',1,'System');

INSERT INTO ExternalTransfers
(FromAccount, BeneficiaryID, Amount, Status, Is_Enable, Created_By)
VALUES
(1,1,6000,'Completed',1,'System'),
(2,2,3500,'Completed',1,'System'),
(3,3,2000,'Rejected',0,'System'),
(4,4,5000,'Completed',1,'System'),
(5,5,3000,'Pending',1,'System');

INSERT INTO BillPayments
(AccountID, Utility, Amount, Status, Is_Enable, Created_By)
VALUES
(1,'Electricity',4500,'Paid',1,'System'),
(2,'Gas',2200,'Paid',1,'System'),
(3,'Water',1500,'Failed',0,'System'),
(4,'Internet',3000,'Paid',1,'System'),
(5,'Telephone',1800,'Unpaid',1,'System');

INSERT INTO MobileTopups
(AccountID, MobileNo, Amount, Status, Is_Enable, Created_By)
VALUES
(1,'03011234567',500,'Success',1,'System'),
(2,'03121234567',1000,'Success',1,'System'),
(3,'03231234567',300,'Failed',0,'System'),
(4,'03331234567',200,'Success',1,'System'),
(5,'03451234567',1500,'Pending',1,'System');

INSERT INTO MerchantPayments
(AccountID, MerchantName, Amount, Status, Is_Enable, Created_By)
VALUES
(1,'Daraz',8000,'Success',1,'System'),
(2,'FoodPanda',1200,'Success',1,'System'),
(3,'Amazon',5000,'Failed',0,'System'),
(4,'Metro',3000,'Success',1,'System'),
(5,'Careem',2000,'Refunded',1,'System');

INSERT INTO ATMTransactions
(AccountID, Amount, Status, Is_Enable, Created_By)
VALUES
(1,10000,'Success',1,'ATM'),
(2,5000,'Success',1,'ATM'),
(3,2000,'Failed',0,'ATM'),
(4,15000,'Success',1,'ATM'),
(5,3000,'Reversed',1,'ATM');

INSERT INTO POSTransactions
(AccountID, Amount, Status, Is_Enable, Created_By)
VALUES
(1,2500,'Approved',1,'POS'),
(2,1800,'Approved',1,'POS'),
(3,4000,'Declined',0,'POS'),
(4,3200,'Approved',1,'POS'),
(5,1500,'Approved',1,'POS');

INSERT INTO Charges
(AccountID, ChargeAmount, Status, Is_Enable, Created_By)
VALUES
(1,500,'Applied',1,'System'),
(2,300,'Applied',1,'System'),
(3,200,'Waived',1,'System'),
(4,400,'Applied',1,'System'),
(5,250,'Applied',1,'System');

----------------------loan ,fraud
INSERT INTO Loans (CustomerID, LoanAmount, Status, Is_Enable, Created_By)
VALUES
(1,500000,'Active',1,'LoanOfficer'),
(2,300000,'Closed',1,'LoanOfficer'),
(3,700000,'Defaulted',0,'LoanOfficer'),
(4,250000,'Active',1,'LoanOfficer'),
(5,400000,'Active',1,'LoanOfficer');

INSERT INTO LoanPayments
(LoanID, Amount, Status, Is_Enable, Created_By)
VALUES
(1,25000,'Paid',1,'System'),
(1,25000,'Paid',1,'System'),
(2,300000,'Paid',1,'System'),
(3,20000,'Failed',0,'System'),
(4,15000,'Pending',1,'System');

INSERT INTO FraudRules
(RuleName, Status, Is_Enable, Created_By)
VALUES
('High Amount Transaction','Active',1,'Admin'),
('Multiple Failed Logins','Active',1,'Admin'),
('Foreign Location Access','Inactive',0,'Admin');

INSERT INTO FraudAlerts
(AccountID, RuleName, AlertDate, Status, Is_Enable, Created_By)
VALUES
(1,'High Amount Transaction',GETDATE(),'Open',1,'System'),
(2,'Multiple Failed Logins',GETDATE(),'Resolved',1,'System'),
(3,'Foreign Location Access',GETDATE(),'Ignored',1,'System'),
(4,'High Amount Transaction',GETDATE(),'Open',1,'System'),
(5,'Multiple Failed Logins',GETDATE(),'Resolved',1,'System');

INSERT INTO AMLRules
(RuleName, Status, Is_Enable, Created_By)
VALUES
('Large Cash Deposit','Active',1,'Compliance'),
('Frequent Transfers','Active',1,'Compliance'),
('Suspicious Beneficiary','Inactive',0,'Compliance');


INSERT INTO AMLReports
(CustomerID, ReportDate, Status, Is_Enable, Created_By)
VALUES
(1,GETDATE(),'Generated',1,'Compliance'),
(2,GETDATE(),'Reviewed',1,'Compliance'),
(3,GETDATE(),'Flagged',1,'Compliance'),
(4,GETDATE(),'Generated',1,'Compliance'),
(5,GETDATE(),'Reviewed',1,'Compliance');

----Permission show---
SELECT 
    u.Username,
    r.RoleName,
    p.PermissionName
FROM Users u
JOIN UserRoles ur ON u.UserID = ur.UserID
JOIN Roles r ON ur.RoleID = r.RoleID
JOIN RolePermissions rp ON r.RoleID = rp.RoleID
JOIN Permissions p ON rp.PermissionID = p.PermissionID
WHERE u.Username = 'ali_khan';

SELECT 
    u.Username,
    r.RoleName,
    p.PermissionName
FROM Users u
JOIN UserRoles ur ON u.UserID = ur.UserID
JOIN Roles r ON ur.RoleID = r.RoleID
JOIN RolePermissions rp ON r.RoleID = rp.RoleID
JOIN Permissions p ON rp.PermissionID = p.PermissionID
WHERE u.Username = 'Ahmed_Raza';

SELECT 
    u.Username,
    r.RoleName,
    p.PermissionName
FROM Users u
JOIN UserRoles ur ON u.UserID = ur.UserID
JOIN Roles r ON ur.RoleID = r.RoleID
JOIN RolePermissions rp ON r.RoleID = rp.RoleID
JOIN Permissions p ON rp.PermissionID = p.PermissionID
WHERE u.Username = 'Sara_Malik';

SELECT 
    u.UserID,
    u.Username,
    r.RoleName,
    p.PermissionName
FROM Users u
JOIN UserRoles ur ON u.UserID = ur.UserID
JOIN Roles r ON ur.RoleID = r.RoleID
JOIN RolePermissions rp ON r.RoleID = rp.RoleID
JOIN Permissions p ON rp.PermissionID = p.PermissionID
ORDER BY u.Username, r.RoleName;

SELECT 
    r.RoleName,
    p.PermissionName
FROM Roles r
JOIN RolePermissions rp ON r.RoleID = rp.RoleID
JOIN Permissions p ON rp.PermissionID = p.PermissionID
WHERE r.RoleName = 'BranchManager';

SELECT 
    u.Username,
    r.RoleName
FROM Users u
JOIN UserRoles ur ON u.UserID = ur.UserID
JOIN Roles r ON ur.RoleID = r.RoleID;

SELECT 
    u.Username,
    p.PermissionName
FROM Users u
CROSS JOIN Permissions p
WHERE NOT EXISTS (
    SELECT 1
    FROM UserRoles ur
    JOIN RolePermissions rp ON ur.RoleID = rp.RoleID
    WHERE ur.UserID = u.UserID
      AND rp.PermissionID = p.PermissionID
);

SELECT BranchName, City
FROM Branches
WHERE Status = 'Active' AND Is_Enable = 1;

SELECT FirstName, LastName, Status
FROM Employees
WHERE Status = 'Suspended';

SELECT AccountID, Balance
FROM Accounts
ORDER BY Balance DESC;

SELECT City, COUNT(*) AS TotalCustomers
FROM Customers
GROUP BY City;

SELECT TypeName, SUM(Amount) AS TotalAmount
FROM Transactions 
JOIN TransactionTypes ON TransactionTypes.TransactionTypeID = Transactions.TransactionTypeID
GROUP BY TypeName;

SELECT City, COUNT(*) AS TotalCustomers
FROM Customers
GROUP BY City
HAVING COUNT(*) > 3;

SELECT AccountTypeID, COUNT(*) AS TotalAccounts
FROM Accounts
GROUP BY AccountTypeID
HAVING AVG(Balance) > 50000;

--Deposit transaction
BEGIN TRANSACTION;

UPDATE Accounts
SET Balance = Balance + 5000
WHERE AccountID = 1;

INSERT INTO Transactions
(AccountID, TransactionTypeID, Amount, TxnDate, Status, Is_Enable, Created_By)
VALUES (1,1,5000,GETDATE(),'Success',1,'System');

COMMIT;
select Balance from Accounts;

--Withdrawal with rollback
BEGIN TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 1000
WHERE AccountID = 1;

IF @@ROWCOUNT = 0
    ROLLBACK;
ELSE
    COMMIT;

--Internal transfer
BEGIN TRANSACTION;

UPDATE Accounts SET Balance = Balance - 3000 WHERE AccountID = 1;
UPDATE Accounts SET Balance = Balance + 3000 WHERE AccountID = 2;

COMMIT;
--Failed transaction logging
INSERT INTO Transactions
(AccountID, TransactionTypeID, Amount, TxnDate, Status)
VALUES (3,3,2000,GETDATE(),'Failed');

select * from Transactions;
--Daily transaction total
SELECT CAST(TxnDate AS DATE) AS TxnDay, SUM(Amount) AS Total
FROM Transactions
GROUP BY CAST(TxnDate AS DATE);

SELECT Status, COUNT(*) AS Total
FROM Transactions
GROUP BY Status;

--STORED PROCEDURES
--Deposit procedure
CREATE PROCEDURE sp_Deposit
@AccountID INT,
@Amount DECIMAL(18,2)
AS
BEGIN
    UPDATE Accounts
    SET Balance = Balance + @Amount
    WHERE AccountID = @AccountID;

    INSERT INTO Transactions
    (AccountID, TransactionTypeID, Amount, TxnDate, Status)
    VALUES (@AccountID,1,@Amount,GETDATE(),'Success');
END;
EXEC sp_Deposit 1, 5000;

SELECT AccountID, Balance
FROM Accounts
WHERE AccountID = 1;


--Get user permissions
CREATE PROCEDURE sp_GetUserPermissions
@Username NVARCHAR(50)
AS
BEGIN
    SELECT u.Username, r.RoleName, p.PermissionName
    FROM Users u
    JOIN UserRoles ur ON u.UserID = ur.UserID
    JOIN Roles r ON ur.RoleID = r.RoleID
    JOIN RolePermissions rp ON r.RoleID = rp.RoleID
    JOIN Permissions p ON rp.PermissionID = p.PermissionID
    WHERE u.Username = @Username;
END;
EXEC sp_GetUserPermissions 'ali_khan';


--Clustered INDEX
CREATE CLUSTERED INDEX idx_Accounts_Balance
ON Accounts(Balance);
Select * from Accounts;

--NONCluster INDEX
CREATE NONCLUSTERED INDEX idx_Transactions_TxnDate
ON Transactions(TxnDate);
Select * from Transactions;

CREATE NONCLUSTERED INDEX idx_Customers_CNIC ON Customers(CNIC);
CREATE NONCLUSTERED INDEX idx_Transactions_Status ON Transactions(Status);
CREATE NONCLUSTERED INDEX idx_Users_Username ON Users(Username);
CREATE NONCLUSTERED INDEX idx_KYC_Status ON KYC(Status);
CREATE NONCLUSTERED INDEX idx_Loans_Status ON Loans(Status);
CREATE NONCLUSTERED INDEX idx_BillPayments_Utility ON BillPayments(Utility);
CREATE NONCLUSTERED INDEX idx_MobileTopups_MobileNo ON MobileTopups(MobileNo);
CREATE NONCLUSTERED INDEX idx_FraudAlerts_Status ON FraudAlerts(Status);


INSERT INTO Employees (FirstName, LastName, CNIC, Phone, Email, BranchID, DepartmentID, Status, Is_Enable, Created_By)
VALUES ('Arish', 'Rafiq', '12345-6789012-3', '03001234567', 'arish@example.com', 1, 1, 'Active', 1, 'SYSTEM');

SELECT * FROM Employees_Log WHERE EmployeeID = 21;

UPDATE Employees
SET Phone = '03111234567', Status='Inactive', Updated_At = GETDATE(), Updated_By='SYSTEM'
WHERE EmployeeID = 1;

SELECT * FROM Employees_Log WHERE EmployeeID = 1 ORDER BY ActionDate DESC;

DELETE FROM Employees
WHERE EmployeeID = 1;

SELECT * FROM Employees_Log WHERE EmployeeID = 1 ORDER BY ActionDate DESC;
------------------------------------------
OPEN SYMMETRIC KEY DataKey
DECRYPTION BY CERTIFICATE DataCert;

SELECT
 EmployeeID,
 FirstName,
 LastName,
 CONVERT(VARCHAR(20), DECRYPTBYKEY(CNIC))  AS CNIC,
 CONVERT(VARCHAR(15), DECRYPTBYKEY(Phone)) AS Phone
FROM Employees;




OPEN SYMMETRIC KEY DataKey
DECRYPTION BY CERTIFICATE DataCert;

SELECT
 BeneficiaryID,
 CustomerID,
 BankName,
 CONVERT(VARCHAR(30), DECRYPTBYKEY(AccountNo)) AS AccountNo,
 Status
FROM Beneficiaries;

OPEN SYMMETRIC KEY DataKey
DECRYPTION BY CERTIFICATE DataCert;

SELECT
 CustomerID,
 FullName,
 CONVERT(VARCHAR(20), DECRYPTBYKEY(CNIC))  AS CNIC,
 CONVERT(VARCHAR(15), DECRYPTBYKEY(Phone)) AS Phone,
 City,
 Status
FROM Customers;
