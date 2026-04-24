db = db.getSiblingDB("blog_db");

db.createCollection("posts", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["title", "content", "author", "created_at"],
      properties: {
        title: {
          bsonType: "string",
          description: "Le titre doit être une chaîne de caractères"
        },
        content: {
          bsonType: "string",
          description: "Le contenu doit être une chaîne de caractères"
        },
        author: {
          bsonType: "string",
          description: "L'auteur doit être une chaîne de caractères"
        },
        created_at: {
          bsonType: "date",
          description: "La date doit être au format Date"
        }
      }
    }
  }
});

db.posts.insertMany([
  {
    title: "Introduction à Docker",
    content: "Docker permet de lancer des applications dans des conteneurs.",
    author: "Axel",
    created_at: new Date()
  },
  {
    title: "Découverte de MongoDB",
    content: "MongoDB est une base de données NoSQL orientée documents.",
    author: "Lorenzo",
    created_at: new Date()
  },
  {
    title: "FastAPI et Python",
    content: "FastAPI permet de créer rapidement des API performantes.",
    author: "Enzo",
    created_at: new Date()
  },
  {
    title: "MySQL dans Docker",
    content: "MySQL peut être orchestré facilement avec Docker Compose.",
    author: "Ibrahim",
    created_at: new Date()
  },
  {
    title: "Stack hybride",
    content: "Une stack hybride peut utiliser à la fois SQL et NoSQL.",
    author: "Axel",
    created_at: new Date()
  }
]);