-- -v VERSION=$VERSION
DELETE FROM dcp_pluto.qaqc_expected
WHERE v = :'VERSION';

INSERT INTO dcp_pluto.qaqc_expected (
select :'VERSION' as v, jsonb_agg(t) as expected
from (
	select jsonb_agg(zonedist1) as values, 'zonedist1' as field
	from (select distinct zonedist1 from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(zonedist2) as values, 'zonedist2' as field
	from (select distinct zonedist2 from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(zonedist3) as values, 'zonedist3' as field
	from (select distinct zonedist3 from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(zonedist4) as values, 'zonedist4' as field
	from (select distinct zonedist4 from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(overlay1) as values, 'overlay1' as field
	from (select distinct overlay1 from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(overlay2) as values, 'overlay2' as field
	from (select distinct overlay2 from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(spdist1) as values, 'spdist1' as field
	from (select distinct spdist1 from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(spdist2) as values, 'spdist2' as field
	from (select distinct spdist2 from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(spdist3) as values, 'spdist3' as field
	from (select distinct spdist3 from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(ext) as values, 'ext' as field
	from (select distinct ext from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(proxcode) as values, 'proxcode' as field
	from (select distinct proxcode from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(irrlotcode) as values, 'irrlotcode' as field
	from (select distinct irrlotcode from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(lottype) as values, 'lottype' as field
	from (select distinct lottype from dcp_pluto.:"VERSION") a
	union
	select jsonb_agg(bsmtcode) as values, 'bsmtcode' as field
	from (select distinct bsmtcode from dcp_pluto.:"VERSION") a
	union 
	select jsonb_agg(bldgclasslanduse) as values, 'bldgclasslanduse' as field
	from (select distinct bldgclass||'/'||landuse as bldgclasslanduse  from dcp_pluto.:"VERSION") a) t);
