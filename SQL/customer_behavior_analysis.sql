
-- CUSTOMER BEHAVIOR ANALYTICS

-- SECTION A: Executive KPIs

-- Q1. How many customer records are in the dataset?
SELECT
    COUNT(*) AS total_customers
FROM customer_behavior;

-- Q2. What is the total revenue generated?
SELECT
    SUM(purchase_amount) AS total_revenue
FROM customer_behavior;

-- Q3. What is the average purchase amount?
SELECT
    ROUND(AVG(purchase_amount)::numeric, 2) AS average_purchase_amount
FROM customer_behavior;

-- Q4. What is the average customer review rating?
SELECT
    ROUND(AVG(review_rating)::numeric, 2) AS average_review_rating
FROM customer_behavior;


-- SECTION B: Customer Demographics

-- Q5. What is the customer distribution by gender?
SELECT
    gender,
    COUNT(*) AS total_customers,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ())::numeric, 2) AS percentage
FROM customer_behavior
GROUP BY gender
ORDER BY total_customers DESC;

-- Q6. Which age group has the highest number of customers?
SELECT
    age_group,
    COUNT(*) AS total_customers
FROM customer_behavior
GROUP BY age_group
ORDER BY total_customers DESC;

-- Q7. Which age group generates the highest revenue?
SELECT
    age_group,
    SUM(purchase_amount) AS total_revenue
FROM customer_behavior
GROUP BY age_group
ORDER BY total_revenue DESC;

-- Q8. What is the average purchase amount by gender?
SELECT
    gender,
    ROUND(AVG(purchase_amount)::numeric, 2) AS average_purchase_amount
FROM customer_behavior
GROUP BY gender
ORDER BY average_purchase_amount DESC;


-- SECTION C: Product & Sales Performance

-- Q9. Which product category generates the highest revenue?
SELECT
    category,
    SUM(purchase_amount) AS total_revenue
FROM customer_behavior
GROUP BY category
ORDER BY total_revenue DESC;

-- Q10. Which product category has the highest number of purchases?
SELECT
    category,
    COUNT(*) AS total_purchases
FROM customer_behavior
GROUP BY category
ORDER BY total_purchases DESC;

-- Q11. What are the top 10 most purchased items?
SELECT
    item_purchased,
    COUNT(*) AS total_purchases
FROM customer_behavior
GROUP BY item_purchased
ORDER BY total_purchases DESC
LIMIT 10;

-- Q12. Which items generate the highest revenue?
SELECT
    item_purchased,
    SUM(purchase_amount) AS total_revenue
FROM customer_behavior
GROUP BY item_purchased
ORDER BY total_revenue DESC
LIMIT 10;

-- Q13. Which season generates the highest revenue?
SELECT
    season,
    SUM(purchase_amount) AS total_revenue
FROM customer_behavior
GROUP BY season
ORDER BY total_revenue DESC;

-- SECTION D: Customer Behavior & Marketing

-- Q14. Do subscribed customers spend more on average?
SELECT
    subscription_status,
    COUNT(*) AS total_customers,
    ROUND(AVG(purchase_amount)::numeric, 2) AS average_purchase_amount,
    SUM(purchase_amount) AS total_revenue
FROM customer_behavior
GROUP BY subscription_status
ORDER BY total_revenue DESC;

-- Q15. Does discount usage affect average purchase amount?
SELECT
    discount_applied,
    COUNT(*) AS total_purchases,
    ROUND(AVG(purchase_amount)::numeric, 2) AS average_purchase_amount,
    SUM(purchase_amount) AS total_revenue
FROM customer_behavior
GROUP BY discount_applied
ORDER BY average_purchase_amount DESC;

-- Q16. Which payment methods are used most frequently?
SELECT
    payment_method,
    COUNT(*) AS total_purchases
FROM customer_behavior
GROUP BY payment_method
ORDER BY total_purchases DESC;

-- Q17. Which shipping type is most commonly used?
SELECT
    shipping_type,
    COUNT(*) AS total_orders
FROM customer_behavior
GROUP BY shipping_type
ORDER BY total_orders DESC;

-- Q18. Which purchase frequency group has the highest number of customers?
SELECT
    frequency_of_purchases,
    COUNT(*) AS total_customers
FROM customer_behavior
GROUP BY frequency_of_purchases
ORDER BY total_customers DESC;


-- SECTION E: Advanced SQL Analysis

-- Q19. Segment customers based on previous purchases.
SELECT
    CASE
        WHEN previous_purchases = 1 THEN 'New Customer'
        WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning Customer'
        ELSE 'Loyal Customer'
    END AS customer_segment,
    COUNT(*) AS total_customers
FROM customer_behavior
GROUP BY customer_segment
ORDER BY total_customers DESC;

-- Q20. Rank product categories by total revenue.
SELECT
    category,
    SUM(purchase_amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(purchase_amount) DESC) AS revenue_rank
FROM customer_behavior
GROUP BY category;

-- Q21. What percentage of total revenue does each category contribute?
SELECT
    category,
    SUM(purchase_amount) AS category_revenue,
    ROUND(
        (
            SUM(purchase_amount) * 100.0
            / SUM(SUM(purchase_amount)) OVER ()
        )::numeric,
        2
    ) AS revenue_percentage
FROM customer_behavior
GROUP BY category
ORDER BY revenue_percentage DESC;

-- Q22. What are the top 3 products within each category by revenue?
WITH product_revenue AS (
    SELECT
        category,
        item_purchased,
        SUM(purchase_amount) AS total_revenue,
        RANK() OVER (
            PARTITION BY category
            ORDER BY SUM(purchase_amount) DESC
        ) AS product_rank
    FROM customer_behavior
    GROUP BY category, item_purchased
)
SELECT
    category,
    item_purchased,
    total_revenue,
    product_rank
FROM product_revenue
WHERE product_rank <= 3
ORDER BY category, product_rank;

-- Q23. Which locations generate the highest revenue?
SELECT
    location,
    SUM(purchase_amount) AS total_revenue
FROM customer_behavior
GROUP BY location
ORDER BY total_revenue DESC
LIMIT 10;

-- Q24. Identify high-value customers based on purchase amount.
SELECT
    customer_id,
    age,
    gender,
    category,
    item_purchased,
    purchase_amount,
    previous_purchases
FROM customer_behavior
ORDER BY purchase_amount DESC
LIMIT 10;

-- Q25. Compare the average review rating by product category.
SELECT
    category,
    ROUND(AVG(review_rating)::numeric, 2) AS average_review_rating
FROM customer_behavior
GROUP BY category
ORDER BY average_review_rating DESC;