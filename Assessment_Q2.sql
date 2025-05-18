WITH monthly_transactions AS (
    SELECT 
        owner_id,
        EXTRACT(YEAR FROM transaction_date) AS year,   -- Extract year
        EXTRACT(MONTH FROM transaction_date) AS month,  -- Extract month
        COUNT(*) AS total_transactions
    FROM savings_savingsaccount
    WHERE transaction_date BETWEEN '2016-08-01' AND '2025-04-30' 
    and LOWER(transaction_status) IN ('success', 'successful', 'monnify_success')-- Date range
    GROUP BY owner_id, year, month
),
user_monthly_avg AS (
    SELECT
        owner_id,
        SUM(total_transactions) AS total_transactions,         -- Total transactions for user
        COUNT(DISTINCT year || '-' || month) AS active_months   -- Count distinct months the user has transacted in
    FROM monthly_transactions
    GROUP BY owner_id
),
avg_transactions_per_user AS (
    SELECT
        owner_id,
        total_transactions / active_months AS avg_transactions_per_month
    FROM user_monthly_avg
)
SELECT 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        WHEN avg_transactions_per_month <= 2 THEN 'Low Frequency'
    END AS frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM avg_transactions_per_user
GROUP BY frequency_category
ORDER BY frequency_category DESC;
