# Milwaukee_ZipCode_Alder_Crosswalk

## Requirements

Postgres with PostGIS (including command line utilities `psql` and `shp2pgsql`), Ruby

`wget` is used for downloading files, but files could be downloaded manually and moved to the folder


### MPROP Data

download MPROP data (https://data.milwaukee.gov/dataset/mprop)

```sh
wget https://data.milwaukee.gov/dataset/562ab824-48a5-42cd-b714-87e205e489ba/resource/0a2c7f31-cd15-4151-8222-09dd57d5f16d/download/mprop.csv
```

(optional) convert line endings from DOS

```sh
tr "\r" "\n" < mprop.csv > converted.csv
```

select only tax_key, year, land_use_general, land_use, number_of_bedrooms from CSV

```sh
ruby -rcsv -e 'CSV.foreach(ARGV.shift) {|row| puts "#{row[0]},#{row[2]},#{row[60]},#{row[68]},#{row[69]},#{row[79]}"}' converted.csv > less_columns.csv
```

create assessments table

```sh
createdb properties
```

import assessments CSV into Postgres

```sh
psql -d properties -f assessments.sql
```

### Parcel Shapefiles

parcel outlines (https://data.milwaukee.gov/dataset/parcel-outlines/resource/83503103-1049-4bc6-851f-2597d9cf580e)

```sh
wget https://data.milwaukee.gov/dataset/3e238aee-5a21-4e2f-8ae7-803440c5d88a/resource/83503103-1049-4bc6-851f-2597d9cf580e/download/parcelpolygontax.zip
```

unzip parcel shapefiles

```sh
unzip parcelpolygontax.zip
```

generate SQL to import parcel shapefiles

```sh
shp2pgsql -s 32054 ./ParcelPolygonTax.shp  shapefiles > parcel.sql
```

import parcel shapefiles

```sh
psql -d properties -f parcel.sql
```

### Zip Codes

download Census ZIP Code Tabulation Area Shapes

https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html

```sh
wget https://www2.census.gov/geo/tiger/GENZ2018/shp/cb_2018_us_zcta510_500k.zip
```

generate SQL to import zip code shapefiles

```sh
shp2pgsql -s 4269 cb_2018_us_zcta510_500k.shp zip_shapes > zips.sql
```

import zip code shapefiles

```sh
psql -d properties -f zips.sql
```

```sh
psql -d properties -f convert_geometries_and_create_indices.sql
```

# build and save crosswalk CSV

```sh
psql -d properties -f crosswalks.sql
```
