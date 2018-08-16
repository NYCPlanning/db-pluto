-- export the datasets

\copy (SELECT * FROM pluto) TO '/prod/db-pluto/pluto_build/output/pluto.csv' DELIMITER ',' CSV HEADER;
