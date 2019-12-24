from utils import CREATE_VIEW, ARCHIVE, VERSION
from datetime import datetime
from dotenv import load_dotenv, find_dotenv
load_dotenv(find_dotenv())

if __name__ == "__main__":
    ARCHIVE(dst_schema_name='dcp_pluto',
            dst_version=VERSION,
            src_version='pluto',
            src_schema_name='public')