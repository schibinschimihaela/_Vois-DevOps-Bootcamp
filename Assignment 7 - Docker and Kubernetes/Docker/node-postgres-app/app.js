const express = require("express");
const { Client } = require("pg");

const app = express();

// Configure PostgreSQL client
const client = new Client({
  host: "db", // Name of the PostgreSQL service in Docker Compose
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
});

client.connect()
  .then(() => console.log("Connected to PostgreSQL"))
  .catch(err => console.error("DB connection error", err));

app.get("/", (req, res) => {
  res.send("Hello from Node.js + PostgreSQL (Docker Compose)");
});

app.listen(3000, "0.0.0.0", () => {
  console.log("Server running on port 3000");
});
