-- THIS CODE WAS CREATED BY CHATGPT 
import mysql.connector
from mysql.connector import Error
import numpy as np

# ------------------- PARAMETERS -------------------
N = 1_000_000
BATCH_SIZE = 10_000
RNG_SEED = 42
np.random.seed(RNG_SEED)

# ------------------- DATA -------------------
courses = [
    "Microeconomics", "Ukrainian History", "Higher Mathematics", "Programming", "Political Science",
    "Macroeconomics", "Literature Studies", "Management", "Philosophy", "Linguistics",
    "Theoretical Physics", "Organic Chemistry", "Discrete Mathematics", "Statistics", "Databases"
]

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

def generate_progress(start_id, size):
    ids = list(range(start_id, start_id + size))
    
    # Beta distribution to generate GPA (clustered toward high values but varied)
    a, b = 5, 2  # a> b → skew toward high GPAs
    gpas = 60 + (100 - 60) * np.random.beta(a, b, size=size)
    gpas = np.round(gpas, 2)
    
    best_courses = [np.random.choice(courses) for _ in range(size)]
    return list(zip(ids, gpas.tolist(), best_courses))

def insert_progress(connection):
    cursor = connection.cursor()
    sql = "INSERT INTO progress (id, GPA, best_completed_course) VALUES (%s, %s, %s)"
    
    for start in range(1, N + 1, BATCH_SIZE):
        end = min(start + BATCH_SIZE - 1, N)
        data = generate_progress(start, end - start + 1)
        cursor.executemany(sql, data)
        connection.commit()
        print(f"Inserted {end} / {N} progress records")

# ------------------- MAIN -------------------
if __name__ == "__main__":
    conn = create_connection()
    if conn:
        insert_progress(conn)
        conn.close()
        print("✅ Progress table populated")

