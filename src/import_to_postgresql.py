from sqlalchemy import create_engine
import pandas as pd
import psycopg2
from sqlalchemy.exc import SQLAlchemyError

# create_engine(dialect+driver://username:password@host:port/database)
#References: https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls

username    = "postgres"
pw          = "password"
host_name   = "localhost"
port        = "5432"
db_name     = "cyclistic_bike_db"

year = [    "202104", "202105", "202106", "202107",
            "202108", "202109", "202110", "202111", "202112"
            , "202201", "202202", "202203"
        ]

def insert_tables(year, *args):
    username    = args[0]
    pw          = args[1]
    host_name   = args[2]
    port        = args[3]
    db_name     = args[4]

    for each_yr in year:
        file_name = "data/" + each_yr + "-divvy-tripdata.csv"
        tb_name = each_yr +"-cyclistic-tripdata"

        #--- df = pd.read_csv("data/202204-divvy-tripdata.csv") -- Hard coded
        df = pd.read_csv(file_name)
        engine = create_engine(f"postgresql://{username}:{pw}@{host_name}:{port}/{db_name}")

        try:
            #df.to_sql('202204-cyclistic-tripdata', engine) -- Hard coded
            df.to_sql(tb_name, engine)
        except SQLAlchemyError as err:
            print(f"Unsuccessful import, Error: {err}")
            break
        else:
            print(f"Successfully imported the [{each_yr}-cyclistic] table into the database!")



insert_tables(year, username, pw, host_name, port, db_name)



# 202104
# 202105
# 202106
# 202107
# 202108
# 202109
# 202110
# 202111
# 202112
#
# 202201
# 202202
# 202203
