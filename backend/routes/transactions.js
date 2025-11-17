import express from "express";
import {
  fetchTransactions,
  addTransaction,
  updateTransaction,
  deleteTransaction,
} from "../controllers/transactionsController.js";
import { verifyToken } from "../middleware/authMiddleware.js";

const router = express.Router();

router.get("/", verifyToken, fetchTransactions);
router.post("/", verifyToken, addTransaction);
router.put("/:id", verifyToken, updateTransaction);
router.delete("/:id", verifyToken, deleteTransaction);

export default router;
