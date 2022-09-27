select
person.name,
person.surname,


round(avg(order_details.price_with_discount*order_details.product_amount),2) as avg_purchase,
round(sum(order_details.price_with_discount*order_details.product_amount),2) as sum_purchase
from order_details


left join customer_order on order_details.customer_order_id=customer_order.id
left join customer on customer_order.customer_id=customer.person_id
left join person on customer.person_id=person.id


where 70<(
    select 
    order_details.price_with_discount*order_details.product_amount as money
    from order_details
    left join customer_order on order_details.customer_order_id=customer_order.id
    left join customer on customer_order.customer_id=customer.person_id
    left join person on customer.person_id=person.id
)
group by person.id
order by sum_purchase, surname