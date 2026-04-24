import os
import mysql.connector
from pymongo import MongoClient
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_mysql_connection():
    return mysql.connector.connect(
        host=os.getenv("MYSQL_HOST"),
        database=os.getenv("MYSQL_DATABASE"),
        user=os.getenv("MYSQL_USER"),
        password=os.getenv("MYSQL_PASSWORD"),
    )

def get_mongo_collection():
    mongo_user = os.getenv("MONGO_USER")
    mongo_password = os.getenv("MONGO_PASSWORD")
    mongo_host = os.getenv("MONGO_HOST")
    mongo_port = os.getenv("MONGO_PORT", "27017")
    mongo_db = os.getenv("MONGO_DATABASE")

    uri = f"mongodb://{mongo_user}:{mongo_password}@{mongo_host}:{mongo_port}/?authSource=admin"
    client = MongoClient(uri)
    db = client[mongo_db]
    return db["posts"]

@app.get("/users")
async def get_users():
    conn = get_mysql_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT id, name, email, created_at FROM users")
    users = cursor.fetchall()
    cursor.close()
    conn.close()
    return {"users": users}

@app.get("/posts")
async def get_posts():
    collection = get_mongo_collection()
    posts = list(collection.find({}, {"_id": 0}))
    return {"posts": posts}

@app.get("/health")
async def health():
    users = await get_users()
    posts = await get_posts()

    if len(users["users"]) == 4 and len(posts["posts"]) == 5:
        return {"status": "OK"}

    return {"status": "ERROR"}