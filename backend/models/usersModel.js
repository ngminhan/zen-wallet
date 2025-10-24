import pool from "../db.js";

export async function getAllUsers() {
    const result = await pool.query("SELECT * FROM users");
    return result.rows;
}

export async function createUser(name, email) {
    const result = await pool.query(
        "INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *",
        [name, email]
    );
    return result.rows[0];
}