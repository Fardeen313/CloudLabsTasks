# Lab 4 – Data Manipulation & Objects

---

# Scenario

You are working as a **Database Administrator (DBA)** for an online store system.

Your responsibilities include:

* Updating incorrect data
* Removing unnecessary records
* Cleaning inconsistent data
* Creating database objects for reporting

In this lab, you will perform **data manipulation operations (UPDATE, DELETE)** and **data transformation using SQL functions**, and also create a **database view**.

---

# Dataset

Run the following SQL script to create the tables and insert sample data.

```sql
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    BookName VARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100)
);

INSERT INTO Books VALUES
(1,'SQL Basics',300),
(2,'Python Programming',550),
(3,'Cloud Computing',700),
(4,'Docker Essentials',400),
(5,'Kubernetes Guide',600);

INSERT INTO Products VALUES
(1,'Keyboard',80),
(2,'Mouse',150),
(3,'Monitor',5000),
(4,'USB Cable',50),
(5,'Laptop',65000);

INSERT INTO Customers VALUES
(1,'alice'),
(2,'bob'),
(3,'charlie');

INSERT INTO Employees VALUES
(1,'  John Smith  '),
(2,'  Emma Watson  '),
(3,'  David Miller  ');
```

---

# s14 – Update Price of Book with BookID = 5 to ₹450

## Query

```sql
UPDATE Books
SET Price = 450
WHERE BookID = 5;
```

## Explanation

* `UPDATE` modifies existing records in a table.
* `SET Price = 450` changes the price of the book.
* `WHERE BookID = 5` ensures only the specific book is updated.

Example Result After Update:

| BookID | BookName         | Price |
| ------ | ---------------- | ----- |
| 5      | Kubernetes Guide | 450   |

---

# s15 – Delete Records Where Product Price < ₹100

## Query

```sql
DELETE FROM Products
WHERE Price < 100;
```

## Explanation

* `DELETE` removes records from a table.
* `WHERE Price < 100` filters low-priced products.

Products removed:

* Keyboard (₹80)
* USB Cable (₹50)

Remaining Data:

| ProductID | ProductName | Price |
| --------- | ----------- | ----- |
| 2         | Mouse       | 150   |
| 3         | Monitor     | 5000  |
| 5         | Laptop      | 65000 |

---

# s16 – Convert All Customer Names to UPPERCASE

## Query

```sql
UPDATE Customers
SET CustomerName = UPPER(CustomerName);
```

## Explanation

* `UPPER()` converts text to uppercase.
* The update modifies every row in the table.

Example Result:

| CustomerID | CustomerName |
| ---------- | ------------ |
| 1          | ALICE        |
| 2          | BOB          |
| 3          | CHARLIE      |

---

# s17 – Remove Leading and Trailing Spaces from Employee Names

## Query

```sql
UPDATE Employees
SET EmployeeName = TRIM(EmployeeName);
```

*(For older SQL Server versions)*

```sql
UPDATE Employees
SET EmployeeName = LTRIM(RTRIM(EmployeeName));
```

## Explanation

* `TRIM()` removes extra spaces from the start and end of text.
* If TRIM is not available, use `LTRIM()` and `RTRIM()`.

Example Result:

| EmployeeID | EmployeeName |
| ---------- | ------------ |
| 1          | John Smith   |
| 2          | Emma Watson  |
| 3          | David Miller |

---

# s18 – Create a View for High-Priced Products (> ₹1000)

## Query

```sql
CREATE VIEW HighPricedProducts AS
SELECT
    ProductID,
    ProductName,
    Price
FROM Products
WHERE Price > 1000;
```

## Explanation

* A **VIEW** is a virtual table created from a query.
* It stores the query logic but not the data itself.
* This view shows only products costing **more than ₹1000**.

To use the view:

```sql
SELECT * FROM HighPricedProducts;
```

Example Output:

| ProductID | ProductName | Price |
| --------- | ----------- | ----- |
| 3         | Monitor     | 5000  |
| 5         | Laptop      | 65000 |

---

# Lab Outcome

After completing this lab you will understand:

* Updating records using **UPDATE**
* Removing records using **DELETE**
* Transforming text using **UPPER()**
* Cleaning data using **TRIM()**
* Creating reusable database objects using **VIEW**

These operations are commonly used in **database maintenance, data cleaning, and reporting systems**.
