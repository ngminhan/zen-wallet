import pool from "../db.js";

export async function getAllTransactions() {
  const result = await pool.query(`
    SELECT t.*, u.name AS user_name
    FROM transactions t
    JOIN users u ON t.user_id = u.user_id
    ORDER BY t.created_at DESC
  `);
  return result.rows;
}

export async function createTransaction(user_id, category, amount, note) {
  const result = await pool.query(
    `INSERT INTO transactions (user_id, category, amount, note)
     VALUES ($1, $2, $3, $4)
     RETURNING *`,
    [user_id, category, amount, note]
  );
  return result.rows[0];
}

export async function getTransactionStats(user_id, month, year) {
  const result = await pool.query(
    `
    SELECT 
      category,
      SUM(amount)::numeric(12,2) AS total_spent
    FROM transactions
    WHERE user_id = $1
      AND EXTRACT(MONTH FROM created_at) = $2
      AND EXTRACT(YEAR FROM created_at) = $3
    GROUP BY category
    ORDER BY total_spent DESC
    `,
    [user_id, month, year]
  );
  return result.rows;
}

