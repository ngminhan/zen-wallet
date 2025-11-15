import pkg from "pg";
import dotenv from "dotenv";
import { setTypeParser, builtins } from "pg-types";

dotenv.config({path: "./.env" });
console.log("Loaded .env:", process.env.PGUSER, process.env.PGDATABASE);

const { Pool } = pkg;

setTypeParser(builtins.NUMERIC, (val) => (val === null ? null : parseFloat(val)));
setTypeParser(builtins.FLOAT8,  (val) => (val === null ? null : parseFloat(val)));
setTypeParser(builtins.INT8,    (val) => (val === null ? null : parseInt(val, 10)));

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
