# PLUTO METADATA README
## November 2018 (18v1.1)

### Announcements

Version 18v1.1 is not a full PLUTO update. Fields related to zoning have been updated to
incorporate all rezonings through 10/26/18. The methodology used to assign zoning to a tax lot
has also changed. Please see the Appendix for a list of all fields that have been updated, as
well as for details on the methodology used.
In addition, version 18v1.1 corrects the Land Use for Building Class C7 from 2 (Multi-Family
Walk-Up Buildings) to 4 (Mixed Residential & Commercial Buildings).

### WHAT IS PLUTO?&trade;

The Primary Land Use Tax Lot Output (PLUTO™) data file contains extensive land use and
geographic data at the tax lot level in ASCII comma-delimited borough files. Each file contains
the tax lots within the borough.
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
a "billing" tax lot number to the Condominium Complex. A Condominium Complex is defined as
one or more structures or properties under the auspices of the same condominium association.
DCP summarizes DOF's condominium unit tax lot data so that each Condominium Complex
within a tax block is represented by only one record. The Condominium Complex record is
assigned the "billing" tax lot number when one exists. When the "billing" tax lot number has not
yet been assigned by DOF, the lowest tax lot number within the tax block of the Condominium
Complex is assigned.
The second idiosyncrasy is related to borough and community district geography. Two portions
of the City, Marble Hill and Rikers Island, are legally located in one borough but are serviced by
another borough. Specifically, Marble Hill is legally located in Manhattan but is serviced by The
Bronx, while Rikers Island is legally part of The Bronx but is serviced by Queens. Therefore,
Marble Hill tax lots are located in the Manhattan borough file and Rikers Island tax lots are in
The Bronx borough file. 

The PLUTO data is usually updated twice a year. Check the City Planning web site,
www.nyc.gov/planning for update status. The date of the eight source data files and the base
map used to create PLUTO18v1.1 are:

### PLUTO 18v1.1 - DATES OF DATA

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
### CHANGES IN PLUTO BETWEEN PLUTO 18v1 AND PLUTO18v1.1

#### CHANGE IN METHODOLOGY FOR ZONING FIELDS

To update zoning fields in previous versions of PLUTO, City Planning maintained a dataset with
the zoning characteristics of each lot. This was updated for every rezoning, as well as for lot
changes resulting from merger, apportionment, or condo conversion. This was a labor-intensive
process and sometimes resulted in lots with zoning that did not agree with the underlying zoning
districts.
The new methodology programmatically determines the zoning designations using the NYC GIS
Zoning Features available on BYTES of the BIG APPLE™. A zoning district is assigned to a tax
lot if it covers at least 10% of the lot’s area. A commercial overlay is assigned to a tax lot if it
covers at least 10% of the lot’s area OR at least 50% of the commercial overlay district is
contained within the lot. See the data dictionary for additional information.
Previously, a variety of sources were used to identify parkland. Starting with PLUTO18v1.1,
NYC GIS Zoning Features are the data source used for identifying parkland and tax lots that
intersect with areas designated in NYC GIS Zoning Features as PARK, BALL FIELD,
PLAYGROUND, and PUBLIC SPACES have been assigned a single value of PARK. No other
parkland datasets are incorporated. The NYC GIS Zoning Features do not constitute a definitive
list of parks in the city. Lots designated as PARK should not be used to calculate the amount of
open space in an area.
The abbreviations used to designate special districts have been changed to agree with those in
NYC GIS Zoning Features. Special districts “CR1” and “CR2” are combined into “CR”. In the
area of Manhattan covered by both the Special 125th Street District and the Special Transit
District, previous versions of PLUTO set Special District 1 equal to “125” and Special District 2
equal to “TA”. The special district for these areas is now designated as “125th/TA”. In the area
of Brooklyn covered by both the Special Enhanced Commercial District 5 or 6 and Mixed Use
District MX-16), previous versions set Special District 1 equal to “EC-5” or “EC-6” and Special
District 2 equal to “MX-16”. These areas are now designated as “MX-16/EC-5” or “MX-16/EC-6”.
See the table below for a list of changes to special district abbreviations.

#### FIELDS UPDATED FOR ZONING ONLY UPDATE

|**Field Name**|**Field Description**|
|---|---|
|ZoneDist1|Zoning District 1|
|ZoneDist2|Zoning District 2|
|ZoneDist3|Zoning District 3|
|ZoneDist4|Zoning District 4|
|Overlay1|Commercial Overlay 1|
|Overlay2|Commercial Overlay 2|
|SPDist1|Special Purpose District 1|
|SPDist2|Special Purpose District 2|
|SPDist3|Special Purpose District 3|
|LtdHeight|Limited Height District|
|SplitZone|Split Boundary Indicator|
|ResidFAR|Maximum Allowable Residential FAR|
|CommFAR|Maximum Allowable Commercial FAR|
|FacilFAR|Maximum Allowable Community Facility FAR|
|ZoneMap|Zoning Map #|
|ZMCode|Zoning Map Code|

***

#### CHANGES TO SPECIAL DISTRICT ABBREVIATIONS

|**18v1**|**18v1.1**|**Description**|
|---|---|---|
|125|125th|Special 125th Street District|
| |125th/TA|Special 125th Street Dist/Transit Land use Dist|
|CR-1|CR|Special Coastal Risk District|
|CR-2|CR|Special Coastal Risk District|
| |EHC|East Harlem Corridors|
| |EHC/TA|East Harlem Corridors/Transit Land Use District|
| |IN|Special Inwood District|
|MID|MiD|Special Midtown District|
| |MX-16/EC-5|Mixed Use District/Enhanced Commercial District 5|
| |MX-16/EC-6|Mixed Use District/Enhanced Commercial District 6|
|WCH|WCh|Special West Chelsea District|

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
