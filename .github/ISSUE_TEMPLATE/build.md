---
name: Build
about: This is a build issue for PLUTO that tracks dataloading, pluto improvements
  and additional info
title: "[build] version: {e.g. 20v4}"
labels: ''
assignees: mgraber, SPTKL

---
# Update version name
- [ ] https://github.com/NYCPlanning/db-pluto/blob/master/pluto_build/version.env

# Data loading
- [ ] **dcp_edesignation** (updated with zoning features)
- [ ] **dcas_facilities_colp** (updated twice a year)
- [ ] **lpc_historic_districts** (check date [here](https://data.cityofnewyork.us/Housing-Development/LPC-Individual-Landmark-and-Historic-District-Buil/7mgd-s57w))
- [ ] **lpc_landmarks** (check date [here](https://data.cityofnewyork.us/Housing-Development/Designated-and-Calendared-Buildings-and-Sites-Map-/jcj6-zji6)
> for spatial joins. Check [Bytes](https://www1.nyc.gov/site/planning/data-maps/open-data/districts-download-metadata.page) for the spatial boundaries
- [ ] **dcp_cdboundaries** (updated quaterly, 19d, 20a e.g.)
- [ ] **dcp_censustracts** (updated quaterly, 19d, 20a e.g.)
- [ ] **dcp_censusblocks** (updated quaterly, 19d, 20a e.g.)
- [ ] **dcp_school_districts**  (updated quaterly, 19d, 20a e.g.)
- [ ] **dcp_councildistricts**  (updated quaterly, 19d, 20a e.g.)
- [ ] **doitt_zipcodeboundaries** (almost never updated, check [here](https://data.cityofnewyork.us/Business/Zip-Code-Boundaries/i8iw-xf4u))
- [ ] **dcp_firecompanies**  (updated quaterly, 19d, 20a e.g.)
- [ ] **dcp_policeprecincts**  (updated quaterly, 19d, 20a e.g.)
- [ ] **dcp_healthareas**  (updated quaterly, 19d, 20a e.g.)
- [ ] **dcp_healthcenters**  (updated quaterly, 19d, 20a e.g.)
- [ ] **dsny_frequencies** (**frequent** updates, check [here](https://data.cityofnewyork.us/City-Government/DSNY-Frequencies/gyhq-r8du))
- [ ] **dpr_greenthumb** (check [here](https://data.cityofnewyork.us/dataset/Greenthumb-Garden-Info/p78i-pat6/data))
> other_datasets 
- [ ] **dof_dtm** (updated when generating Zoning tax lots, ignore)
- [ ] **dof_shoreline** (updated when generating Zoning tax lots, ignore)
- [ ] **dof_condo** (updated when generating Zoning tax lots, ignore)
- [ ] **dcp_commercialoverlay** (updated when generating Zoning tax lots, ignore)
- [ ] **dcp_limitedheight** (updated when generating Zoning tax lots, ignore)
- [ ] **dcp_zoningdistricts** (updated when generating Zoning tax lots, ignore)
- [ ] **dcp_specialpurpose** (updated when generating Zoning tax lots, ignore)
- [ ] **dcp_specialpurposesubdistricts** (updated when generating Zoning tax lots, ignore)
- [ ] **dcp_zoningmapamendments** (updated when generating Zoning tax lots, ignore)
- [ ] **dcp_zoningmapindex** (never updated, safe to ignore)
- [ ] **fema_firms2007_100yr** (never updated, safe to ignore)
- [ ] **fema_pfirms2015_100yr** (never updated, safe to ignore)
> computed
- [ ] **pluto_corrections** (pulling from bytes, must update in recipes)
- [ ] **pluto_input_research** (just update the file in repo, no need to push to recipes)
- [ ] **pluto_input_numbldgs** (computed when building footprints are updated, check [here](https://data.cityofnewyork.us/Housing-Development/Building-Footprints/nqwf-w8eh))
- [ ] **pluto_pts** (pulled from SFTP)
- [ ] **pluto_input_geocodes** (Generated with pts)
- [ ] **pluto_input_cama_dof** (pulled from SFTP)
# PLUTO Improvements (corrections)

# Comments
