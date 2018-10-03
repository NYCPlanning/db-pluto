-- manually set the version of PLUTO and the versions of the source datasets
UPDATE pluto 
SET version = 'b18v2',
	rpaddate = '09/28/2018',
	dcasdate = '09/24/2018',
	zoningdate = '09/21/18',
	landmkdate = '09/24/2018',
	basempdate = '09/24/2018',
	edesigdate = '09/24/2018',
	tract2010 = ct2010;