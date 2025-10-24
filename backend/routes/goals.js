import express from "express";
import {
  fetchGoals,
  addGoal,
  editGoal,
} from "../controllers/goalsController.js";

const router = express.Router();

router.get("/", fetchGoals);
router.post("/", addGoal);
router.put("/:id", editGoal);

export default router;
