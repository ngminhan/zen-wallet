import express from "express";
import { verifyToken } from "../middleware/authMiddleware.js";
import { fetchGoal, updateGoal, fetchGoalProgress } from "../controllers/goalsController.js";

const router = express.Router();

// /api/goals → lấy hoặc update goal
router.get("/", verifyToken, fetchGoal);
router.put("/", verifyToken, updateGoal);

// /api/goals/progress → lấy tiến độ tiết kiệm
router.get("/progress", verifyToken, fetchGoalProgress);

export default router;
