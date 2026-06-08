SELECT 
    strftime('%Y', order_date) AS sales_year,
    strftime('%m', order_date) AS sales_month,
    
    SUM(CAST(order_amount AS REAL)) AS total_item_revenue,
    SUM(CAST(shipping_fee AS REAL)) AS total_shipping_revenue,
    
    COUNT(DISTINCT order_id) AS total_successful_orders,
    COUNT(DISTINCT customer_id) AS unique_shoppers
FROM 
    ecommerce_sales

WHERE 
    order_date >= '2025-01-01' AND order_date <= '2025-12-31'
    AND is_returned = 0

GROUP BY 
    sales_year, 
    sales_month

ORDER BY 
    sales_year ASC, 
    sales_month ASC;