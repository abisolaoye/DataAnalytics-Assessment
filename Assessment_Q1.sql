SELECT  
    a.owner_id,
    CONCAT_WS(' ', b.first_name, b.last_name) AS name,
    COUNT(CASE WHEN a.is_regular_savings = 1 AND c.new_balance > 0 THEN 1 END) AS savings_count,
    COUNT(CASE WHEN a.is_a_fund = 1 AND c.new_balance > 0 THEN 1 END) AS investment_count,
    ROUND(SUM(c.confirmed_amount), 2) AS total_deposits
FROM adashi_staging.plans_plan a
JOIN adashi_staging.users_customuser b ON a.owner_id = b.id
JOIN adashi_staging.savings_savingsaccount c ON a.id = c.plan_id
WHERE b.is_active = 1
GROUP BY a.owner_id, b.first_name, b.last_name
HAVING 
    savings_count >= 1
    AND investment_count >= 1
ORDER BY total_deposits DESC;
