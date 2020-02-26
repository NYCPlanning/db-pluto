from pathlib import Path
from sqlalchemy import create_engine
from urllib.parse import urlparse
import psycopg2
import os

def psycopg2_connect(url):
    result = urlparse(str(url))
    username = result.username
    password = result.password
    database = result.path[1:]
    hostname = result.hostname
    port = result.port
    connection = psycopg2.connect(
        database = database,
        user = username,
        password = password,
        host = hostname, 
        port = port)
    return connection