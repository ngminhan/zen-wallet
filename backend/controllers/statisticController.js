import {
    getOverviewByMonth,
    getExpenseByCategoryMonth,
} from "../models/statisticModel.js";

export async function fetchOverview(req, res) {
    try {
        const userId = req.user?.user_id;
        const { year, month } = req.query;

        if (!userId) return res.status(401).json({ message: "Unauthorized" });
        if (!year || !month) {
            return res.status(400).json({ message: "Missing year or month" });
        }

        const data = await getOverviewByMonth(userId, year, month);
        res.json({
            year: Number(year),
            month: Number(month),
            data
        });


    } catch (err) {
        console.error("❌ Error fetching overview:", err.message);
        res.status(500).json({ error: err.message });
    }
}

export async function fetchExpenseByCategory(req, res) {
    try {
        const userId = req.user?.user_id;
        const { year, month } = req.query;

        if (!userId) return res.status(401).json({ message: "Unauthorized" });
        if (!year || !month) {
            return res.status(400).json({ message: "Missing year or month" });
        }

        const data = await getExpenseByCategoryMonth(userId, year, month);
        const total = data.reduce((sum, row) => sum + row.total_amount, 0);

        const formatted = data.map((item) => ({
            category: item.category,
            amount: item.total_amount,
            percentage: total > 0 ? (item.total_amount / total) * 100 : 0,
        }));

        res.json({
            year: Number(year),
            month: Number(month),
            total,
            data: formatted
        });


    } catch (err) {
        console.error("❌ Error fetching category stats:", err.message);
        res.status(500).json({ error: err.message });
    }
}
