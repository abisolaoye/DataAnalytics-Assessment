# Customer Segmentation Project


 

SQL Project: High-Value Customers with Multiple Products
This project explores key customer insights from the Adashi platform. The first task focuses on identifying high-value customers who hold both savings and investment products.
 High-Value Customers with Multiple Products
Scenario: The business team wants to identify customers who have both a funded savings and investment plan. This enables the team to assess cross-selling opportunities and reward loyalty.

✅ Objective:
Write a query to return customers who have:

At least one funded savings plan (is_regular_savings = 1)

At least one funded investment plan (is_fixed_investment = 1)

Sorted by their total deposits (from confirmed_amount field in kobo)

##  Approach:
Joined Tables:

plans_plan (for identifying savings and investment types)

users_customuser (for customer info like name)

savings_savingsaccount (for deposit details and account status)

Used COUNT(CASE WHEN ...) to get:

Number of savings plans per customer with is_regular_savings = 1 and new_balance > 0

Number of investment plans per customer with is_fixed_investment = 1 and new_balance > 0

Used SUM(confirmed_amount) to calculate total deposits

Applied a HAVING clause to filter for customers with both types

Grouped results by user to ensure correct aggregation

## Output Columns:
Column	Description
owner_id	Customer's unique identifier
name	Concatenated first and last name
savings_count	Number of active savings plans
investment_count	Number of active investment plans
total_deposits	Sum of confirmed deposits (in kobo)

⚠️ Challenges & Resolutions
## 1. Query Timeout
Issue: Query was slow and kept timing out.

Fix:

Removed DISTINCT, which was unnecessary after using GROUP BY.

Verified join conditions were correct.

Limited filtering with WHERE b.is_active = 1.

## 2. Incorrect Column in HAVING Clause
Issue: Mistyped a.is is_a_fund instead of a.is_a_fund.

Fix: Corrected the syntax for filtering investment-type plans.

## 3. Table Relationships
Issue: Confusion around using id vs owner_id in savings_savingsaccount.

Fix: Ensured all references to the customer were made via owner_id (not row-level id)


##Monthly Aggregation:

I extracted owner_id and grouped transactions by the year and month (using DATE_FORMAT(transaction_date, '%Y-%m')) to get the number of transactions per month per customer.

## Average Transactions Calculation:
For each owner_id, I calculated the average number of monthly transactions using an aggregate over the monthly counts.

## Segmentation:
Using a CASE statement, I assigned each customer a frequency category (Low, Medium, High) based on their calculated average.

## Final Output:
I grouped by frequency_category to show how many customers fall into each group and the average transaction volume.

📈 Final Output Columns
Column	Description
frequency_category	Low / Medium / High
customer_count	Number of customers in that category
avg_transactions_per_month	Average monthly transactions in that group

🧩 Challenges & How I Solved Them
Date Grouping Logic:
Initially, I considered using TRUNC() but realized it's not supported in MySQL. I switched to DATE_FORMAT() for better compatibility.

## Identifying Customers Correctly:
At first, I used the transaction id, which led to incorrect customer grouping. I fixed this by using owner_id, which correctly represents the customer.

## Performance Concerns:
Grouping by both customer and month across potentially large transaction tables was a concern, so I wrote a CTE (monthly_counts) to isolate and reduce data early in the query flow.


## challenge :
The business wants to re-engage inactive users who haven’t transacted recently.

## Task
Find all active accounts (savings or investments) with no transactions in the last 1 month.

Tables Used:

users_customuser

plans_plan

savings_savingsaccount (transaction data assumed here)

## Approach
Identify Active Users:
I filtered for users where is_active = 1 from the users_customuser table.

## Active Product Plans:
I joined plans_plan to identify customers with savings (is_regular_savings = 1) or investment plans (is_a_fund = 1).

Check for Last Transaction:
Using the last_transaction_date, I calculated the inactivity_days with DATEDIFF(CURRENT_DATE, last_transaction_date).

Filter for Inactivity:
Accounts where last_transaction_date is older than 30 days were flagged as inactive.

Final Output:
Only users with a savings or investment plan and no transactions in the last 1 month were included.

##  Final Output Columns
Column	Description
owner_id	Unique ID of the customer
name	Full name of the customer
product_type	Savings / Investment
last_transaction_date	Date of last activity
inactivity_days	Days since the last transaction

 ## Challenges & Fixes
Null Transaction Dates:
Some users had NULL for last_transaction_date. I handled this using COALESCE() with a placeholder early date to still compute inactivity properly.

## Ambiguous Plan Type:
Initially, I used is_fixed_investment but later corrected it to is_a_fund based on the schema hint.

Multiple Joins Affecting Row Count:
Careful filtering post-join ensured I didn’t double count customers who had multiple plans but one was active.


## Customer Lifetime Value (CLV) Estimation
 Scenario:
The marketing team wants to estimate CLV using account tenure and transaction volume.
 Task
For each customer, calculate:

Account tenure (in months since signup)

Total transactions

## Estimated CLV using:
CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction
where avg_profit_per_transaction = 0.1% of total value

Tables Used:

users_customuser

savings_savingsaccount

## Approach
Calculate Tenure:
I used TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE) to get the number of months each customer has had an account.

Transaction Counts:
Summed up transactions using COUNT() on valid confirmed_amount records from the savings_savingsaccount table.

Profit Logic:
Computed total transaction value, applied 0.1% to estimate avg_profit_per_transaction.

CLV Computation:
Plugged into the simplified formula to get estimated CLV for each customer.

Sorting:
Ordered by estimated_clv DESC to highlight highest-value customers.

📈 Final Output Columns
Column	Description
customer_id	ID of the customer
name	Customer full name
tenure_months	Account age in months
total_transactions	Count of all transactions
estimated_clv	CLV based on formula

## Challenges & Fixes
Tenure Handling:
Some customers had very recent signups (e.g., less than a month). I added a safeguard to avoid divide-by-zero in the CLV formula.

## Missing Transactions:
Transactions with zero or null values were excluded to prevent inflation of CLV.

## Query Performance:
I used CTEs and filtering before grouping to reduce query runtime and ensure correct grouping logic.





