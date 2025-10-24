import {
  getGoalsByUser,
  createGoal,
  updateGoal,
} from "../models/goalsModel.js";

export async function fetchGoals(req, res) {
  try {
    const { firebase_uid } = req.user;
    const userQuery = await pool.query(
      "SELECT user_id FROM users WHERE firebase_uid = $1",
      [firebase_uid]
    );
    const user_id = userQuery.rows[0].user_id;

    const result = await pool.query(
      "SELECT * FROM goals WHERE user_id = $1 ORDER BY year DESC, month DESC",
      [user_id]
    );

    res.json(result.rows);
  } catch (error) {
    console.error("❌ Error fetching goals:", error.message);
    res.status(500).json({ error: error.message });
  }
}


export async function addGoal(req, res) {
  try {
    const { firebase_uid } = req.user;
    const { month, year, target_amount, note } = req.body;

    if (!month || !year || !target_amount) {
      return res
        .status(400)
        .json({ message: "Thiếu month, year hoặc target_amount" });
    }

    // Lấy user_id từ bảng users dựa vào firebase_uid
    const userResult = await pool.query(
      "SELECT user_id FROM users WHERE firebase_uid = $1",
      [firebase_uid]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy user tương ứng" });
    }

    const user_id = userResult.rows[0].user_id;

    const result = await pool.query(
      `INSERT INTO goals (user_id, month, year, target_amount, note)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [user_id, month, year, target_amount, note]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error("❌ Error adding goal:", error.message);
    res.status(500).json({ error: error.message });
  }
}

export async function editGoal(req, res) {
  try {
    const { firebase_uid } = req.user;
    const { id } = req.params;
    const { target_amount, note } = req.body;

    // Lấy user_id của người đang đăng nhập
    const userResult = await pool.query(
      "SELECT user_id FROM users WHERE firebase_uid = $1",
      [firebase_uid]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy user" });
    }

    const user_id = userResult.rows[0].user_id;

    // Kiểm tra xem goal có thuộc user này không
    const goalResult = await pool.query(
      "SELECT * FROM goals WHERE goal_id = $1 AND user_id = $2",
      [id, user_id]
    );

    if (goalResult.rows.length === 0) {
      return res
        .status(403)
        .json({ message: "Không có quyền sửa mục tiêu này hoặc không tồn tại" });
    }

    // Cập nhật
    const updated = await pool.query(
      `UPDATE goals
       SET target_amount = $1, note = $2
       WHERE goal_id = $3
       RETURNING *`,
      [target_amount, note, id]
    );

    res.json(updated.rows[0]);
  } catch (error) {
    console.error("❌ Error updating goal:", error.message);
    res.status(500).json({ error: error.message });
  }
}

