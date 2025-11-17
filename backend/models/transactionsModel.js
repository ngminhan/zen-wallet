import pool from "../db.js";

/**
 * 🔹 Lấy tất cả transaction của 1 user
 */
export async function getUserTransactions(userId) {
  const result = await pool.query(
    `SELECT transaction_id, user_id, type, category, amount::float8 AS amount, note, created_at
     FROM transactions
     WHERE user_id = $1
     ORDER BY created_at DESC`,
    [userId]
  );
  return result.rows;
}

/**
 * 🔹 Tạo transaction mới (hỗ trợ truyền createdAt)
 */
export async function insertTransaction({ userId, type, category, amount, note, createdAt }) {
  if (type === "INCOME") {
    const result = await pool.query(
      `
      INSERT INTO transactions (user_id, type, amount, note, created_at)
      VALUES ($1, $2, $3, $4, COALESCE($5, NOW()))
      RETURNING transaction_id, user_id, type, category, amount::float8 AS amount, note, created_at
      `,
      [userId, type, amount, note || null, createdAt || null]
    );
    return result.rows[0];
  } else {
    const result = await pool.query(
      `
      INSERT INTO transactions (user_id, type, category, amount, note, created_at)
      VALUES ($1, $2, $3, $4, $5, COALESCE($6, NOW()))
      RETURNING transaction_id, user_id, type, category, amount::float8 AS amount, note, created_at
      `,
      [userId, type, category, amount, note || null, createdAt || null]
    );
    return result.rows[0];
  }
}

/**
 * 🔹 Xoá transaction theo ID + user
 */
export async function deleteTransactionById(userId, transactionId) {
  const result = await pool.query(
    `DELETE FROM transactions
     WHERE transaction_id = $1 AND user_id = $2
     RETURNING transaction_id`,
    [transactionId, userId]
  );
  return result.rowCount > 0;
}

/**
 * 🔹 Cập nhật transaction
 */
export async function updateTransactionById(userId, transactionId, data) {
  const { type, category, amount, note, createdAt } = data;

  const result = await pool.query(
    `UPDATE transactions
     SET type = COALESCE($1, type),
         category = $2, -- cho phép NULL
         amount = COALESCE($3, amount),
         note = COALESCE($4, note),
         created_at = COALESCE($5, created_at)
     WHERE transaction_id = $6 AND user_id = $7
     RETURNING transaction_id, user_id, type, category, amount::float8 AS amount, note, created_at`,
    [type, category, amount, note, createdAt, transactionId, userId]
  );

  return result.rows[0];
}

