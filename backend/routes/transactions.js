import express from "express";
import {
  fetchTransactions,
  addTransaction,
  getStats,
} from "../controllers/transactionsController.js";

const router = express.Router();


router.get("/", fetchTransactions);
router.post("/", addTransaction);
router.get("/stats", getStats);

export default router;
