CREATE VIEW crosswalks AS (WITH total AS (
    SELECT z.zcta5ce10 as name, sum(greatest(a.number_of_bedrooms, 1)) AS totalamount
    FROM assessments a
    join shapefiles s on s.taxkey = a.tax_key
    join zip_shapes z on ST_Contains(z.geom, s.geom_point)
    where a.year = 2020 and a.number_of_bedrooms >= 0 and a.land_use_general::integer BETWEEN 1 AND 4
    GROUP BY z.zcta5ce10
    UNION
    SELECT a.geo_alder as name, sum(greatest(a.number_of_bedrooms, 1)) AS totalamount
    FROM assessments a
    where a.year = 2020 and a.number_of_bedrooms >= 0 and a.land_use_general::integer BETWEEN 1 AND 4
    GROUP BY a.geo_alder
)
select z.zcta5ce10 as zip_code, a.geo_alder as alder_district, sum(greatest(a.number_of_bedrooms, 1)) as bedrooms, round((sum(greatest(a.number_of_bedrooms, 1))::float / max(zip_total.totalamount))::numeric, 6) as pct_of_zip,
round((sum(greatest(a.number_of_bedrooms, 1))::float / max(ald_total.totalamount))::numeric, 6) as pct_of_alder from assessments a
inner join shapefiles s on s.taxkey = a.tax_key
inner join zip_shapes z on ST_Contains(z.geom, s.geom_point)
inner join total zip_total on zip_total.name = z.zcta5ce10
inner join total ald_total on ald_total.name = a.geo_alder
where a.year = 2020 and a.number_of_bedrooms >= 0 and a.land_use_general::integer BETWEEN 1 AND 4 group by z.zcta5ce10, a.geo_alder order by z.zcta5ce10, a.geo_alder
);

\copy (SELECT * FROM crosswalks) TO 'crosswalks.csv' WITH DELIMITER ',' CSV HEADER;
