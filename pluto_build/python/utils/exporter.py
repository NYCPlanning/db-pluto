from .engines import psycopg2_connect
from sqlalchemy.types import TEXT
import io
import psycopg2
import logging
import os


def exporter(df, table_name, con, sep="~", null=""):

    # psycopg2 connections
    db_connection = psycopg2_connect(con.url)
    db_cursor = db_connection.cursor()
    str_buffer = io.StringIO()
    column_definitions = ",".join([f"{c.lower()} text" for c in df.columns])

    # # Create table
    create = f"""
    DROP TABLE IF EXISTS {table_name} CASCADE;
    CREATE TABLE {table_name} (
        {column_definitions}
    );
    """
    con.connect().execute(create)
    con.dispose()

    # export
    df = df.replace(sep, null, regex=True)
    df.to_csv(str_buffer, sep=sep, header=True, index=False)
    str_buffer.seek(0)
    del df
    
    db_cursor.copy_expert(
        f"COPY {table_name} FROM STDIN WITH NULL AS '{null}' DELIMITER '{sep}' quote '\"' CSV HEADER",
        str_buffer,
    )

    db_cursor.connection.commit()
    str_buffer.close()
    db_cursor.close()
    db_connection.close()
