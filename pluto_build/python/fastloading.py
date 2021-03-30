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
        "lpc_historic_districts",
        "lpc_landmarks",

        # for spatial joins
        "doitt_zipcodeboundaries",
        "dsny_frequencies",
        "dpr_greenthumb",
        "dcp_councildistricts",
        
        # FEMA 2007 and preliminary 2015 100 year flood zones
        "fema_firms2007_100yr",
        "fema_pfirms2015_100yr"
    ]

    with Pool(processes=cpu_count()) as pool:
        pool.map(ETL, tables)
