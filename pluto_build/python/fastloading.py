from cook import Importer
from multiprocessing import Pool, cpu_count
import os


def ETL(table):
    RECIPE_ENGINE = os.environ.get("RECIPE_ENGINE", "")
    BUILD_ENGINE = os.environ.get("BUILD_ENGINE", "")
    importer = Importer(RECIPE_ENGINE, BUILD_ENGINE)
    importer.import_table(schema_name=table)


if __name__ == "__main__":
    tables = [
        "pluto_corrections",
        "dcp_edesignation",
        "dcas_facilities_colp",
        "lpc_historic_districts",
        "lpc_landmarks",
        # for spatial joins
        "dcp_cdboundaries",
        "dcp_censustracts",
        "dcp_censusblocks",
        "dcp_school_districts",
        "dcp_councildistricts",
        "doitt_zipcodeboundaries",
        "dcp_firecompanies",
        "dcp_policeprecincts",
        "dcp_healthareas",
        "dcp_healthcenters",
        "dsny_frequencies",
        "dcp_pluto",
        "dcp_mappluto",
        "dpr_greenthumb",
        # Other_datasets - PULLING FROM FTP
        "pluto_pts",
        "pluto_input_geocodes",
        # raw CAMA data from DOF
        "pluto_input_cama_dof",
        # raw Digital Tax Map from DOF
        "dof_dtm",
        # raw NYC shoreline file from DOF
        "dof_shoreline",
        # raw DOF condo table
        "dof_condo",
        # DCP zoning datasets~
        "dcp_commercialoverlay",
        "dcp_limitedheight",
        "dcp_zoningdistricts",
        "dcp_specialpurpose",
        "dcp_specialpurposesubdistricts",
        "dcp_zoningmapamendments",
        "dcp_zoningmapindex",
        # FEMA 2007 and preliminary 2015 100 year flood zones
        "fema_firms2007_100yr",
        "fema_pfirms2015_100yr"
    ]

    with Pool(processes=cpu_count()) as pool:
        pool.map(ETL, tables)
