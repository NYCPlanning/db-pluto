-- create index on pluto and shoreline file
DROP INDEX pluto_gix;
DROP INDEX dof_shoreline_union_gix;
CREATE INDEX pluto_gix ON pluto USING GIST (geom);
CREATE INDEX dof_shoreline_union_gix ON dof_shoreline_union USING GIST (geom);