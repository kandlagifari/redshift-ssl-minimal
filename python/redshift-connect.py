import psycopg2
import os


rs_dbname = "coffeedb"
rs_hostname = "redshift-ssl-cluster.c1th5gys1txd.ap-southeast-3.redshift.amazonaws.com"
rs_port = 5439
rs_username = "kafuuchino"
rs_password = os.environ["RS_PASSWORD"]
rs_sslmode = "verify-ca"


conn = psycopg2.connect(
    host = rs_hostname,
    database = rs_dbname,
    port = rs_port, 
    user = rs_username, 
    password = rs_password,
    sslmode = rs_sslmode
)


cursor = conn.cursor()
cursor.execute("CREATE TABLE coffee (name varchar(80), rating int);")
cursor.execute("INSERT INTO coffee VALUES ('kafuuchino', 5);")
cursor.execute("SELECT * FROM coffee;")
# records = cursor.fetchall()
# print(records)

conn.commit()
