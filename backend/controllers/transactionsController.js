import {
  getAllTransactions,
  createTransaction,
} from "../models/transactionsModel.js";

export async function fetchTransactions(req, res) {
  try {
    const { firebase_uid } = req.user;

    // Lấy user_id từ bảng users dựa trên firebase_uid
    const userQuery = await pool.query(
      "SELECT user_id FROM users WHERE firebase_uid = $1",
      [firebase_uid]
    );
    const user_id = userQuery.rows[0].user_id;

    const transactions = await pool.query(
      "SELECT * FROM transactions WHERE user_id = $1 ORDER BY created_at DESC",
      [user_id]
    );

    res.json(transactions.rows);
  } catch (error) {
    console.error("❌ Error fetching transactions:", error.message);
    res.status(500).json({ error: error.message });
  }
}


export async function addTransaction(req, res) {
  try {
    const { firebase_uid } = req.user;
    const { category, amount, note } = req.body;

    const userQuery = await pool.query(
      "SELECT user_id FROM users WHERE firebase_uid = $1",
      [firebase_uid]
    );
    const user_id = userQuery.rows[0].user_id;

    const result = await pool.query(
      `INSERT INTO transactions (user_id, category, amount, note)
       VALUES ($1, $2, $3, $4)
       RETURNING *`,
      [user_id, category, amount, note]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error("❌ Error adding transaction:", error.message);
    res.status(500).json({ error: error.message });
  }
}


import { getTransactionStats } from "../models/transactionsModel.js";

export async function getStats(req, res) {
  try {
    const { user_id, month, year } = req.query;

    if (!user_id || !month || !year) {
      return res
        .status(400)
        .json({ message: "Thiếu user_id, month hoặc year" });
    }

    const stats = await getTransactionStats(user_id, month, year);
    res.json(stats);
  } catch (error) {
    console.error("❌ Error fetching stats:", error.message);
    res.status(500).json({ error: error.message });
  }
}

