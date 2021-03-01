SELECT
	ID_ATRIBUTO,
	RUTA_CATEGORIA_PADRE,
	NOMBRE_CATEGORIA_PADRE,
	CODIGO_CATEGORIA_PADRE,
	CODIGO_CATEGORIA_HIJA,
	NOMBRE_CATEGORIA_HIJA,
	REPLACE(REPLACE(TRIM(CONCAT("Categories/", RUTA_CATEGORIA_PADRE, "/", NOMBRE_CATEGORIA_HIJA)),
	"-",
	" "),
	"clothes and accessories",
	"Fashion and accessories") AS RUTA_HIJA,
	IFNULL(MAX(CASE WHEN STORE_ID = 0 THEN VALUE END), "SIN VALOR") AS PORC_TIENDA_HIJA_INGLES,
	IFNULL(MAX( CASE WHEN STORE_ID = 1 THEN VALUE END), "SIN VALOR") AS ´PORC_TIENDA_HIJA_ESPAÑOL,
	IFNULL(MAX(CASE WHEN STORE_ID = 2 THEN VALUE END), "SIN VALOR") AS PORC_TIENDA_HIJA_2,
	IFNULL(MAX((SELECT VALUE FROM catalog_category_entity_decimal WHERE ROW_ID = CODIGO_CATEGORIA_PADRE AND STORE_ID = 0)), "SIN VALOR") AS PORC_TIENDA_PADRE_INGLES,
	IFNULL(MAX((SELECT VALUE FROM catalog_category_entity_decimal WHERE ROW_ID = CODIGO_CATEGORIA_PADRE AND STORE_ID = 1)), "SIN VALOR") AS PORC_TIENDA_PADRE_ESPAÑOL,
	IFNULL(MAX((SELECT VALUE FROM catalog_category_entity_decimal WHERE ROW_ID = CODIGO_CATEGORIA_PADRE AND STORE_ID = 2)), "SIN VALOR") AS PORC_TIENDA_PADRE_2
FROM
	(
	SELECT
		*
	FROM
		#TABLA X1
(
		SELECT
			*
		FROM
			(
			select
				catalog_category_entity_varchar.attribute_id AS ID_ATRIBUTO,
				IFNULL(IFNULL( (SELECT catalog_category_entity_varchar.value FROM catalog_category_entity_varchar WHERE store_id = 2 AND attribute_id = 125 and row_id = catalog_category_entity.parent_id), (SELECT catalog_category_entity_varchar.value FROM catalog_category_entity_varchar WHERE store_id = 1 AND attribute_id = 125 and row_id = catalog_category_entity.parent_id) ), "CREADA EN LA RAIZ") AS RUTA_CATEGORIA_PADRE,
				catalog_category_entity_varchar.value AS NOMBRE_CATEGORIA_PADRE,
				catalog_category_entity.parent_id AS CODIGO_CATEGORIA_PADRE,
				catalog_category_entity.row_id AS CODIGO_CATEGORIA_HIJA,
				catalog_category_entity_varchar.store_id AS TIENDA,
				(
				SELECT
					catalog_category_entity_varchar.value
				FROM
					catalog_category_entity_varchar
				WHERE
					catalog_category_entity_varchar.row_id = catalog_category_entity.row_id
					AND catalog_category_entity_varchar.attribute_id = 45
					AND catalog_category_entity_varchar.store_id = 0 ) AS NOMBRE_CATEGORIA_HIJA
			FROM
				catalog_category_entity_varchar
			LEFT JOIN catalog_category_entity ON
				catalog_category_entity_varchar.row_id = catalog_category_entity.parent_id)X
		WHERE
			X.ID_ATRIBUTO = 45
			AND X.TIENDA = 0
			AND X.CODIGO_CATEGORIA_PADRE <> ' '
			AND X.NOMBRE_CATEGORIA_PADRE NOT IN('Root Catalog',
			'Categorías',
			'All Categories') )AS X1
	LEFT JOIN catalog_category_entity_decimal ON
		X1.CODIGO_CATEGORIA_HIJA = catalog_category_entity_decimal.row_id )AS TC
GROUP BY
	ID_ATRIBUTO,
	RUTA_CATEGORIA_PADRE,
	NOMBRE_CATEGORIA_PADRE,
	CODIGO_CATEGORIA_PADRE,
	CODIGO_CATEGORIA_HIJA,
	NOMBRE_CATEGORIA_HIJA
HAVING
	1 = 1;
