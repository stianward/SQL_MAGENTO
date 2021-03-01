SELECT  * FROM catalog_product_entity
select * from marketplace_product
SELECT * FROM catalog_product_entity_int where attribute_id =97
SELECT * FROM catalog_product_entity_int where row_id =97 AND attribute_id =97

#ver todos los atributos de un producto
select * from eav_attribute where attribute_code ='status'



SELECT * FROM (
SELECT 
catalog_product_entity_int.row_id AS PRODUCTO_ID_MAGENTO,
catalog_product_entity.sku AS SKU,
catalog_product_entity.created_at AS FECHA_CREACION,
catalog_product_entity.updated_at AS FECHA_ACTUALIZACION,
catalog_product_entity.type_id AS TIPO_PRODUCTO,
IF(MAX(CASE WHEN catalog_product_entity_int.store_id=0 THEN catalog_product_entity_int.value END)=2,"PRODUCTO INACTIVO","PRODUCTO ACTIVO")AS ESTADO_TIENDA_GLOBAL,
IF(MAX(CASE WHEN catalog_product_entity_int.store_id=1 THEN catalog_product_entity_int.value END)=2,"PRODUCTO INACTIVO","PRODUCTO ACTIVO")AS ESTADO_TIENDA_INGLES,
IF(MAX(CASE WHEN catalog_product_entity_int.store_id=2 THEN catalog_product_entity_int.value END)=2,"PRODUCTO INACTIVO","PRODUCTO ACTIVO")AS ESTADO_TIENDA_ESPAÑOL
FROM catalog_product_entity_int 
LEFT JOIN 
catalog_product_entity
ON catalog_product_entity_int.row_id = catalog_product_entity.row_id
WHERE 
catalog_product_entity_int.attribute_id =97
GROUP BY
catalog_product_entity_int.row_id,
catalog_product_entity.sku ,
catalog_product_entity.created_at,
catalog_product_entity.updated_at,
catalog_product_entity.type_id
)T1

WHERE 
T1.SKU LIKE'PHO-111%'
#T1.ESTADO_TIENDA_GLOBAL="PRODUCTO ACTIVO"
#T1.ESTADO_TIENDA_INGLES="PRODUCTO INACTIVO"
#T1.ESTADO_TIENDA_ESPAÑOL="PRODUCTO ACTIVO"




#PRODUCTOS CON CODIGO DE CATEGORIA, PRECIO NETO-PRECIO VENTA-PRECIO CIF
SELECT
	PRODUCTO_ID_MAGENTO,
	SKU,
	FECHA_CREACION,
	FECHA_ACTUALIZACION,
	TIPO_PRODUCTO,
	ESTADO_TIENDA_GLOBAL,
	ESTADO_TIENDA_INGLES,
	ESTADO_TIENDA_ESPAÑOL,
	CATEGORY_ID,
	MAX((SELECT VALUE FROM catalog_product_entity_decimal WHERE attribute_id = 77 AND row_id = PRODUCTO_ID_MAGENTO)) AS PRECIO_VENTA,
	MAX((SELECT VALUE FROM catalog_product_entity_decimal WHERE attribute_id = 367 AND row_id = PRODUCTO_ID_MAGENTO)) AS PRECIO_CIF,
	MAX((SELECT VALUE FROM catalog_product_entity_decimal WHERE attribute_id = 370 AND row_id = PRODUCTO_ID_MAGENTO)) AS PRECIO_NETO,
	CASE
		WHEN (
		SELECT
			VALUE
		FROM
			catalog_product_entity_decimal
		WHERE
			attribute_id = 367
			AND row_id = PRODUCTO_ID_MAGENTO)>= 100 THEN (
		SELECT
			VALUE
		FROM
			catalog_product_entity_decimal
		WHERE
			attribute_id = 77
			AND row_id = PRODUCTO_ID_MAGENTO)-(
		SELECT
			VALUE
		FROM
			catalog_product_entity_decimal
		WHERE
			attribute_id = 367
			AND row_id = PRODUCTO_ID_MAGENTO)
	END AS PRECIO_VNTA_PRECIO_CIF_MAYUSD100,
	CASE
		WHEN (
		SELECT
			VALUE
		FROM
			catalog_product_entity_decimal
		WHERE
			attribute_id = 367
			AND row_id = PRODUCTO_ID_MAGENTO)< 100 THEN (
		SELECT
			VALUE
		FROM
			catalog_product_entity_decimal
		WHERE
			attribute_id = 77
			AND row_id = PRODUCTO_ID_MAGENTO)-(
		SELECT
			VALUE
		FROM
			catalog_product_entity_decimal
		WHERE
			attribute_id = 367
			AND row_id = PRODUCTO_ID_MAGENTO)
	END AS PRECIO_VNTA_PRECIO_CIF_MENUSD100,
	(
		(
		SELECT
			VALUE
		FROM
			catalog_product_entity_decimal
		WHERE
			attribute_id = 367
			AND row_id = PRODUCTO_ID_MAGENTO)-(
		SELECT
			VALUE
		FROM
			catalog_product_entity_decimal
		WHERE
			attribute_id = 370
			AND row_id = PRODUCTO_ID_MAGENTO)
		
		)
		AS PRECIO_CIF_MENOS_PRECIO_NETO
			
	
FROM
	(
	SELECT
		*
	FROM
		(
		SELECT
			*
		FROM
			(
			SELECT
				catalog_product_entity_int.row_id AS PRODUCTO_ID_MAGENTO ,
				catalog_product_entity.sku AS SKU,
				catalog_product_entity.created_at AS FECHA_CREACION,
				catalog_product_entity.updated_at AS FECHA_ACTUALIZACION,
				catalog_product_entity.type_id AS TIPO_PRODUCTO,
				IF(MAX(CASE WHEN catalog_product_entity_int.store_id = 0 THEN catalog_product_entity_int.value END)= 2,
				"PRODUCTO INACTIVO",
				"PRODUCTO ACTIVO")AS ESTADO_TIENDA_GLOBAL,
				IF(MAX(CASE WHEN catalog_product_entity_int.store_id = 1 THEN catalog_product_entity_int.value END)= 2,
				"PRODUCTO INACTIVO",
				"PRODUCTO ACTIVO")AS ESTADO_TIENDA_INGLES,
				IF(MAX(CASE WHEN catalog_product_entity_int.store_id = 2 THEN catalog_product_entity_int.value END)= 2,
				"PRODUCTO INACTIVO",
				"PRODUCTO ACTIVO")AS ESTADO_TIENDA_ESPAÑOL
			FROM
				catalog_product_entity_int
			LEFT JOIN catalog_product_entity ON
				catalog_product_entity_int.row_id = catalog_product_entity.row_id
			WHERE
				catalog_product_entity_int.attribute_id = 97
			GROUP BY
				catalog_product_entity_int.row_id,
				catalog_product_entity.sku ,
				catalog_product_entity.created_at,
				catalog_product_entity.updated_at,
				catalog_product_entity.type_id )T1
		LEFT JOIN catalog_category_product ON
			catalog_category_product.product_id = T1.PRODUCTO_ID_MAGENTO )AS TG
	LEFT JOIN catalog_product_entity_decimal ON
		TG.PRODUCTO_ID_MAGENTO = catalog_product_entity_decimal.row_id )X
WHERE
	X.SKU LIKE 'PHO-111-%'
	AND attribute_id = 77
	AND X.TIPO_PRODUCTO = 'simple'
	#AND X.ESTADO_TIENDA_GLOBAL <>'PRODUCTO INACTIVO'
	#AND X.ESTADO_TIENDA_INGLES<>'PRODUCTO INACTIVO'
	#AND X.ESTADO_TIENDA_ESPAÑOL<>'PRODUCTO INACTIVO'
GROUP BY
	PRODUCTO_ID_MAGENTO,
	SKU,
	FECHA_CREACION,
	FECHA_ACTUALIZACION,
	TIPO_PRODUCTO,
	ESTADO_TIENDA_GLOBAL,
	ESTADO_TIENDA_INGLES,
	ESTADO_TIENDA_ESPAÑOL,
	CATEGORY_ID ;
