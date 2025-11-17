import { getGoalByUser, upsertGoal, getGoalProgress } from "../models/goalsModel.js";

export async function fetchGoal(req, res) {
  try {
    const userId = req.user?.user_id;
    const year = parseInt(req.query.year);
    const month = parseInt(req.query.month);

    if (!userId) return res.status(401).json({ message: "Unauthorized" });
    if (!year || !month) return res.status(400).json({ message: "Missing year or month" });

    const goal = await getGoalByUser(userId, year, month);
    if (!goal) {
      return res.json({
        goal_id: 0,
        user_id: userId,
        year,
        month,
        amount: 0,
        created_at: null
      });
    }

    res.json(goal);
  } catch (error) {
    console.error("Error fetching goal:", error.message);
    res.status(500).json({ error: error.message });
  }
}

export async function updateGoal(req, res) {
  try {
    const userId = req.user?.user_id;
    if (!userId) return res.status(401).json({ message: "Unauthorized" });

    const year = parseInt(req.body.year);
    const month = parseInt(req.body.month);
    const amount = Number(req.body.amount);

    if (!year || !month) return res.status(400).json({ message: "Missing year or month" });

    const updated = await upsertGoal(userId, year, month, amount);
    res.json(updated);
  } catch (error) {
    console.error("Error updating goal:", error.message);
    res.status(500).json({ error: error.message });
  }
}

export async function fetchGoalProgress(req, res) {
  try {
    const userId = req.user?.user_id;
    const year = parseInt(req.query.year);
    const month = parseInt(req.query.month);

    if (!userId) return res.status(401).json({ message: "Unauthorized" });
    if (!year || !month) return res.status(400).json({ message: "Missing year or month" });

    const progress = await getGoalProgress(userId, year, month);
    res.json(progress);
  } catch (error) {
    console.error("Error fetching goal progress:", error.message);
    res.status(500).json({ error: error.message });
  }
}
