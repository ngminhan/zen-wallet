import express from "express";
import { verifyToken } from "../middleware/authMiddleware.js";
import {
  fetchOverview,
  fetchExpenseByCategory,
} from "../controllers/statisticController.js";

const router = express.Router();

router.get("/", verifyToken, fetchOverview);
router.get("/category", verifyToken, fetchExpenseByCategory);

export default router;
