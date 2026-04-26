📌 Project Overview
This project analyses transactional data from a fashion retail store using MySQL. The goal is to extract actionable business insights
from raw sales data — understanding which products sell best, who the top customers are, which channels drive the most revenue, and
which items are at risk of stockout.
The project progresses through three difficulty levels:

🟢 Basic — Aggregations, filtering, DISTINCT
🟡 Intermediate — Multi-table JOINs, GROUP BY, CONCAT
🔴 Advanced — Window functions (ROW_NUMBER, DENSE_RANK), nested subqueries

 Key Insights

Online channel dominates — ~45% of total revenue comes from the digital platform; digital investment yields the highest return.
Outerwear & Footwear have the highest average price points — premium segments that benefit from targeted promotions.
Classic White Tee is the highest volume seller; Leather Jacket leads in total revenue — quantity ≠ profitability.
DENSE_RANK() correctly identifies the 2nd highest spender when there are ties — LIMIT/OFFSET fails in such edge cases.
Low stock detection (stock < 50 units) enables proactive reordering — automating this query prevents lost revenue from stockouts.
Top 5 customers account for a disproportionately large share of total spending — strong case for a VIP loyalty programme.
USA leads country-wise sales — geo-targeted campaigns and regional logistics optimisation offer growth opportunities.



