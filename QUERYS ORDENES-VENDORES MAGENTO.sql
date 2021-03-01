SELECT 
	distinct(ms.entity_id) AS ID, 
	ms.magerealorder_id AS Order_id,
	ms.magepro_name AS Item,
	ms.total_amount,
	ms.total_tax,
	ms.total_commission,
	ms.created_at,
	ms.seller_id,
	ce.firstname AS FirstName_Seller,
	ce.lastname AS LastName_Seller,
	ce.email AS email_Seller,
	ms.commission_rate,
	ce.taxvat AS Schema_Code
FROM marketplace_saleslist ms 
inner join customer_entity ce on ms.seller_id = ce.entity_id 

/* Numero de identificacion tributaria: tipo de documento  IDENTIFICAR LA INFORMACION DEL COMPRADOR
 * Metodo de envio de información de clientes y ventas....
 * Crear cta de odoo
 * +domicilio de facturación cargar al reporte
 * +telefono del cliente
 * +Tipo de documento
 * 
 * */

/*QUERY VENDEDORES*/


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
ORDER BY 12 DESC;


#vista creada

SeLECT * FROM REPORTE_VENDEDORES rv where ENTITY_ID ='70'

SELECT *fROM marketplace_userdata


