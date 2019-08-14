DROP TABLE IF EXISTS pluto_corr_ownername_temp;
CREATE TABLE pluto_corr_ownername_temp AS (
SELECT bbl, ownername, ownername as newownername FROM pluto WHERE ownertype = 'C');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'NEW YORK CITY', 'NYC');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'CITY OF NEW YORK', 'NYC');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'CITY OF NY', 'NYC');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'C N Y', 'NYC');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'DEPT', 'DEPARTMENT');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'DPT', 'DEPARTMENT');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'DPT', 'DEPARTMENT');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'ACS', 'ADMINISTRATION FOR CHILDRENS SERVICES');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'DCAS', 'DEPARTMENT OF CITYWIDE ADMINISTRATIVE SERVICES');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'DDC', 'DEPARTMENT OF DESIGN AND CONSTRUCTION');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'DEP', 'DEPARTMENT OF ENVIRONMENTAL PROTECTION')
WHERE newownername = 'DEP'
	OR newownername = 'NYC DEP';

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'DHS', 'DEPARTMENT OF HOMELESS SERVICES');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'DOITT', 'DEPARTMENT OF INFORMATION TECHNOLOGY AND TELECOMMUNICATIONS');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'DOT', 'DEPARTMENT OF TRANSPORTATION');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'DSBS', 'DEPARTMENT OF SMALL BUSINESS SERVICES');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'EDC', 'ECONOMIC DEVELOPMENT CORPORATION');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'HHC', 'HEALTH AND HOSPITALS CORPORATION');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'HPD', 'DEPARTMENT OF HOUSING PRESERVATION AND DEVELOPMENT');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'HRA', 'HUMAN RESOURCES ADMINISTRATION');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'OCME', 'OFFICE OF CHIEF MEDICAL EXAMINER');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'LIBRA', 'LIBRARY')
WHERE newownername LIKE '%LIBRA';

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'SERVIC', 'SERVICES')
WHERE newownername LIKE '%SERVIC';

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'DEPARTMENTOF', 'DEPARTMENT OF')
WHERE newownername LIKE '%DEPARTMENTOF%';

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'DEV ', 'DEVELOPMENT ');
WHERE newownername LIKE '% DEV %';

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'CORP', 'CORPORATION')
WHERE newownername LIKE '%CORP';

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'AUTH', 'AUTHORITY');
WHERE newownername LIKE '%AUTH';

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,' & ', ' AND ');

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'&', ' AND ');


UPDATE pluto_corr_ownername_temp
SET newownername = 'NYC TRANSIT AUTHORITY'
WHERE newownername = 'NYCT'
	OR newownername = 'NYCTA'
	OR newownername LIKE 'NYC TRANSIT%';

UPDATE pluto_corr_ownername_temp
SET newownername = 'NYC DEPARTMENT OF PARKS AND RECREATION'
WHERE newownername LIKE '%PARKS AND RECREATION%'
	OR newownername LIKE '%PARKS%DEPARTMENT%'
	OR newownername LIKE '%DEPARTMENT%PARKS%'
	OR newownername LIKE '%PARKS%ARSENAL%'
	OR newownername LIKE 'NYC%PARKS%';

UPDATE pluto_corr_ownername_temp
SET newownername = 'NYC HOUSING PRESERVATION AND DEVELOPMENT'
WHERE newownername LIKE '%HOUS%PRES%DEVELOP%';

UPDATE pluto_corr_ownername_temp
SET newownername = 'NYC ECONOMIC DEVELOPMENT CORPORATION'
WHERE newownername LIKE '%NYC%ECONOMIC%DEVELOPMENT%';

UPDATE pluto_corr_ownername_temp
SET newownername = 'NYC DEPARTMENT OF EDUCATION'
WHERE newownername LIKE 'NYC%EDUCATION%';

UPDATE pluto_corr_ownername_temp
SET newownername = 'NYC DEPARTMENT OF ENVIRONMENTAL PROTECTION'
WHERE newownername LIKE 'NYC%ENVIRON%PROT%';

UPDATE pluto_corr_ownername_temp
SET newownername = 'NYC POLICE DEPARTMENT'
WHERE newownername LIKE 'NYPD%';

UPDATE pluto_corr_ownername_temp
SET newownername = 'NYC FIRE DEPARTMENT'
WHERE newownername LIKE 'FDNY%';

UPDATE pluto_corr_ownername_temp
SET newownername = 'NYC DEPARTMENT OF CULTURAL AFFAIRS'
WHERE newownername LIKE 'CULTURAL%';

UPDATE pluto_corr_ownername_temp
SET newownername = 'NYC DEPARTMENT OF SANITATION'
WHERE newownername LIKE '%SANITATION%';

UPDATE pluto_corr_ownername_temp
SET newownername = 'PORT AUTHORITY NY AND NJ'
WHERE newownername LIKE '%PORT%AUTH%';

UPDATE pluto_corr_ownername_temp
SET newownername = 'NYC TAXI AND LIMOUSINE COMMISSION'
WHERE newownername LIKE '%TAXI%LIMO%';

UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'(', '');
UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,')', '');
UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,'.', '');
UPDATE pluto_corr_ownername_temp
SET newownername = replace(newownername,',', '');

UPDATE pluto_corr_ownername_temp
SET newownername = concat('NYC ',newownername)
WHERE newownername LIKE 'DEPARTMENT%'
	OR newownername LIKE 'ADMINISTRATION%'
	OR newownername LIKE 'ECONOMIC%'
	OR newownername LIKE 'FIRE%'
	OR newownername LIKE 'HEALTH%'
	OR newownername LIKE 'HOUSING P%'
	OR newownername LIKE 'HUMAN%'
	OR newownername LIKE 'POLICE%'
	;



SELECT COUNT(*), newownername FROM pluto_corr_ownername_temp GROUP BY newownername ORDER BY newownername; 


SELECT COUNT(*), ownername, newownername FROM pluto_corr_ownername_temp GROUP BY ownername, newownername ORDER BY newownername; 





