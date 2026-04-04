# Lab 3 – Aggregation & Filtering

---

# Scenario

You are working as a **Data Analyst for a company that manages customers, expenses, and movie ratings**.

Management wants insights about:

* Customer ordering behavior
* Customers who are inactive
* Expense analysis
* Top performing movies

You must write SQL queries using **aggregation, filtering, joins, and sorting**.

---

# Dataset

Run the following SQL to create the tables and insert sample data.

```sql
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderAmount DECIMAL(10,2)
);

CREATE TABLE Expenses (
    ExpenseID INT PRIMARY KEY,
    ExpenseName VARCHAR(100),
    Amount DECIMAL(10,2)
);

CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieName VARCHAR(100),
    Rating DECIMAL(3,1)
);

INSERT INTO Customers VALUES
(1,'Alice'),
(2,'Bob'),
(3,'Charlie'),
(4,'David'),
(5,'Emma');

INSERT INTO Orders VALUES
(1,1,200),
(2,1,300),
(3,1,150),
(4,1,400),
(5,2,250),
(6,2,300),
(7,3,100);

INSERT INTO Expenses VALUES
(1,'Laptop Repair',800),
(2,'Office Chair',450),
(3,'Software License',950),
(4,'Printer Ink',600),
(5,'Stationery',300);

INSERT INTO Movies VALUES
(1,'Inception',9.0),
(2,'Interstellar',8.8),
(3,'The Dark Knight',9.1),
(4,'Avatar',7.8),
(5,'Titanic',8.5),
(6,'Avengers Endgame',8.4),
(7,'Joker',8.3);
```

---

# s9 – Get Number of Orders Per Customer

## Query

```sql
SELECT 
    CustomerID,
    COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID;
```

## Explanation

* `COUNT(OrderID)` counts the number of orders placed by each customer.
* `GROUP BY CustomerID` groups orders belonging to the same customer.

Example Output:

| CustomerID | TotalOrders |
| ---------- | ----------- |
| 1          | 4           |
| 2          | 2           |
| 3          | 1           |

---

# s10 – Find Customers With More Than 3 Orders

## Query

```sql
SELECT 
    CustomerID,
    COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 3;
```

## Explanation

* `HAVING` is used to filter aggregated results.
* Customers with **more than 3 orders** will be returned.

Example Output:

| CustomerID | TotalOrders |
| ---------- | ----------- |
| 1          | 4           |

---

# s11 – Find Customers Who Did Not Place Any Order

## Query

```sql
SELECT 
    c.CustomerID,
    c.CustomerName
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;
```

## Explanation

* `LEFT JOIN` keeps all customers.
* Customers without orders will have `NULL` values in the Orders table.
* `WHERE o.OrderID IS NULL` filters those customers.

Example Output:

| CustomerID | CustomerName |
| ---------- | ------------ |
| 4          | David        |
| 5          | Emma         |

---

# s12 – Find Expenses Between ₹500 and ₹1000

## Query

```sql
SELECT *
FROM Expenses
WHERE Amount BETWEEN 500 AND 1000;
```

## Explanation

* `BETWEEN` filters values within a range.
* This query returns expenses **between ₹500 and ₹1000 inclusive**.

Example Output:

| ExpenseID | ExpenseName      | Amount |
| --------- | ---------------- | ------ |
| 1         | Laptop Repair    | 800    |
| 3         | Software License | 950    |
| 4         | Printer Ink      | 600    |

---

# s13 – Top 5 Highest Rated Movies

## Query

```sql
SELECT *
FROM Movies
ORDER BY Rating DESC
LIMIT 5;
```

*(For SQL Server use `TOP 5` instead of LIMIT)*

```sql
SELECT TOP 5 *
FROM Movies
ORDER BY Rating DESC;
```

## Explanation

* `ORDER BY Rating DESC` sorts movies from highest rating to lowest.
* `LIMIT 5` or `TOP 5` returns only the top five rows.

Example Output:

| MovieID | MovieName        | Rating |
| ------- | ---------------- | ------ |
| 3       | The Dark Knight  | 9.1    |
| 1       | Inception        | 9.0    |
| 2       | Interstellar     | 8.8    |
| 5       | Titanic          | 8.5    |
| 6       | Avengers Endgame | 8.4    |

---

# Lab Outcome

After completing this lab you will understand:

* SQL **GROUP BY aggregation**
* Using **COUNT() with grouping**
* Filtering aggregated results using **HAVING**
* Finding missing relationships using **LEFT JOIN**
* Filtering ranges using **BETWEEN**
* Sorting and limiting results using **ORDER BY + LIMIT**

These techniques are commonly used in **data analytics, reporting, and business intelligence queries**.
