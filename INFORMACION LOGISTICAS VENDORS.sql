
CREATE PROCEDURE INFORMACION_LOGISTICA_VENDOR(IN ID_SELLER_BUSCADO VARCHAR(5))
BEGIN
SELECT  * FROM

(
select
customer_entity_int.entity_id AS ID_SELLER,
IF((SELECT MAX(IS_SELLER) FROM marketplace_userdata WHERE SELLER_ID=ID_SELLER )=1,"VENDEDOR","COMPRADOR")AS TIPO_CUSTOMER,
#MAX(CASE WHEN Y.ID_ATRIBUTO =286 THEN Y.VALOR END )AS NOMBRE,
Y.NOMBRE,
MAX(CASE WHEN customer_entity_int.attribute_id=241 THEN customer_entity_int.VALUE END )AS DIAS_PREPARACION_VENDEDOR,
MAX(CASE WHEN customer_entity_int.attribute_id=240 THEN customer_entity_int.VALUE END )AS DIAS_TIPO_ENVIO_VENDEDOR,
Y.taxvat,
MAX(CASE WHEN customer_entity_int.attribute_id=242 THEN customer_entity_int.VALUE END )AS TIPO_ENVIO_VENDEDOR

#customer_entity_varchar.value AS NOMBRE,


from 
customer_entity_int


LEFT JOIN 
(
SELECT
entity_id AS ID_SELLER,
firstname AS NOMBRE,
taxvat

FROM 
customer_entity
)AS Y

ON customer_entity_int.entity_id =Y.ID_SELLER 

GROUP BY
ID_SELLER,
Y.NOMBRE,
Y.taxvat
)T1
WHERE 1=1
;




END


CALL UPDATE_SELLERS(6) 


