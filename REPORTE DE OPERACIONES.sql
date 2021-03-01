/*select * from sales_shipment_grid#detalle compra nombre del compradorenvio *
select * from sales_shipment_item #detalle compra con productos *
select * from sales_invoice_grid #detalle facturacion *
select *FROM marketplace_orders #status order
SELECT * FROM marketplace_saleslist WHERE magerealorder_id='000000158' and magepro_price<>0
SELECT  *from information_schema.TABLES t WHERE TABLE_NAME LIKE '%state%'
select * from sales_order_status_state
select * from catalog_product_varchar cpev 
select * from catalog_product_entity
select
sales_shipment_grid.order_id AS NUMERO_SHIPMENT,
sales_shipment_grid.order_increment_id AS REFERENCIA_ORDEN,
sales_shipment_grid.order_status AS ESTADO_ORDEN,
sales_shipment_grid.order_created_at AS FECHA_ORDEN,
sales_shipment_grid.billing_name AS BILLING_NAME,
sales_shipment_grid.shipping_name AS SHIPPING_NAME,
sales_shipment_grid.customer_email AS CUSTOMER_EMAIL,
sales_shipment_grid.billing_address AS BILLING_ADDRESS,
sales_shipment_grid.shipping_address AS SHIPPING_ADDRESS

from 
sales_shipment_grid*/

SELECT
NUMERO_ORDEN,
FECHA_COMPRA,
NUMERO_SHIPMENT,
REFERENCIA_ORDEN,
BILL_TO_NAME,
BILLING_ADDRESS,
SHIPPING_ADDRESS,
ID_PRODUCTO,
SKU,
SHIPPING_NAME,
CUSTOMER_EMAIL,
NUMERO_FACTURA,
SUBTOTAL,
BASE_GRAN_TOTAL,
GRAN_TOTAL,
SHIPPING_HANDLING,
ESTADO,
SHIPING_INFORMATION,
PRODUCTO,
ID_VENDOR,
NOMBRE_CUSTOMER AS NOMBRE_VENDEDOR,
IDENTIFICACION,
TELEFONO,
CIUDAD_DOMICILIO,
DIRECCION_DOMICILIO,
(SELECT LAST_TRANS_ID FROM sales_order_payment WHERE PARENT_ID=NUMERO_SHIPMENT)AS NUMERO_TRANSACCION_PASARELA



FROM 
(
SELECT * FROM
(
SELECT
T2.*
FROM 
(

SELECT 
T1.*,
mageproduct_id AS ID_PRODUCTO,
marketplace_saleslist.magepro_name AS PRODUCTO,
marketplace_saleslist.seller_id AS ID_VENDOR,
marketplace_saleslist.magepro_price,
(SELECT SKU FROM catalog_product_entity WHERE row_id =ID_PRODUCTO)AS SKU

FROM(
SELECT
sales_invoice_grid.order_increment_id AS NUMERO_ORDEN,
sales_invoice_grid.order_created_at AS FECHA_COMPRA,
sales_invoice_grid.order_id AS NUMERO_SHIPMENT,
sales_invoice_grid.increment_id AS REFERENCIA_ORDEN,
sales_invoice_grid.customer_name AS BILL_TO_NAME,
sales_invoice_grid.billing_address AS BILLING_ADDRESS,
sales_invoice_grid.shipping_address AS SHIPPING_ADDRESS,
sales_shipment_grid.shipping_name AS SHIPPING_NAME,
sales_invoice_grid.customer_email AS CUSTOMER_EMAIL,
sales_invoice_grid.increment_id AS NUMERO_FACTURA,
sales_invoice_grid.subtotal AS SUBTOTAL,
sales_invoice_grid.base_grand_total AS BASE_GRAN_TOTAL,
sales_invoice_grid.grand_total AS GRAN_TOTAL,
sales_invoice_grid.shipping_and_handling AS SHIPPING_HANDLING,
sales_shipment_grid.order_status AS ESTADO,
sales_shipment_grid.shipping_information AS SHIPING_INFORMATION



FROM 
sales_invoice_grid
LEFT JOIN
sales_shipment_grid

ON sales_invoice_grid.order_id =sales_shipment_grid.order_id 

)AS T1

LEFT JOIN 
marketplace_saleslist


ON marketplace_saleslist.magerealorder_id=T1.NUMERO_ORDEN
)T2
WHERE magepro_price<>0
)AS T3



LEFT JOIN 

(
SELECT 
DISTINCT(customer_entity_varchar.entity_id) AS ID_VENDEDOR,
customer_grid_flat.name AS NOMBRE_CUSTOMER,
MAX(CASE WHEN customer_entity_varchar.attribute_id =289 THEN customer_entity_varchar.value END )AS APELLIDO,
customer_grid_flat.num_personal_identification AS IDENTIFICACION,
MAX(CASE WHEN customer_entity_varchar.attribute_id =216 THEN customer_entity_varchar.value  END )AS IDENTIFICACION_2,
CASE WHEN marketplace_userdata.is_seller=1 THEN 'VENDEDOR' ELSE 'NO VENDEDOR'END AS TIPO_CUSTOMER,
MAX(CASE WHEN customer_entity_varchar.attribute_id =292 THEN customer_entity_varchar.value END )AS NOMBRE_TIENDA,
MAX(CASE WHEN customer_entity_varchar.attribute_id =223 THEN customer_entity_varchar.value END )AS EMAIL_PAGO,
CASE WHEN customer_grid_flat.type_document=0 THEN 'JURIDICO' ELSE 'NATURAL' END AS TIPO_ESTADO_CUSTOMER,
MAX(CASE WHEN customer_entity_varchar.attribute_id =229 THEN customer_entity_varchar.value END )AS TELEFONO,
MAX(CASE WHEN customer_entity_varchar.attribute_id =210 THEN customer_entity_varchar.value END )AS CIUDAD_DOMICILIO,
customer_grid_flat.created_at AS CREADO_DESDE,
MAX(CASE WHEN customer_entity_varchar.attribute_id =211 THEN customer_entity_varchar.value END )AS PAIS,
MAX(CASE WHEN customer_entity_varchar.attribute_id =310 THEN customer_entity_varchar.value  END )AS DIRECCION_RECOJO_1,
MAX(CASE WHEN customer_entity_varchar.attribute_id =313 THEN customer_entity_varchar.value  END )AS DIRECCION_RECOJO_2,
MAX(CASE WHEN customer_entity_varchar.attribute_id =316 THEN customer_entity_varchar.value  END )AS DIRECCION_RECOJO_3,
MAX(CASE WHEN customer_entity_varchar.attribute_id =213 THEN customer_entity_varchar.value  END )AS DIRECCION_DOMICILIO
FROM
customer_entity_varchar,
customer_grid_flat,
marketplace_userdata
WHERE 
customer_entity_varchar.entity_id=customer_grid_flat.entity_id
AND customer_entity_varchar.entity_id=marketplace_userdata.seller_id
#AND marketplace_userdata.is_seller=1

GROUP BY customer_entity_varchar.entity_id


)AS TC

ON T3.ID_VENDOR=TC.ID_VENDEDOR
)AS TF

select * from eav_attribute ea where attribute_id in(158,159,227,230,240,241,242)
SELECT  *FROM customer_entity
SELECT  *FROM customer_entity_decimal ced 





