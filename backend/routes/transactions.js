import express from "express";
import {
  fetchTransactions,
  addTransaction,
  getStats,
} from "../controllers/transactionsController.js";
import { verifyToken } from "../middlewares/authMiddleware.js";

const router = express.Router();

router.use(verifyToken);

router.get("/", fetchTransactions);
router.post("/", addTransaction);
router.get("/stats", getStats);

export default router;
