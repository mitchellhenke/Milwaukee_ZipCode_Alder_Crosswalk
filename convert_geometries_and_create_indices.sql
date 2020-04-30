ALTER TABLE shapefiles
 ALTER COLUMN geom TYPE geometry(MultiPolygon, 4326)
   USING ST_Transform(geom, 4326);

ALTER TABLE zip_shapes
 ALTER COLUMN geom TYPE geometry(MultiPolygon, 4326)
   USING ST_Transform(geom, 4326);

ALTER TABLE shapefiles ADD COLUMN geom_point geometry(Point,4326);
update shapefiles SET geom_point = ST_Centroid(geom);


CREATE INDEX shapefiles_geom_index on shapefiles using GIST (geom);
CREATE INDEX shapefiles_geom_point_index on shapefiles using GIST (geom_point);

CREATE INDEX assessments_tax_key_index on assessments (tax_key);
CREATE INDEX shapefiles_tax_key_index on assessments (tax_key);
