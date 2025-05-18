SELECT 
    ucu.id AS owner_id, 
    CONCAT(ucu.first_name, ' ', ucu.last_name) AS name,

    SUM(CASE 
        WHEN pln.is_regular_savings = 1 THEN 1 
        ELSE 0 
    END) AS savings_count,

    SUM(CASE 
        WHEN pln.is_a_fund = 1 THEN 1 
        ELSE 0 
    END) AS investment_count,

    SUM(sav.confirmed_amount) AS total_deposits

FROM users_customuser AS ucu
JOIN plans_plan AS pln ON ucu.id = pln.owner_id
JOIN savings_savingsaccount AS sav ON pln.id = sav.plan_id AND ucu.id = sav.owner_id

WHERE LOWER(sav.transaction_status) IN ('success', 'successful', 'monnify_success')

GROUP BY ucu.id, name
HAVING 
    savings_count > 0 AND 
    investment_count > 0 AND 
    total_deposits > 0

ORDER BY total_deposits DESC;
