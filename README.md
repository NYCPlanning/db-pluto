# PLUTO and MapPLUTO

The Primary Land Use Tax Lot Output (PLUTO) **reports tax lot and building characteristics, and geographic/political/administrative districts at the tax lot level** from data maintained by the Department of City Planning (DCP), Department of Finance (DOF), Department of Citywide Administrative Services (DCAS), and Landmarks Preservation Commission (LPC).

DCP merges PLUTO data with the DCP modified version of DOF’s Digital Tax Map to create MapPLUTO for use with various geographic information systems.

There are two **idiosyncrasies** regarding the tax lot data. 
1. The PLUTO data contain one record per tax lot except for condominiums. PLUTO data contain one record per condominium complex instead of records for each condominium unit tax lot by summarizing DOF's condominium unit tax lot data so that each condominium complex within a tax block is represented by only one record.
2. Two portions of the City, Marble Hill and Rikers Island, are legally located in one borough but are serviced by another borough. Specifically, Marble Hill is legally located in Manhattan but is serviced by The Bronx, while Rikers Island is legally part of The Bronx but is serviced by Queens.

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

4. Ability to attach PostGIS extension and the fuzzystrmatch extension to postgres databases
   
5. If psql role you intend to use is not your unix name, set up a .pgpass file like this:
    *:*:*:dbadmin:dbadmin_password
    ~/.pgpass should have permissions 0600 (chmod 0600 ~/.pgpass)


### Development workflow

#### Fill in configuration files

**pluto.config.json**

Your config file should look something like this:
{
"DBNAME":"databasename",
"DBUSER":"databaseuser",
"GEOCLIENT_APP_ID":"id",
"GEOCLIENT_APP_KEY":"key"
}

#### Prepare data-loading-scripts

Clone and configure the data-loading-scripts repo: https://github.com/NYCPlanning/data-loading-scripts 
Make sure the database data-loading-scripts uses is the same one you listed in your pluto.config.json file.

#### Build PLUTO

Run the scripts in pluto_build in order:

#### 01_dataloading.sh

Download and load all input datasets required to create PLUTO into database.

#### 02_qaqc.sh

Check that there are no errors in the source datasets and generate reports with diagnostics.

#### 03_build.sh

Build PLUTO based on the input datasets.

## Maintenance information

#### Release schedule