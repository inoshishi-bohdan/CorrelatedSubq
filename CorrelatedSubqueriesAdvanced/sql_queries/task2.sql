SELECT id, title, SUM(sum1) AS count_with_discount_5, SUM(sum2) AS count_without_discount_5,
    CASE WHEN (SUM(sum1) = 0 AND SUM(sum2) = 0) THEN 0.00
        ELSE ROUND(((SUM(sum1) - SUM(sum2) * 1.00) / (SUM(sum1) + SUM(sum2) * 1.00)) * 100 ,2)
    END AS difference
    FROM(
        SELECT product.id, product.comment AS title, SUM(order_details.product_amount) AS sum1, 0 AS sum2 FROM
        product LEFT JOIN order_details ON order_details.product_id = product.id
        WHERE order_details.price_with_discount < order_details.price * 0.95
        GROUP BY product.id
        UNION
        SELECT product.id, product.comment AS title,0 AS sum1, SUM(order_details.product_amount) AS sum2 FROM
        product LEFT JOIN order_details ON order_details.product_id = product.id
        WHERE order_details.price_with_discount >= order_details.price * 0.95
        GROUP BY product.id     
        UNION
        SELECT product.id, product.comment AS title, 0 AS sum1, 0 AS sum2 
        FROM
        product LEFT JOIN order_details ON order_details.product_id = product.id
        WHERE product.id NOT IN (SELECT product_id FROM order_details)
)
GROUP BY id
ORDER BY id