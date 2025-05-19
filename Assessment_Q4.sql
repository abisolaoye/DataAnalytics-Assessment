WITH customer_stats AS (
    SELECT
        u.id AS customer_id,
            CONCAT_ws( ' ',u.first_name, u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.created_on, CURRENT_DATE) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        AVG(s.confirmed_amount) AS avg_transaction_value
FROM adashi_staging.users_customuser u
    LEFT JOIN 
 savings_savingsaccount s ON s.owner_id = u.id
    GROUP BY u.id, u.name, u.created_on
)

SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    -- Calculate CLV using simplified formula

    CASE 
        WHEN tenure_months > 0 
        THEN (total_transactions / tenure_months) * 12 * (avg_transaction_value * 0.001)
        ELSE 0
    END AS estimated_clv
FROM customer_stats
ORDER BY estimated_clv DESC;
