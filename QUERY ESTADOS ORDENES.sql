/*QUERY ESTADOS ORDENES*/

SELECT DISTINCT (marketplace_saleslist.order_id)AS ORDER_ID,
sales_order.state AS STATE_ORDER,
sales_order.status AS ORDER_STATUS_ORDEN,
marketplace_orders.order_status AS ORDER_STATUS_MARKETPLACE,
marketplace_saleslist.order_id,
marketplace_saleslist.parent_item_id,
sales_order.customer_id,
sales_order.base_grand_total,
sales_order.increment_id AS ORDER_ID_SALES_ORDER,
sales_order.created_at AS FECHA_CREACION,
sales_order.updated_at AS FECHA_ACTUALIZACION

FROM
sales_order,
marketplace_saleslist,
marketplace_orders
WHERE 
sales_order.increment_id=marketplace_saleslist.magerealorder_id
AND marketplace_saleslist.order_id=marketplace_orders.order_id
AND marketplace_saleslist.parent_item_id <>' ';

select * from marketplace_orders where order_id=38
select i from sales_order


UPDATE sales_order SET status ='complete',state='complete' 
WHERE 
increment_id IN ();