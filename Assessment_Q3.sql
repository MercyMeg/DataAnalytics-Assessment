WITH inflow_transactions AS (
    SELECT 
        plan_id,
        owner_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0 
        and LOWER(transaction_status) IN ('success', 'successful', 'monnify_success')-- Date range
    GROUP BY plan_id, owner_id
),
inactive_plans AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        p.description as type,
        it.last_transaction_date,
        DATEDIFF('2025-04-30', it.last_transaction_date) AS inactivity_days
    FROM plans_plan p
    LEFT JOIN inflow_transactions it ON p.id = it.plan_id AND p.owner_id = it.owner_id
    WHERE DATEDIFF(CURRENT_DATE, it.last_transaction_date) > 365
)
SELECT * 
FROM inactive_plans
ORDER BY inactivity_days DESC;
