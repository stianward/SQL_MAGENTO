
CALL UPDATE_SELLERS(6) 
CALL ACTUALIZAR_INFORMACION_VENDEDORES(6,1, 1, 'CC_TOCUMEN', 1);

#DROP PROCEDURE ACTUALIZAR_INFORMACION_VENDEDORES
#DROP PROCEDURE UPDATE_SELLERS

DELIMITER
CREATE PROCEDURE ACTUALIZAR_INFORMACION_VENDEDORES(IN ID INT,DIAS_PREPACION_VENDOR INT, DIAS_TIPO_ENVIO_VENDEDOR INT, TAXVAT VARCHAR(12),TIPO_ENVIO_VENDEDOR INT)

BEGIN
 #DIAS PREPARACION VENDEDOR
 
UPDATE 
customer_entity_int
SET 
customer_entity_int.VALUE=(SELECT VALOR FROM (SELECT  REPLACE(customer_entity_int.VALUE,customer_entity_int.VALUE,DIAS_PREPACION_VENDOR)AS VALOR FROM customer_entity_int WHERE customer_entity_int.attribute_id=241 AND customer_entity_int.entity_id=ID)AS X)
WHERE 
customer_entity_int.entity_id =ID
AND customer_entity_int.attribute_id=241;
 
#DIAS TIPO ENVIO VENDEDOR
 
UPDATE 
customer_entity_int
SET 
customer_entity_int.VALUE=(SELECT VALOR FROM (SELECT  REPLACE(customer_entity_int.VALUE,customer_entity_int.VALUE,DIAS_TIPO_ENVIO_VENDEDOR)AS VALOR FROM customer_entity_int WHERE customer_entity_int.attribute_id=240 AND customer_entity_int.entity_id=ID)AS X)
WHERE 
customer_entity_int.entity_id =ID
AND customer_entity_int.attribute_id=240;

#TIPO ENVIO VENDEDOR

UPDATE 
customer_entity_int
SET 
customer_entity_int.VALUE=(SELECT VALOR FROM (SELECT  REPLACE(customer_entity_int.VALUE,customer_entity_int.VALUE,TIPO_ENVIO_VENDEDOR)AS VALOR FROM customer_entity_int WHERE customer_entity_int.attribute_id=242 AND customer_entity_int.entity_id=ID)AS X)
WHERE 
customer_entity_int.entity_id =ID
AND customer_entity_int.attribute_id=242;

#TAXVAT

UPDATE 
customer_entity
SET taxvat=TAXVAT
WHERE 
customer_entity.entity_id =ID;

#CALL INFORMACION_LOGISTICA_VENDOR(ID);

END
DELIMITER ;

