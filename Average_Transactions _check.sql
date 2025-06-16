
 WITH monthly_counts AS (
  SELECT
    owner_id,
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    COUNT(*) AS transactions_in_month
  FROM adashi_staging.savings_savingsaccount
  GROUP BY owner_id, transaction_month
),

avg_transactions AS (
  SELECT
    owner_id,
    AVG(transactions_in_month) AS avg_transactions_per_month
  FROM monthly_counts
  GROUP BY owner_id
),

categorized AS (
  SELECT
    owner_id,
    avg_transactions_per_month,
    CASE
      WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
      WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category
  FROM avg_transactions
)

SELECT
  frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;

 
