import pkg from "pg";
import dotenv from "dotenv";
dotenv.config({path: "./.env" });
console.log("Loaded .env:", process.env.PGUSER, process.env.PGDATABASE);

const { Pool } = pkg;

const pool = new Pool({
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  port: process.env.PGPORT,
});



pool.connect()
  .then(() => console.log("Connected to PostgreSQL"))
  .catch(err => console.error("Database connection error: ", err));

export default pool;
