import express from "express";
import { verifyToken } from "../middleware/authMiddleware.js";
import { fetchGoal, updateGoal, fetchGoalProgress } from "../controllers/goalsController.js";

const router = express.Router();

router.get("/", verifyToken, fetchGoal);
router.put("/", verifyToken, updateGoal);
router.get("/progress", verifyToken, fetchGoalProgress);

export default router;
