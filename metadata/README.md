# PLUTO METADATA README
## December 2018 (18v2)

### Announcements

The methodology used to create PLUTO has changed with version 18v2. As with previous versions, data is pulled from RPAD and geocoded on the mainframe. All other processing is done in SQL. The code can be viewed at https://github.com/NYCPlanning/db-pluto.

### WHAT IS PLUTO?&trade;

The Primary Land Use Tax Lot Output (PLUTO™) data file contains extensive land use and
geographic data at the tax lot level in a comma-delimited file.
The PLUTO tax lot data files contain over seventy data fields derived from data files maintained
by the Department of City Planning (DCP), Department of Finance (DOF), Department of
Citywide Administrative Services (DCAS), and Landmarks Preservation Commission (LPC).
DCP has created additional fields based on data obtained from one or more of the major data
sources. PLUTO data files contain three basic types of data:
* Tax Lot Characteristics;
* Building Characteristics; and
* Geographic/Political/Administrative Districts.

There are two idiosyncrasies regarding the tax lot data. The PLUTO data contain one record
per tax lot except for condominiums. PLUTO data contain one record per condominium
complex instead of records for each condominium unit tax lot. A tax lot is usually a parcel of
real property. The parcel can be under water, vacant, or contain one or more buildings or
structures. The Department of Finance assigns a tax lot number to each condominium unit and
a billing tax lot number to the Condominium Complex. A Condominium Complex is defined as
one or more structures or properties under the auspices of the same condominium association.
DCP summarizes DOF's condominium unit tax lot data so that each Condominium Complex
within a tax block is represented by only one record. The Condominium Complex record is
assigned the billing tax lot number when one exists. When the billing tax lot number has not
yet been assigned by DOF, the lowest tax lot number within the tax block of the Condominium
Complex is assigned.
The second idiosyncrasy is related to borough and community district geography. Two portions
of the City, Marble Hill and Rikers Island, are legally located in one borough but are serviced by
another borough. Specifically, Marble Hill is legally located in Manhattan but is serviced by The
Bronx, while Rikers Island is legally part of The Bronx but is serviced by Queens. Therefore,
Marble Hill tax lots are located in the Manhattan borough file and Rikers Island tax lots are in
The Bronx borough file. 

Starting in 2019, PLUTO data will be updated four times a year. Check the City Planning web site,
www.nyc.gov/planning for update status. The date of the eight source data files and the base
map used to create PLUTO18v2 are:

### PLUTO 18v2 - DATES OF DATA

|**SOURCE**|**DATE OF DATA**|
|---|---|
|Department of City Planning - Political and Administrative Districts|January 15, 2018|
|Department of Finance - Digital Tax Map|April 5, 2018|
|Department of City Planning - NYC GIS Zoning Features|Oct 26, 2018|
|Department of City Planning - E Designations|May 15, 2018|
|Department of Citywide Administrative Services - City Ownership Code|April 20, 2018|
|Department of Finance - RAPD Master File|May 18, 2018|
|Department of Finance - Mass Appraisal System|May 4, 2018|
|Landmarks Preservation Commission - Historic Districts|April 12, 2018|
|Landmarks Preservation Commission - Landmarks|April 12, 2018|

City Planning also merges the PLUTO data with the DCP modified version of the DOF’s Digital
tax map to create MapPLUTO for use with various geographic information systems. For more
information on MapPLUTO see the DCP web site www.nyc.gov/planning.

**PLUTO is being provided by the Department of City Planning (DCP) on DCP’s website for
informational purposes only. DCP does not warranty the completeness, accuracy,
content, or fitness for any particular purpose or use of PLUTO, nor are any such
warranties to be implied or inferred with respect to PLUTO as furnished on the website.
DCP and the City are not liable for any deficiencies in the completeness, accuracy,
content, or fitness for any particular purpose or use of PLUTO, or applications utilizing
PLUTO, provided by any third party.**

If you have any questions concerning the data, please click on http://www.nyc.gov/open-data-feedback
to submit your questions.

### APPENDIX
### CHANGES IN PLUTO BETWEEN PLUTO 18v1.1 AND PLUTO18v2

#### CHANGE IN METHODOLOGY

The methodology used to create PLUTO has changed with version 18v2. As with previous versions, data is pulled from RPAD and geocoded on the mainframe. All other processing is now done in SQL. The code can be viewed at https://github.com/NYCPlanning/db-pluto. There may be small changes in how a field is calculated, particularly those derived from the Department of Finance's Mass Appraisal System.
***

#### NEW ZONING DISTRICT

M1-4/R9A

***

#### NEW HISTORIC DISTRICT

None

***

#### NEW BUILDING CLASSES

None

***

#### NEW FIELDS

None

***

#### CHANGES TO FIELD DEFINITIONS - See Data Dictionay for more information

Zoning District 1
Zoning District 2
Zoning District 3
Zoning District 4
Commercial Overlay 1
Commercial Overlay 2
Special District 1
Special District 2
Special District 3
Split Zone Indicator

***

#### DELETED FIELDS

None

***
