# Lab 1 – S3: Complex Query with Conditional Aggregation

---

# Scenario

You are working as a **Data Analyst for a retail company**.

Management wants a **sales report per region** showing:

* Total sales generated in each region
* Sales contribution from each product category

Instead of writing multiple queries, your manager wants **a single SQL query** that returns all the required information.

The report must calculate:

* Total Sales per Region
* Electronics Sales per Region
* Furniture Sales per Region
* Clothing Sales per Region

---

# Task

You are given a table:

Orders(OrderID, Region, Category, Amount)

Your query must return the following result:

| Region | TotalSales | ElectronicsSales | FurnitureSales | ClothingSales |
| ------ | ---------- | ---------------- | -------------- | ------------- |
| North  | 5000.00    | 3000.00          | 1500.00        | 500.00        |
| South  | 3700.00    | 1800.00          | 1200.00        | 700.00        |
| West   | 4700.00    | 2200.00          | 1600.00        | 900.00        |

Each row represents **one region** and the calculated totals for each category.

---

# Dataset

Run the following SQL to create the table and insert sample data.

```sql
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    Region VARCHAR(50),
    Category VARCHAR(50),
    Amount DECIMAL(10,2)
);

INSERT INTO Orders VALUES
(1,'North','Electronics',2000.00),
(2,'North','Furniture',1500.00),
(3,'North','Electronics',1000.00),
(4,'North','Clothing',500.00),

(5,'South','Electronics',1800.00),
(6,'South','Furniture',1200.00),
(7,'South','Clothing',700.00),

(8,'West','Electronics',2200.00),
(9,'West','Furniture',1600.00),
(10,'West','Clothing',900.00);
```

---

# SQL Query

```sql
SELECT
    Region,
    SUM(Amount) AS TotalSales,

    SUM(CASE WHEN Category='Electronics' THEN Amount ELSE 0 END) AS ElectronicsSales,
    SUM(CASE WHEN Category='Furniture' THEN Amount ELSE 0 END) AS FurnitureSales,
    SUM(CASE WHEN Category='Clothing' THEN Amount ELSE 0 END) AS ClothingSales

FROM Orders
GROUP BY Region
ORDER BY Region;
```

---

# Query Explanation

This query uses **Conditional Aggregation** to calculate multiple category totals within the same query.

---

## Step 1 – Group Rows by Region

GROUP BY Region

This groups all rows belonging to the same region.

Example rows for **North**:

| Region | Category    | Amount |
| ------ | ----------- | ------ |
| North  | Electronics | 2000   |
| North  | Furniture   | 1500   |
| North  | Electronics | 1000   |
| North  | Clothing    | 500    |

---

## Step 2 – Calculate Total Sales

SUM(Amount)

For North:

2000 + 1500 + 1000 + 500 = 5000

---

## Step 3 – Conditional Aggregation

To calculate **Electronics sales only**, the query uses:

SUM(CASE WHEN Category='Electronics' THEN Amount ELSE 0 END)

Each row is evaluated:

| Category    | Amount | Used in Sum |
| ----------- | ------ | ----------- |
| Electronics | 2000   | 2000        |
| Furniture   | 1500   | 0           |
| Electronics | 1000   | 1000        |
| Clothing    | 500    | 0           |

Total:

2000 + 1000 = 3000

The same logic is applied for:

* Furniture
* Clothing

---

## Step 4 – Sort Results

ORDER BY Region

This ensures output order:

1. North
2. South
3. West

Sorting ensures consistent validation.

---

# Export Result

After running the query, export the results as:

result_s3.csv

In **SQL Server Management Studio (SSMS)**:

1. Run the query
2. Right-click results grid
3. Click **Save Results As**
4. Choose **CSV**

The CSV file should look like:

Region,TotalSales,ElectronicsSales,FurnitureSales,ClothingSales
North,5000.00,3000.00,1500.00,500.00
South,3700.00,1800.00,1200.00,700.00
West,4700.00,2200.00,1600.00,900.00

---

# Validation

The validator compares the exported CSV with the expected answer.

## Validation Checks

* All regions exist
* Total sales per region are correct
* Category totals match
* Row count matches expected output

---

## Tolerance Rules

| Difference            | Example                   | Result |
| --------------------- | ------------------------- | ------ |
| Row order             | West before North         | PASS   |
| Decimal format        | 5000 vs 5000.00           | PASS   |
| Column name variation | total_sales vs TotalSales | PASS   |
| Incorrect totals      | 4800 instead of 5000      | FAIL   |
| Missing region        | Only 2 rows returned      | FAIL   |
| Extra rows            | 4 rows returned           | FAIL   |

---

# PowerShell Validation Script

```powershell
function Validate-S3 {

param(
    [string]$UserCSV,
    [string]$AnswerCSV
)

$user = Import-Csv $UserCSV
$ans  = Import-Csv $AnswerCSV

$user = $user | Sort-Object Region
$ans  = $ans  | Sort-Object Region

if ($user.Count -ne $ans.Count) {
    Write-Output "FAIL: Row count mismatch"
    return
}

for ($i=0; $i -lt $ans.Count; $i++) {

    if ($user[$i].Region -ne $ans[$i].Region) {
        Write-Output "FAIL: Region mismatch"
        return
    }

    if ([math]::Round($user[$i].TotalSales,2) -ne [math]::Round($ans[$i].TotalSales,2)) {
        Write-Output "FAIL: TotalSales mismatch in $($ans[$i].Region)"
        return
    }

    if ([math]::Round($user[$i].ElectronicsSales,2) -ne [math]::Round($ans[$i].ElectronicsSales,2)) {
        Write-Output "FAIL: ElectronicsSales mismatch"
        return
    }

    if ([math]::Round($user[$i].FurnitureSales,2) -ne [math]::Round($ans[$i].FurnitureSales,2)) {
        Write-Output "FAIL: FurnitureSales mismatch"
        return
    }

    if ([math]::Round($user[$i].ClothingSales,2) -ne [math]::Round($ans[$i].ClothingSales,2)) {
        Write-Output "FAIL: ClothingSales mismatch"
        return
    }

}

Write-Output "PASS: Task completed successfully"

}
```

---

# Common Errors

| Error                        | Fix                                       |
| ---------------------------- | ----------------------------------------- |
| Invalid object name 'Orders' | Run the CREATE TABLE script first         |
| Incorrect totals             | Verify CASE conditions                    |
| Extra rows                   | Check GROUP BY logic                      |
| Missing category column      | Add SUM(CASE WHEN ...)                    |
| Validation fails             | Ensure CSV format matches expected output |

---

# Lab Outcome

After completing this lab, you will understand:

* SQL Conditional Aggregation
* Using CASE inside SUM
* Grouping data with GROUP BY
* Exporting SQL results
* Validating results using PowerShell

This technique is commonly used in **data analytics and reporting systems** to generate **multiple calculated columns from a single dataset**.
