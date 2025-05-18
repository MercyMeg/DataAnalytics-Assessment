SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(sa.id) AS total_transactions,

    ROUND(
        (
            (COUNT(sa.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) 
            * 12 
            * (
                (SUM(COALESCE(sa.confirmed_amount, 0)) / COUNT(sa.id)) 
                * 0.001
            )
        ) / 100, 2
    ) AS estimated_clv

FROM 
    users_customuser u
JOIN 
    savings_savingsaccount sa 
    ON u.id = sa.owner_id

-- Optional: Add WHERE clause to filter inflows, if needed
-- WHERE sa.transaction_type_id = <id_for_inflow>

GROUP BY 
    u.id, name, tenure_months

ORDER BY 
    estimated_clv DESC;
