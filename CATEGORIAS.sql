
#all categories=412
select * from information_schema.TABLES where TABLE_NAME like '%categor%';
select * from eav_attribute where attribute_id in(45,52,124,125)   
select * from eav_attribute WHERE attribute_id=364
select * from catalog_category_entity where parent_id =1148;
SELECT * FROM catalog_category_entity_decimal WHERE row_id =754

#productos X ID categoria
select * from catalog_category_product where category_id =735 AND attribute_id=4

select  *from catalog_category_entity_int where attribute_id=4

select * from catalog_category_entity_varchar where attribute_id IN(124,125,52,45) AND store_id =2 order by value
select * from catalog_category_entity_varchar where row_id=1154
select * from catalog_category_entity_varchar where value ='all-categories/computing/print'
select * from catalog_category_entity_varchar where store_id =1 and attribute_id =45

#query categorias

SELECT
	NOMBRE_CATEGORIA_PADRE,
	CODIGO_CATEGORIA_PADRE,
	CODIGO_CATEGORIA_HIJA,
	NOMBRE_CATEGORIA_HIJA,
	value AS PORCENTAJE_HIJA
	#MAX(CASE WHEN catalog_category_entity_decimal.store_id =0 THEN value END) AS PORCENTAJE_TIENDA_HIJA_INGLES,
	#MAX(CASE WHEN catalog_category_entity_decimal.store_id =1 THEN value END) AS PORCENTAJE_TIENDA_HIJA_ESPAÑOL
FROM
	(
	SELECT
		*
	FROM
		(
		select
			catalog_category_entity_varchar.value AS NOMBRE_CATEGORIA_PADRE,
			catalog_category_entity.parent_id AS CODIGO_CATEGORIA_PADRE,
			catalog_category_entity.row_id AS CODIGO_CATEGORIA_HIJA,
			
			(
			SELECT
				catalog_category_entity_varchar.value
			FROM
				catalog_category_entity_varchar
			WHERE
				catalog_category_entity_varchar.row_id = catalog_category_entity.row_id
				AND catalog_category_entity_varchar.attribute_id = 45
				AND catalog_category_entity_varchar.store_id = 0)AS NOMBRE_CATEGORIA_HIJA
		FROM
			catalog_category_entity_varchar
		LEFT JOIN catalog_category_entity ON
			catalog_category_entity_varchar.row_id = catalog_category_entity.parent_id
			AND catalog_category_entity_varchar.attribute_id = 45
			AND catalog_category_entity_varchar.store_id = 0
			AND catalog_category_entity_varchar.value <> 'All Categories'
			AND catalog_category_entity_varchar.value <> 'Root Catalog' )AS T1
	LEFT JOIN catalog_category_entity_decimal ON
		T1.CODIGO_CATEGORIA_HIJA = catalog_category_entity_decimal.row_id )AS T2


GROUP BY

NOMBRE_CATEGORIA_PADRE,
CODIGO_CATEGORIA_PADRE,
CODIGO_CATEGORIA_HIJA,
NOMBRE_CATEGORIA_HIJA
HAVING 1=1







SELECT * FROM catalog_category_entity_decimal WHERE row_id =754
WHERE attribute_id=364

store_id=0 and row_id=4