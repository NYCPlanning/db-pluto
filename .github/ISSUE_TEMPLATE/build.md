---
name: Build
about: This is a build issue for PLUTO that tracks dataloading, pluto improvements
  and additional info
title: "[build] version: {e.g. Major: 20v4, Minor: 22v3.1}"
labels: 'data: ingestion'
assignees:

---

# Update version name

# PLUTO now uses version numbering YYvMAJOR.MINOR
1. YY for the last two digits of the release year
2. MAJOR version for using the latest versions of all input data
2. MINOR version for using the latest versions of particular input data

### Major Release: To initiate a major release, you must change the VERSION and VERSION_PREV. All other variables can remain unchanged and will default to latest in the dataloading step. 

- [ ] <https://github.com/NYCPlanning/db-pluto/blob/main/pluto_build/version.env>

### Minor Release: To initiate a minor release, you must change the VERSION and VERSION_PREV. In addition, you are required to hold the following variables constant with the last major release of PLUTO (you can reference the `source_data_version` table). This requires you to pay close attention to the previous Major build of PLUTO's source data versions and apply the correct dates to the associated variable names (you might also have to create new variable names if source data becomes out of sync):

- [ ] <https://github.com/NYCPlanning/db-pluto/blob/main/pluto_build/version.env>

- [ ] DOF_WEEKLY_DATA_VERSION
- [ ] DOF_CAMA_DATA_VERSION

- [ ] GEOSUPPORT_VERSION
- [ ] FEMA_FIRPS_VERSION
- [ ] DOITT_DATA_VERSION
- [ ] DOF_DATA_VERSION

- [ ] DCP_COLP_VERSION
- [ ] DPR_GREENTHUMB_VERSION
- [ ] DSNY_FREQUENCIES_VERSION
- [ ] LPC_HISTORIC_DISTRICTS_VERSION
- [ ] LPC_LANDMARKS_VESRSION

- [ ] PLUTO_CORRECTIONS_VERSION
# Data loading

### Manual Updates

#### Updated 2x a year typically in June and December
- [ ] **dcp_colp** (check [here](https://www1.nyc.gov/site/planning/data-maps/open-data/dwn-colp.page)) 
#### Currently updated with each new release of a major version of PLUTO - important to make sure this is up to date
- [ ] **pluto_corrections** (pulling from bytes, must update when there's updates to **pluto_input_research**)

### Automated Updates

#### Open data automated pull

> Check [here](https://github.com/NYCPlanning/db-data-library/actions/workflows/open-data.yml) to see the latest run

- [ ] **dsny_frequencies**
- [ ] **dpr_greenthumb**
- [ ] **lpc_historic_districts**
- [ ] **lpc_landmarks**

#### DOF Automated Pull and Number of Buildings

- [ ] **pluto_pts** (Check [here](https://github.com/NYCPlanning/db-pluto/actions/workflows/input_pts.yml))
- [ ] **pluto_input_geocodes** (Check [here](https://github.com/NYCPlanning/db-pluto/actions/workflows/input_pts.yml))
- [ ] **pluto_input_cama_dof** (Check [here](https://github.com/NYCPlanning/db-pluto/actions/workflows/input_cama.yml))
- [ ] **pluto_input_numbldgs** (Check [here](https://github.com/NYCPlanning/db-pluto/actions/workflows/input_numbldgs.yml))

### Updated with Quarterly updates (check [here](https://github.com/NYCPlanning/db-data-library/actions/workflows/quaterly-updates.yml))

- [ ] **dcp_cdboundaries_wi**
- [ ] **dcp_ct2010**
- [ ] **dcp_cb2010**
- [ ] **dcp_ct2020**
- [ ] **dcp_cb2020**
- [ ] **dcp_school_districts**  
- [ ] **dcp_councildistricts_wi**  
- [ ] **dcp_firecompanies**  
- [ ] **dcp_policeprecincts**
- [ ] **dcp_healthareas**  
- [ ] **dcp_healthcenters**

### Updated with Zoning Taxlots (check [here](https://github.com/NYCPlanning/db-zoningtaxlots/actions/workflows/dataloading.yml) for latest run). 

- [ ] **dof_dtm**
- [ ] **dof_shoreline**
- [ ] **dof_condo**

For a Minor release of PLUTO, the following datasets will need to be updated to use the latest versions available in DigitalOcean (essentially, a PLUTO Minor version's only difference between a PLUTO Major release are these datasets):

- [ ] **dcp_commercialoverlay**
- [ ] **dcp_limitedheight**
- [ ] **dcp_zoningdistricts**
- [ ] **dcp_specialpurpose**
- [ ] **dcp_specialpurposesubdistricts**
- [ ] **dcp_zoningmapamendments**
- [ ] **dcp_edesignation**

### Never Updated (Safe to ignore)

- [ ] **doitt_zipcodeboundaries** (almost never updated, check [here](https://data.cityofnewyork.us/Business/Zip-Code-Boundaries/i8iw-xf4u))
- [ ] **fema_firms2007_100yr**
- [ ] **fema_pfirms2015_100yr**
- [ ] **dcp_zoningmapindex**

### Update QAQC App 

~~- [ ] **update data-engineering-qaqc version_comparison_report in src/pluto/pluto.py with version of pluto build** (must be updated with every version of pluto [here] (https://github.com/NYCPlanning/data-engineering-qaqc/blob/main/src/pluto/pluto.py))~~

# PLUTO Improvements (corrections)

# Build CI Runs

- **[INSERPT LINKS TO RELEVANT CI RUNS HERE]**
 
# Comments

