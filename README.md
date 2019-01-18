# PLUTO and MapPLUTO

Please note that we're still working on this repo as we optimize the build processes, update the sources for the raw data inputs, and implement better technologies.  We're excited that PLUTO users can now look under the hood and begin exploring how PLUTO is built and each of its individual fields are calculated. If you have suggestions or find any problems, please open an issue, or if you have questions please reach out to us directly.

## About PLUTO

The Primary Land Use Tax Lot Output (PLUTO) **reports tax lot and building characteristics, and geographic/political/administrative districts at the tax lot level** from data maintained by the Department of City Planning (DCP), Department of Finance (DOF), Department of Citywide Administrative Services (DCAS), and Landmarks Preservation Commission (LPC).

DCP merges PLUTO data with the DCP modified version of DOF’s Digital Tax Map to create MapPLUTO for use with various geographic information systems.

The PLUTO data contain one record per tax lot except for condominiums.  PLUTO data contain one record per condominium complex instead of records for each condominium unit tax lot.  A tax lot is usually a parcel of real property.  The parcel can be under water, vacant, or contain one or more buildings or structures.  The Department of Finance assigns a tax lot number to each condominium unit and a "billing" tax lot number to the Condominium Complex.  A Condominium Complex is defined as one or more structures or properties under the auspices of the same condominium association.  DCP summarizes DOF's condominium unit tax lot data so that each Condominium Complex within a tax block is represented by only one record.  The Condominium Complex record is assigned the "billing" tax lot number when one exists.  When the "billing" tax lot number has not yet been assigned by DOF, the lowest tax lot number within the tax block of the Condominium Complex is assigned.

**Limitations**:
DCP provides PLUTO for informational purposes only. DCP does not warranty and is not liable for the completeness, accuracy, content, or fitness for any particular purpose or use of PLUTO.

Lean more about PLUTO, its idiosyncrasies and limitations in [PLUTO's metadata](https://www1.nyc.gov/assets/planning/download/pdf/data-maps/open-data/plutolayout.pdf?r=17v11a).

## How you can help

We want to make PLUTO most useful and accurate for its users, so open an [issue](https://github.com/NYCPlanning/db-pluto/issues) to report an error or suggest how we can improve PLUTO.

## How to build PLUTO

### Prerequisites:

1. Bash > 4.0

2. node.js

3. psql 9.5.5

4. Ability to attach PostGIS extension to postgres databases
   
5. If psql role you intend to use is not your unix name, set up a .pgpass file like this:
    *:*:*:dbadmin:dbadmin_password
    ```~/.pgpass should have permissions 0600 (chmod 0600 ~/.pgpass)```

### Development workflow

#### Fill in configuration files

**pluto.config.json**

Your config file should look something like this:
```{
"DBNAME":"databasename",
"DBUSER":"databaseuser",
"GEOCLIENT_APP_ID":"id",
"GEOCLIENT_APP_KEY":"key"
}```

#### Prepare data-loading-scripts

Clone and configure the data-loading-scripts repo: https://github.com/NYCPlanning/data-loading-scripts 
Make sure the database data-loading-scripts uses is the same one you listed in your pluto.config.json file.

#### Build PLUTO

Run the scripts in pluto_build in order:

#### 01_dataloading.sh

Download and load all input datasets required to create PLUTO into database.

#### 02_qaqc.sh

Check for new building classes and zero or missing condo numbers.  New building classes need to be added to pluto_input_landuse_bldgclass.csv

#### 03_build.sh

Build PLUTO and MapPLUTO.

#### 05_export.sh

Export PLUTO and unclipped MapPLUTO.

Please go to NYC Planning's [Bytes of the Big Apple](https://www1.nyc.gov/site/planning/data-maps/open-data.page) to download the offical versions of PLUTO and MapPLUTO

#### Validation

Please see https://github.com/NYCPlanning/db-pluto-qaqc for validation scripts.

