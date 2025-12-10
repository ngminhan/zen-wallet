import pool from "../db.js";

export async function getGoalByUser(userId, year, month) {
  const query = `
    SELECT * FROM goals
    WHERE user_id = $1 AND year = $2 AND month = $3
  `;
  const { rows } = await pool.query(query, [userId, year, month]);
  return rows[0] || null;
}

export async function upsertGoal(userId, year, month, amount) {
  const query = `
    INSERT INTO goals (user_id, year, month, amount)
    VALUES ($1, $2, $3, $4)
    ON CONFLICT (user_id, year, month)
    DO UPDATE SET amount = EXCLUDED.amount
    RETURNING *;
  `;
  const { rows } = await pool.query(query, [userId, year, month, amount]);
  return rows[0];
}

export async function getGoalProgress(userId, year, month) {
  const query = `
    WITH monthly_data AS (
      SELECT 
        COALESCE(SUM(CASE WHEN t.type = 'INCOME' THEN t.amount ELSE 0 END), 0) AS total_income,
        COALESCE(SUM(CASE WHEN t.type = 'EXPENSE' THEN t.amount ELSE 0 END), 0) AS total_expense
      FROM transactions t
      WHERE t.user_id = $1 
        AND EXTRACT(YEAR FROM t.created_at) = $2
        AND EXTRACT(MONTH FROM t.created_at) = $3
    )
    SELECT 
      md.total_income,
      md.total_expense,
      GREATEST(md.total_income - md.total_expense, 0) AS saving,
      
      COALESCE(g.amount, 0) AS goal_amount, 
      
      COALESCE(g.amount, 0) * (
          DATE_PART('day', CURRENT_DATE) /
          DATE_PART('day', DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day')
      ) AS target_pace,

      CASE 
          WHEN COALESCE(g.amount, 0) = 0 THEN 1.00 
          ELSE ROUND(
              LEAST(
                  GREATEST(
                      ((md.total_income - md.total_expense) /
                          NULLIF(
                              g.amount * (
                                  DATE_PART('day', CURRENT_DATE) /
                                  DATE_PART('day', DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day')
                              ), 0
                          )
                      )::numeric,
                      0
                  ),
                  1
              ), 2
          )
      END AS progress
      
    FROM monthly_data md
    LEFT JOIN goals g ON g.user_id = $1 
                     AND g.year = $2 
                     AND g.month = $3;
  `;

  const { rows } = await pool.query(query, [userId, year, month]);

  return rows[0] || {
    goal_amount: 0,
    total_income: 0,
    total_expense: 0,
    saving: 0,
    progress: 0,
    target_pace: 0,
  };
}