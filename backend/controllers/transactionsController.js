import {
  getUserTransactions,
  insertTransaction,
  updateTransactionById,
  deleteTransactionById,
} from "../models/transactionsModel.js";
import pool from "../db.js";

/**
 * ✅ Lấy danh sách giao dịch của user
 */
export async function fetchTransactions(req, res) {
  try {
    const userId = req.user?.user_id;
    if (!userId) return res.status(401).json({ message: "Unauthorized" });

    const transactions = await getUserTransactions(userId);
    res.json(transactions);
  } catch (error) {
    console.error("❌ Error fetching transactions:", error.message);
    res.status(500).json({ error: error.message });
  }
}

/**
 * ✅ Thêm transaction mới (có hỗ trợ date từ iOS)
 */
export async function addTransaction(req, res) {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    const userId = req.user?.user_id;
    if (!userId) return res.status(401).json({ message: "Unauthorized" });

    const { type, category, amount, note, date } = req.body;

    // 🧩 Validate cơ bản
    if (!type || !["INCOME", "EXPENSE"].includes(type)) {
      await client.query("ROLLBACK");
      return res.status(400).json({ message: "Invalid transaction type" });
    }
    if (!amount || isNaN(amount)) {
      await client.query("ROLLBACK");
      return res.status(400).json({ message: "Invalid amount" });
    }
    if (type === "EXPENSE" && !category) {
      await client.query("ROLLBACK");
      return res.status(400).json({ message: "Missing category for expense" });
    }

    // ✅ Chuẩn hóa date: nếu client không gửi → dùng NOW()
    let createdAt = null;
    if (date) {
      const parsedDate = new Date(date);
      if (isNaN(parsedDate)) {
        await client.query("ROLLBACK");
        return res.status(400).json({ message: "Invalid date format" });
      }
      createdAt = parsedDate.toISOString(); // chuyển sang UTC ISO để PostgreSQL hiểu
    }

    // 🗃️ Thêm transaction vào DB
    const transaction = await insertTransaction({
      userId,
      type,
      category,
      amount,
      note,
      createdAt, // truyền thêm vào model
    });

    await client.query("COMMIT");

    console.log("✅ Transaction added:", transaction);
    res.status(201).json(transaction);
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("❌ Error adding transaction:", error.message);
    res.status(500).json({ error: error.message });
  } finally {
    client.release();
  }
}

/**
 * ✅ Sửa transaction
 */
export async function updateTransaction(req, res) {
  try {
    const userId = req.user?.user_id;
    const { id } = req.params;
    if (!userId) return res.status(401).json({ message: "Unauthorized" });

    const { type, category, amount, note, date } = req.body;

    // ✅ Parse lại createdAt nếu có
    let createdAt = null;
    if (date) {
      const parsed = new Date(date);
      if (!isNaN(parsed)) createdAt = parsed.toISOString();
    }

    // ✅ Nếu chuyển sang INCOME thì bỏ category
    let finalCategory = category;
    if (type === "INCOME") {
      finalCategory = null;
    }

    const updated = await updateTransactionById(userId, id, {
      type,
      category: finalCategory,
      amount,
      note,
      createdAt,
    });

    if (!updated) return res.status(404).json({ message: "Transaction not found" });

    console.log("✏️ Transaction updated:", updated);
    res.json(updated);
  } catch (error) {
    console.error("❌ Error updating transaction:", error.message);
    res.status(500).json({ error: error.message });
  }
}


/**
 * ✅ Xoá transaction
 */
export async function deleteTransaction(req, res) {
  try {
    const userId = req.user?.user_id;
    const { id } = req.params;
    if (!userId) return res.status(401).json({ message: "Unauthorized" });

    const deleted = await deleteTransactionById(userId, id);
    if (!deleted) return res.status(404).json({ message: "Transaction not found" });

    console.log(`🗑️ Transaction #${id} deleted`);
    res.json({ message: "Transaction deleted successfully" });
  } catch (error) {
    console.error("❌ Error deleting transaction:", error.message);
    res.status(500).json({ error: error.message });
  }
}
