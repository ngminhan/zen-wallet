import {
  getUserTransactions,
  insertTransaction,
  updateTransactionById,
  deleteTransactionById,
} from "../models/transactionsModel.js";
import pool from "../db.js";

export async function fetchTransactions(req, res) {
  try {
    const userId = req.user?.user_id;
    if (!userId) return res.status(401).json({ message: "Unauthorized" });

    const transactions = await getUserTransactions(userId);
    res.json(transactions);
  } catch (error) {
    console.error("Error fetching transactions:", error.message);
    res.status(500).json({ error: error.message });
  }
}

export async function addTransaction(req, res) {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    const userId = req.user?.user_id;
    if (!userId) return res.status(401).json({ message: "Unauthorized" });

    const { type, category, amount, note, date } = req.body;

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

    let createdAt = null;
    if (date) {
      const parsedDate = new Date(date);
      if (isNaN(parsedDate)) {
        await client.query("ROLLBACK");
        return res.status(400).json({ message: "Invalid date format" });
      }
      createdAt = parsedDate.toISOString();
    }

    const transaction = await insertTransaction({
      userId,
      type,
      category,
      amount,
      note,
      createdAt,
    });

    await client.query("COMMIT");

    console.log("Transaction added:", transaction);
    res.status(201).json(transaction);
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error adding transaction:", error.message);
    res.status(500).json({ error: error.message });
  } finally {
    client.release();
  }
}

export async function updateTransaction(req, res) {
  try {
    const userId = req.user?.user_id;
    const { id } = req.params;
    if (!userId) return res.status(401).json({ message: "Unauthorized" });

    const { type, category, amount, note, date } = req.body;

    let createdAt = null;
    if (date) {
      const parsed = new Date(date);
      if (!isNaN(parsed)) createdAt = parsed.toISOString();
    }

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

    console.log("Transaction updated:", updated);
    res.json(updated);
  } catch (error) {
    console.error("Error updating transaction:", error.message);
    res.status(500).json({ error: error.message });
  }
}

export async function deleteTransaction(req, res) {
  try {
    const userId = req.user?.user_id;
    const { id } = req.params;
    if (!userId) return res.status(401).json({ message: "Unauthorized" });

    const deleted = await deleteTransactionById(userId, id);
    if (!deleted) return res.status(404).json({ message: "Transaction not found" });

    console.log(`Transaction #${id} deleted`);
    res.json({ message: "Transaction deleted successfully" });
  } catch (error) {
    console.error("Error deleting transaction:", error.message);
    res.status(500).json({ error: error.message });
  }
}
