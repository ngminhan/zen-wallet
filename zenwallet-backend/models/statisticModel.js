import pool from "../db.js";

export async function getOverviewByMonth(userId, year, month) {
  const query = `
    SELECT 
      DATE(created_at) AS date,
      COALESCE(SUM(CASE WHEN type='INCOME' THEN amount END),0)::float8 AS income,
      COALESCE(SUM(CASE WHEN type='EXPENSE' THEN amount END),0)::float8 AS expense
    FROM transactions
    WHERE user_id = $1
      AND EXTRACT(YEAR FROM created_at) = $2
      AND EXTRACT(MONTH FROM created_at) = $3
    GROUP BY DATE(created_at)
    ORDER BY DATE(created_at);
  `;

  const result = await pool.query(query, [userId, year, month]);

  return result.rows.map((r) => ({
    bucket: r.date,
    income: r.income,
    expense: r.expense,
    balance: r.income - r.expense,
  }));
}

export async function getExpenseByCategoryMonth(userId, year, month) {
  const query = `
    SELECT 
      category,
      COALESCE(SUM(amount), 0)::float8 AS total_amount
    FROM transactions
    WHERE user_id = $1
      AND type = 'EXPENSE'
      AND EXTRACT(YEAR FROM created_at) = $2
      AND EXTRACT(MONTH FROM created_at) = $3
    GROUP BY category
    ORDER BY total_amount DESC;
  `;

  const result = await pool.query(query, [userId, year, month]);
  return result.rows;
}
