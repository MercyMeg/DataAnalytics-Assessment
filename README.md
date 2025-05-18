{\rtf1\ansi\ansicpg1252\cocoartf2709
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 HelveticaNeue;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww33400\viewh19380\viewkind0
\deftab560
\pard\pardeftab560\slleading20\pardirnatural\partightenfactor0

\f0\fs26 \cf0 Data Analytics SQL Assessment\
\
Question 1: Customers with Savings and Investment Plans\
\
Approach\
- Joined `users_customuser`, `plans_plan`, and `savings_savingsaccount`.\
- Counted how many plans are savings vs investment per user.\
- Filtered to only include users with both types and successful transactions.\
\
 Challenge\
- Initially had to cross-check status values to include common success terms (like `monnify_success`).\
\
\
\
Question 2: Transaction Frequency Categorization\
\
Approach\
- Used `EXTRACT()` to group transactions by year and month.\
- Aggregated monthly transactions per user.\
- Categorized users into High, Medium, or Low frequency.\
\
Challenge\
- MySQL doesn't support `year || '-' || month` \uc0\u8594  replaced with `CONCAT()`.\
\
\
\
Question 3: Inactive Plans (No inflow in 12+ months)\
\
Approach\
- Pulled last inflow per plan using MAX().\
- Compared that date to `CURRENT_DATE` to compute inactivity.\
- Selected only those with 365+ days of inactivity.\
\
Challenge\
- `DATEDIFF()` needed to be used instead of more complex date functions.\
\
\
\
Question 4: Customer Lifetime Value (CLV) Estimation\
\
Approach\
- Calculated tenure in months and total transactions per user.\
- Averaged transaction amount and applied 0.1% profit rate.\
- Used formula to estimate CLV and converted from kobo to naira.\
\
Challenge\
- CLV calculation required careful nesting to avoid division and rounding issues in MySQL.\
- Removed non-existent fields (like `amount_withdrawn`) from early attempts.\
\
}