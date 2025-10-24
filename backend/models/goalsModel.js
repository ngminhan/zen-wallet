import pool from "../db.js";

export async function getGoalsByUser() {
  const result = await pool.query(`
    SELECT g.*, u.name AS user_name
    FROM goals g
    JOIN users u ON g.user_id = u.user_id
    ORDER BY g.created_at DESC
  `);
  return result.rows;
}

export async function createGoal(user_id, month, year, amount) {
  const result = await pool.query(
    `INSERT INTO goals (user_id, month, year, amount)
     VALUES ($1, $2, $3, $4)
     RETURNING *`,
    [user_id, month, year, amount]
  );
  return result.rows[0];
}

export async function updateGoal(goal_id, amount) {
  const result = await pool.query(
    `UPDATE goals
     SET amount = $1
     WHERE goal_id = $2
     RETURNING *`,
    [amount, goal_id]
  );
  return result.rows[0];
}