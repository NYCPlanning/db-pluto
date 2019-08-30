-- create index on pluto and shoreline file
DROP INDEX IF EXISTS pluto_gix;
DROP INDEX IF EXISTS dof_shoreline_union_gix;
-- DROP INDEX dcp_zoningdistricts_gix;
CREATE INDEX pluto_gix ON pluto USING GIST (geom);
CREATE INDEX dof_shoreline_union_gix ON dof_shoreline_union USING GIST (geom);
-- CREATE INDEX dcp_zoningdistricts_gix ON dcp_zoningdistricts USING GIST (geom);