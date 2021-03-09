
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



alter table sales_order add column estado_mig_odoo varchar(5);

select *from sales_order





#ACTUALIZAR ESTADO DE LAS ORDENES
DELIMITER $$
CREATE PROCEDURE ACTUALIZACION_ORDENES()
BEGIN
#CAMBIA EL ESTADO EN LA TABLA DE ORDENES
UPDATE sales_order SET status ='complete',state='complete'  WHERE sales_order.status <>'complete' AND sales_order.state <>'complete';	

#CAMBIA EL ESTADO EN LA GRILLA DE ORDENES
UPDATE sales_order_grid SET STATUS='complete' WHERE STATUS<>'complete';	

#CAMBIA EL ESTADO EN EL MARKETPLACE
UPDATE marketplace_orders SET order_status ='complete' WHERE order_status<>'complete';
	
END

DELIMITER;

#ejecutar la actualizacion de ordenes

CALL ACTUALIZACION_ORDENES();

DROP PROCEDURE ACTUALIZACION_ORDENES;
drop trigger TR_ACTUALIZAR_ORDENES;
SHOW TRIGGERS;
SHOW EVENTS;
DROP EVENT JOB_ACTUALIZAR_ORDENES;
SELECT * FROM information_schema.EVENTS 
DELIMITER $$

CREATE TRIGGER TR_ACTUALIZAR_ORDENES AFTER INSERT ON sales_order  FOR EACH ROW
BEGIN
	CALL ACTUALIZACION_ORDENES();
END
DELIMITER ;



#JOB SE EJECUTA A LAS 06:000

CREATE EVENT JOB_ACTUALIZAR_ORDENES
ON SCHEDULE EVERY 1 DAY STARTS DATE_SUB(NOW(), INTERVAL 5 HOUR)+INTERTVAL 1 MINUTE #'2021-03-05 17:35:00'
DO CALL ACTUALIZACION_ORDENES();

#fecha y hora
SELECT SYSDATE();
SELECT DATE_SUB(NOW(), INTERVAL 3 HOUR) 
NOW();



#validacion de la activacion de eventos

SHOW VARIABLES WHERE variable_name='event_scheduler';
SET GLOBAL event_scheduler = ON;







