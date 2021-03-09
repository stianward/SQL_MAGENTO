#ACTUALIZACION DE PICKUP COUTRIES
select  *from eav_attribute ea where attribute_code='pickup_countries';
UPDATE customer_entity_varchar SET VALUE=REPLACE (REPLACE(UPPER (VALUE),'PANAMÁ','PA'),'PANAMA','PA')  where attribute_id=307;



