select
product_id,title,manufacturer_id,manufacturer as manufacturer
from (
select
pt.id product_id, pt.title,
case when od.id is not null then m.id end manufacturer_id,
case when od.id is not null then m.name end manufacturer,
sum(od.product_amount) s,
max(sum(od.product_amount)) over (partition by pt.id) sm
from product_title pt
left join product p on p.product_title_id = pt.id
left join order_details od on od.product_id = p.id
left join manufacturer m on m.id = p.manufacturer_id
group by pt.id, pt.title, p.manufacturer_id
)
WHERE sm is null or s = sm
group by product_id
order by product_id