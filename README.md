# PLUTO and MapPLUTO 
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/NYCPlanning/db-pluto?label=version) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/NYCPlanning/db-pluto/CI?label=CI) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/NYCPlanning/db-pluto/CAMA%20Processing?label=CAMA) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/NYCPlanning/db-pluto/PTS%20processing?label=PTS)

Please note that we're still working on this repo as we optimize the build processes, update the sources for the raw data inputs, and implement better technologies.  We're excited that PLUTO users can now look under the hood and begin exploring how PLUTO is built and each of its individual fields are calculated. If you have suggestions or find any problems, please open an issue, or if you have questions please reach out to us directly.

### Main files: 
Type | Shapefile | FileGDB | CSV
-- | -- | -- | --
Clipped | [Mappluto](https://edm-publishing.nyc3.digitaloceanspaces.com/db-pluto/main/latest/output/mappluto/mappluto.zip) | [Mappluto.gdb](https://edm-publishing.nyc3.digitaloceanspaces.com/db-pluto/main/latest/output/mappluto_gdb.gdb/mappluto_gdb.gdb.zip) | NA 
Unclipped (Water Included) | [Mappluto_unclipped](https://edm-publishing.nyc3.digitaloceanspaces.com/db-pluto/main/latest/output/mappluto_unclipped/mappluto_unclipped.zip) | [Mappluto_unclipped.gdb](https://edm-publishing.nyc3.digitaloceanspaces.com/db-pluto/main/latest/output/mappluto_unclipped_gdb.gdb/mappluto_unclipped_gdb.gdb.zip) |  NA
No Geometry |  NA | NA  | [Pluto.csv](https://edm-publishing.nyc3.digitaloceanspaces.com/db-pluto/main/latest/output/pluto/pluto.zip)

### Additional resources:
+ [DOF BBL Council export](https://edm-publishing.nyc3.digitaloceanspaces.com/db-pluto/main/latest/output/dof/bbl_council.zip)
+ [PLUTO Corrections](https://edm-publishing.nyc3.digitaloceanspaces.com/db-pluto/main/latest/output/pluto_corrections.zip)
+ [Source Data Versions](https://edm-publishing.nyc3.digitaloceanspaces.com/db-pluto/main/latest/output/source_data_versions.csv)
+ [QAQC Portal](https://edm-data-engineering.nycplanningdigital.com/?page=PLUTO)

Please go to NYC Planning's [Bytes of the Big Apple](https://www1.nyc.gov/site/planning/data-maps/open-data.page) to download the offical versions of PLUTO and MapPLUTO

## __About PLUTO__

The Primary Land Use Tax Lot Output (PLUTO) **reports tax lot and building characteristics, and geographic/political/administrative districts at the tax lot level** from data maintained by the Department of City Planning (DCP), Department of Finance (DOF), Department of Citywide Administrative Services (DCAS), and Landmarks Preservation Commission (LPC).

DCP merges PLUTO data with the DCP modified version of DOF’s Digital Tax Map (`dof_dtm`) to create MapPLUTO for use with various geographic information systems.

The PLUTO data contain one record per tax lot except for condominiums.  PLUTO data contain one record per condominium complex instead of records for each condominium unit tax lot.  A tax lot is usually a parcel of real property.  The parcel can be under water, vacant, or contain one or more buildings or structures.  The Department of Finance assigns a tax lot number to each condominium unit and a "billing" tax lot number to the Condominium Complex. A Condominium Complex is defined as one or more structures or properties under the auspices of the same condominium association.  DCP summarizes DOF's condominium unit tax lot data so that each Condominium Complex within a tax block is represented by only one record.  The Condominium Complex record is assigned the "billing" tax lot number when one exists.  When the "billing" tax lot number has not yet been assigned by DOF, the lowest tax lot number within the tax block of the Condominium Complex is assigned.

**Limitations**:
DCP provides PLUTO for informational purposes only. DCP does not warranty and is not liable for the completeness, accuracy, content, or fitness for any particular purpose or use of PLUTO.

Lean more about PLUTO, its idiosyncrasies and limitations in [PLUTO's metadata](https://www1.nyc.gov/assets/planning/download/pdf/data-maps/open-data/plutolayout.pdf).

## __How you can help__

We want to make PLUTO most useful and accurate for its users, so open an [issue](https://github.com/NYCPlanning/db-pluto/issues) to report an error or suggest how we can improve PLUTO.

## __Instructions__

#### I. Build PLUTO Through CI
1. just create a new push to the repo and a build will be triggered if `[build]` in included your commit message
2. Make sure you have the correct version info and the previous version info in the `version.env` file
3. If you would like to update PTS, geocoded PTS and CAMA, in order to trigger data ingestion for them, include `[pts]` or `[cama]` or both (`[pts] [cama]`) to trigger a data ingestion workflow

#### II. Build PLUTO on Your Own Machine
1. make sure you have [__psql__](https://packages.debian.org/sid/postgresql-client-common) installed
2. `./01_dataloading.sh` : load all input data into build environment
3.  `./02_build.sh` : Build PLUTO and MapPLUTO.
4.  `./03_corrections.sh` : Apply pluto research corrections
5.  `./04_archive.sh` : Archive output to EDM_DATA
6.  `./05_export.sh` : Export PLUTO csv, MapPLUTO shapefile and pluto_corrections file

#### III. QAQC
Please refer to the qaqc web application for cross version comparisons
