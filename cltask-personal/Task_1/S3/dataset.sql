CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    Region VARCHAR(50),
    Category VARCHAR(50),
    Amount DECIMAL(10,2)
);

INSERT INTO Orders VALUES
(1,'North','Electronics',2000),
(2,'North','Furniture',1500),
(3,'North','Electronics',1000),
(4,'North','Clothing',500),

(5,'South','Electronics',1800),
(6,'South','Furniture',1200),
(7,'South','Clothing',700),

(8,'West','Electronics',2200),
(9,'West','Furniture',1600),
(10,'West','Clothing',900);