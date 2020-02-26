# PLUTO and MapPLUTO ![CI](https://github.com/NYCPlanning/db-pluto/workflows/CI/badge.svg)

Please note that we're still working on this repo as we optimize the build processes, update the sources for the raw data inputs, and implement better technologies.  We're excited that PLUTO users can now look under the hood and begin exploring how PLUTO is built and each of its individual fields are calculated. If you have suggestions or find any problems, please open an issue, or if you have questions please reach out to us directly.

+ [PLUTO](https://edm-publishing.nyc3.digitaloceanspaces.com/db-pluto/latest/output/pluto/pluto.zip)
+ [MapPLUTO](https://edm-publishing.nyc3.digitaloceanspaces.com/db-pluto/latest/output/mappluto/mappluto.zip)
+ [PLUTO Corrections](https://edm-publishing.nyc3.digitaloceanspaces.com/db-pluto/latest/output/pluto_corrections.zip)

Please go to NYC Planning's [Bytes of the Big Apple](https://www1.nyc.gov/site/planning/data-maps/open-data.page) to download the offical versions of PLUTO and MapPLUTO
## __About PLUTO__

The Primary Land Use Tax Lot Output (PLUTO) **reports tax lot and building characteristics, and geographic/political/administrative districts at the tax lot level** from data maintained by the Department of City Planning (DCP), Department of Finance (DOF), Department of Citywide Administrative Services (DCAS), and Landmarks Preservation Commission (LPC).

DCP merges PLUTO data with the DCP modified version of DOF’s Digital Tax Map (`dof_dtm`) to create MapPLUTO for use with various geographic information systems.

The PLUTO data contain one record per tax lot except for condominiums.  PLUTO data contain one record per condominium complex instead of records for each condominium unit tax lot.  A tax lot is usually a parcel of real property.  The parcel can be under water, vacant, or contain one or more buildings or structures.  The Department of Finance assigns a tax lot number to each condominium unit and a "billing" tax lot number to the Condominium Complex. A Condominium Complex is defined as one or more structures or properties under the auspices of the same condominium association.  DCP summarizes DOF's condominium unit tax lot data so that each Condominium Complex within a tax block is represented by only one record.  The Condominium Complex record is assigned the "billing" tax lot number when one exists.  When the "billing" tax lot number has not yet been assigned by DOF, the lowest tax lot number within the tax block of the Condominium Complex is assigned.

**Limitations**:
DCP provides PLUTO for informational purposes only. DCP does not warranty and is not liable for the completeness, accuracy, content, or fitness for any particular purpose or use of PLUTO.

Lean more about PLUTO, its idiosyncrasies and limitations in [PLUTO's metadata](https://www1.nyc.gov/assets/planning/download/pdf/data-maps/open-data/plutolayout.pdf?r=19v1).

## __How you can help__

We want to make PLUTO most useful and accurate for its users, so open an [issue](https://github.com/NYCPlanning/db-pluto/issues) to report an error or suggest how we can improve PLUTO.

## __How to build PLUTO__

### Development workflow

#### Fill in .env files according to `example.env`

#### Build PLUTO

Run the scripts in pluto_build in order:

#### `./01_dataloading.sh`
load all input data into build environment

#### `./02_build.sh`
Build PLUTO and MapPLUTO.

#### `./03_corrections.sh`
Apply pluto research corrections

#### `./04_archive.sh`
Archive output to EDM_DATA

#### `./05_export.sh`
Export PLUTO csv, MapPLUTO shapefile and pluto_corrections file

#### QAQC
Please refer to the qaqc web application for cross version comparisons
