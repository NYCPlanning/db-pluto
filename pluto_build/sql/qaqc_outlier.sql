-- -v VERSION=$VERSION
DROP TABLE IF EXISTS qaqc_outlier;
CREATE TABLE IF NOT EXISTS qaqc_outlier(
    v character varying,
    outlier character varying
);

INSERT INTO qaqc_outlier (
select :'VERSION' as v, 	    
        jsonb_agg(t) as outlier
from (
	select jsonb_agg(json_build_object('bbl', a.bbl, 'unitsres',a.unitsres, 'resarea', a.resarea,
                              'res_unit_ratio', a.res_unit_ratio)) as values, 'unitsres_resarea' as field
	from (SELECT DISTINCT bbl, unitsres, resarea, resarea::INT/unitsres::INT as res_unit_ratio
          FROM archive_pluto
          WHERE unitsres::INT>50 and resarea::INT/unitsres::INT < 300
          AND resarea::INT != 0) a
	union
	select jsonb_agg(json_build_object('bbl', a.bbl, 'bldgarea',a.bldgarea, 'lotarea', a.lotarea,
                              'numfloors', a.numfloors, 'blog_lot_ratio', a.bldg_lot_ratio)) as values, 'lotarea_numfloor' as field
	from (SELECT bbl, bldgarea, lotarea, numfloors, bldgarea::FLOAT/lotarea::FLOAT as bldg_lot_ratio
          FROM archive_pluto
          WHERE bldgarea::FLOAT/lotarea::FLOAT > numfloors::FLOAT*2
          AND lotarea::FLOAT != 0) a 
    union 
    select jsonb_agg(json_build_object('pair',m.pair, 'bbl', m.bbl,
                                       'building_area_current',m.building_area_current,
                                       'building_area_previous',m.building_area_previous)) as values, 
                                       'building_area_increase' as field
    from (SELECT :'VERSION'||' - '||:'VERSION_PREV' as pair, 
                a.bbl, a.lotarea as building_area_current, b.lotarea as building_area_previous
          FROM archive_pluto a, previous_pluto b
          WHERE a.bbl::FLOAT = b.bbl::FLOAT AND a.lotarea::FLOAT > 2*b.lotarea::FLOAT
          AND b.lotarea::FLOAT != 0 ) m
      )t);