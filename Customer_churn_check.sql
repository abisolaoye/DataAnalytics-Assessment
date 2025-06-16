WITH last_transactions AS (
  SELECT
    plan_id,
    owner_id,
    MAX(transaction_date) AS last_transaction_date
FROM adashi_staging.savings_savingsaccount
  GROUP BY plan_id, owner_id
),
inactivity AS (
  SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE
      WHEN p.is_regular_savings = 1 THEN 'Savings'
      WHEN p.is_a_fund= 1 THEN 'Investment'
      ELSE 'Other'
    END AS type,
    COALESCE(lt.last_transaction_date, '1900-01-01') AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, COALESCE(lt.last_transaction_date, '1900-01-01')) AS inactivity_days
  FROM  adashi_staging.plans_plan p
  LEFT JOIN last_transactions lt
    ON p.id = lt.plan_id 
    AND p.owner_id = lt.owner_id
  WHERE
    p.is_archived = 0
    AND p.is_deleted = 0
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
)
SELECT
  plan_id,
  owner_id,
  type,
  last_transaction_date,
  inactivity_days
FROM inactivity
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC;
