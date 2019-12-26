from dotenv import load_dotenv, find_dotenv
from sqlalchemy import create_engine
import os

load_dotenv(find_dotenv())
con = create_engine(os.getenv('EDM_DATA'))