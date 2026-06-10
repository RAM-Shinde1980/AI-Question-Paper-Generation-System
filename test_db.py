import mysql.connector

try:
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Ramji@1980",
        database="questionpaperdb"
    )
    print("MySQL connected successfully")
    conn.close()
except mysql.connector.Error as err:
    print("Error:", err)