-- ====================================================================
-- TASK 3: SQL DATA ANALYSIS
-- Dataset: SaaS_Sales_Command
-- ====================================================================


-- --------------------------------------------------------------------
-- SETUP: Creating a secondary table to demonstrate JOINS
-- --------------------------------------------------------------------
CREATE TABLE Sales_Rep_Details (
    Sales_Rep TEXT,
    Rep_Level TEXT,
    Quota REAL
);

INSERT INTO Sales_Rep_Details (Sales_Rep, Rep_Level, Quota) VALUES 
    ('Taylor', 'Senior', 500000),
    ('Jordan', 'Mid-Level', 300000),
    ('Morgan', 'Senior', 450000),
    ('Riley', 'Junior', 150000),
    ('Avery', 'Junior', 150000);


-- --------------------------------------------------------------------
-- REQUIREMENT A & D: SELECT, WHERE, GROUP BY, ORDER BY & Aggregates
-- Goal: Calculate total revenue and average sales cycle days 
-- for deals closed in North America, grouped by Industry.
-- --------------------------------------------------------------------
SELECT 
    Industry, 
    SUM(Total_Revenue) AS Total_Industry_Revenue, 
    AVG(Sales_Cycle_Days) AS Avg_Sales_Cycle
FROM SaaS_Sales_Command
WHERE Region = 'North America'
GROUP BY Industry
ORDER BY Total_Industry_Revenue DESC;


-- --------------------------------------------------------------------
-- REQUIREMENT B: JOINS (LEFT JOIN)
-- Goal: Combine the main SaaS deals dataset with the Sales Rep 
-- Details table to see the seniority level associated with each deal.
-- --------------------------------------------------------------------
SELECT 
    s.Deal_ID, 
    s.Close_Date, 
    s.Sales_Rep, 
    r.Rep_Level, 
    s.Total_Revenue
FROM SaaS_Sales_Command s
LEFT JOIN Sales_Rep_Details r 
    ON s.Sales_Rep = r.Sales_Rep
LIMIT 15; 


-- --------------------------------------------------------------------
-- REQUIREMENT C: Subqueries
-- Goal: Filter deals to display individual transactions that generated 
-- higher total revenue than the overall company average.
-- --------------------------------------------------------------------
SELECT 
    Deal_ID, 
    Industry, 
    Subscription_Tier, 
    Total_Revenue
FROM SaaS_Sales_Command
WHERE Total_Revenue > (
    SELECT AVG(Total_Revenue) 
    FROM SaaS_Sales_Command
)
ORDER BY Total_Revenue DESC
LIMIT 10;


-- --------------------------------------------------------------------
-- REQUIREMENT E: Create Views for Analysis
-- Goal: Save a shortcut virtual table for high-value Enterprise deals
-- so the sales team can easily monitor massive accounts.
-- --------------------------------------------------------------------
CREATE VIEW High_Value_Enterprise_Deals AS
SELECT 
    Deal_ID, 
    Region, 
    Sales_Rep, 
    Total_Revenue
FROM SaaS_Sales_Command
WHERE Subscription_Tier = 'Enterprise' AND Total_Revenue > 50000;

-- Querying the newly created view:
SELECT * FROM High_Value_Enterprise_Deals;


-- --------------------------------------------------------------------
-- REQUIREMENT F: Optimize queries with indexes
-- Goal: Optimize database speed by indexing the highly-queried 
-- Industry column.
-- --------------------------------------------------------------------
CREATE INDEX idx_industry ON SaaS_Sales_Command(Industry);