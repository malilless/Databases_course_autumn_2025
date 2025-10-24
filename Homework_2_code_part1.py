-- THIS CODE WAS CREATED BY CHATGPT 
import mysql.connector
from mysql.connector import Error
import random

# ------------------- PARAMETERS -------------------
N = 1_000_000
BATCH_SIZE = 10_000
RNG_SEED = 42
random.seed(RNG_SEED)

# ------------------- DATA -------------------
first_names = [
    "Oleksandr","Maria","Ivan","Anna","Dmytro","Olena","Maksym","Kateryna","Sofia","Artem",
    "Victor","Natalia","Yurii","Valeria","Serhii","Iryna","Bohdan","Lyudmyla","Roman","Oksana",
    "Pavlo","Lesya","Tymofii","Hanna","Mykhailo","Alina","Stepan","Marina","Vladyslav","Yehor"
]
last_names = [
    "Koval","Shevchenko","Bondarenko","Tkachenko","Kravenko","Oliinyk","Lysenko","Melnyk","Polishchuk","Savchenko",
    "Kozak","Honchar","Rybak","Kulynych","Nazarenko","Martyniuk","Borysenko","Romanyuk","Kopylov","Yatsenko",
    "Doros","Protsenko","Fedorenko","Shapoval","Vernyhora","Kyrylenko","Kovalenko","Zhuravel","Petriv","Ostapchuk"
]

# Expanded universities
universities = [
    "KSE", "KNU", "KPI", "LNU", "NURE", "Odessa National University", "Kharkiv University"
]
university_weights = [0.5, 0.15, 0.1, 0.05, 0.05, 0.075, 0.075]

specialties = [
    "Economics", "History", "Applied Mathematics", "Philology", "Sociology",
    "Computer Science", "Psychology", "Physics", "Chemistry", "Marketing",
    "Management", "International Relations", "Law", "Biology"
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

def generate_students(start_id, size):
    ids = list(range(start_id, start_id + size))
    names = [f"{random.choice(first_names)} {random.choice(last_names)}" for _ in range(size)]
    unis = [random.choices(universities, weights=university_weights)[0] for _ in range(size)]
    specs = [random.choice(specialties) for _ in range(size)]
    return list(zip(ids, names, unis, specs))

def insert_students(connection):
    cursor = connection.cursor()
    sql = "INSERT INTO students (id, name, uni, specialty) VALUES (%s, %s, %s, %s)"
    
    for start in range(1, N + 1, BATCH_SIZE):
        end = min(start + BATCH_SIZE - 1, N)
        data = generate_students(start, end - start + 1)
        cursor.executemany(sql, data)
        connection.commit()
        print(f"Inserted {end} / {N} students")

# ------------------- MAIN -------------------
if __name__ == "__main__":
    conn = create_connection()
    if conn:
        insert_students(conn)
        conn.close()
        print("✅ Students table populated")



