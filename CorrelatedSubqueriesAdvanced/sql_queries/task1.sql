SELECT person.name, person.surname, ROUND(AVG(price_with_discount * product_amount), 2) AS avg_purchase, ROUND(SUM(price_with_discount * product_amount), 2) AS sum_purchase
FROM 
customer_order LEFT JOIN customer ON customer_order.customer_id = customer.person_id
LEFT JOIN person ON customer.person_id = person.id
LEFT JOIN order_details ON order_details.customer_order_id = customer_order.id
GROUP BY surname HAVING (SELECT AVG(sum)
FROM (SELECT price_with_discount * product_amount AS sum 
FROM person INNER JOIN customer ON person.id = customer.person_id
INNER JOIN customer_order ON customer_order.customer_id = customer.person_id
INNER JOIN order_details ON order_details.customer_order_id = customer_order.id
GROUP BY customer_order_id)) > 70
ORDER BY sum_purchase, surname