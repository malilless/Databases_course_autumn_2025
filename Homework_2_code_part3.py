import mysql.connector
from mysql.connector import Error
import random

# ------------------- PARAMETERS -------------------
N = 1_000_000
BATCH_SIZE = 10_000
RNG_SEED = 42
random.seed(RNG_SEED)

# ------------------- FUNCTIONS -------------------
def create_connection():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="student",
            password="Tb7GpwrPbdIYHa80",
            database="hw2"
        )
        if conn.is_connected():
            print("Connection successful")
        return conn
    except Error as e:
        print(f"Error: {e}")
        return None

def generate_medalists(start_id, size):
    ids = list(range(start_id, start_id + size))
    medals = [random.choice(["YES", "NO"]) for _ in range(size)]
    return list(zip(ids, medals))

def insert_medalists(connection):
    cursor = connection.cursor()
    sql = "INSERT INTO school_medalists (id, medalist) VALUES (%s, %s)"
    
    for start in range(1, N + 1, BATCH_SIZE):
        end = min(start + BATCH_SIZE - 1, N)
        data = generate_medalists(start, end - start + 1)
        cursor.executemany(sql, data)
        connection.commit()
        print(f"Inserted {end} / {N} medalists")

# ------------------- MAIN -------------------
if __name__ == "__main__":
    conn = create_connection()
    if conn:
        insert_medalists(conn)
        conn.close()
        print("✅ School_medalists table populated")
