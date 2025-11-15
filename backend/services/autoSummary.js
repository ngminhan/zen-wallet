import pool from "../db.js";

// ---------- CATEGORY COMMENT ----------
function getCategoryComment(category) {
    switch (category) {
        case "ESSENTIAL":
            return "You spent mostly on essential expenses — good job prioritizing your needs.";
        case "NON_ESSENTIAL":
            return "Most of your spending was on non-essential items — take it slow.";
        case "SPIRITUAL":
            return "You focused on spiritual or mental well-being — that's wonderful.";
        case "UNEXPECTED":
            return "Unexpected expenses occurred — stay calm, these things happen.";
        default:
            return "No major spending category detected today.";
    }
}

// ---------- SAVING COMMENT ----------
function getSavingComment(change) {
    if (change > 0.20)
        return "You saved significantly more than yesterday — amazing!";
    if (change > 0.05)
        return "You saved more than yesterday — good job!";
    if (change > -0.05)
        return "Your savings are about the same as yesterday — steady progress.";
    if (change > -0.20)
        return "You saved less than yesterday — be mindful.";
    return "Your spending increased a lot — keep an eye on your expenses.";
}

// ---------- MAIN FUNCTION ----------
export async function getDailySummary(userId, date) {
  try {
    console.log("📌 [autoSummary] START user:", userId, "date:", date);

    // --- Today summary ---
    const todayQuery = `
      SELECT 
        COALESCE(SUM(CASE WHEN type = 'INCOME' THEN amount ELSE 0 END), 0) AS total_income,
        COALESCE(SUM(CASE WHEN type = 'EXPENSE' THEN amount ELSE 0 END), 0) AS total_expense,
        (
          SELECT category
          FROM transactions
          WHERE user_id = $1
            AND type = 'EXPENSE'
            AND DATE(created_at) = $2
          GROUP BY category
          ORDER BY SUM(amount) DESC
          LIMIT 1
        ) AS top_category
      FROM transactions
      WHERE user_id = $1 AND DATE(created_at) = $2
    `;

    const today = await pool.query(todayQuery, [userId, date]);
    console.log("📌 SQL RESULT today:", today.rows);

    const t = today.rows[0];

    const totalIncome = Number(t.total_income);
    const totalExpense = Number(t.total_expense);
    const savingToday = totalIncome - totalExpense;

    const topCategory = t.top_category;

    // --- Yesterday summary ---
    const d = new Date(date);
    d.setDate(d.getDate() - 1);
    const yDate = d.toISOString().slice(0, 10);

    const yesterdayQuery = `
      SELECT 
        COALESCE(SUM(CASE WHEN type = 'INCOME' THEN amount ELSE 0 END), 0) AS income,
        COALESCE(SUM(CASE WHEN type = 'EXPENSE' THEN amount ELSE 0 END), 0) AS expense
      FROM transactions
      WHERE user_id = $1 AND DATE(created_at) = $2
    `;

    const yesterday = await pool.query(yesterdayQuery, [userId, yDate]);
    console.log("📌 SQL RESULT yesterday:", yesterday.rows);

    const y = yesterday.rows[0];

    const savingYesterday = Number(y.income) - Number(y.expense);

    const savingChange =
      savingYesterday !== 0
        ? (savingToday - savingYesterday) / Math.abs(savingYesterday)
        : 0;

    console.log("📌 FINAL SUMMARY:", {
      totalIncome,
      totalExpense,
      topCategory,
      savingChange
    });

    // ✔ CHỈ THAY PHẦN NÀY
    return {
      total_income: totalIncome,
      total_expense: totalExpense,
      top_category: topCategory,
      comment_today: getCategoryComment(topCategory),     // dòng đã sửa
      saving_change: savingChange,
      comment_saving: getSavingComment(savingChange),     // dòng đã sửa
    };

  } catch (err) {
    console.error("❌ autoSummary ERROR:", err);
    return null;
  }
}

