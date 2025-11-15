// models/journal.model.js
import pool from "../db.js";

export const getJournalByDate = async (userId, date) => {
  const query = `
    SELECT * FROM journals
    WHERE user_id = $1 AND date = $2
  `;
  const result = await pool.query(query, [userId, date]);
  return result.rows[0] || null;
};

export const createJournal = async (userId, data) => {
  const query = `
    INSERT INTO journals (user_id, date, quote, rate, question, answer, note)
    VALUES ($1, $2, $3, $4, $5, $6, $7)
    RETURNING *
  `;
  const params = [
    userId,
    data.date,
    data.quote,
    data.rate,
    data.question,
    data.answer,
    data.note
  ];
  const result = await pool.query(query, params);
  return result.rows[0];
};

export const updateJournal = async (userId, data) => {
  const query = `
    UPDATE journals
    SET quote = $3,
        rate = $4,
        question = $5,
        answer = $6,
        note = $7,
        updated_at = NOW()
    WHERE user_id = $1 AND date = $2
    RETURNING *
  `;

  const params = [
    userId,
    data.date,
    data.quote,
    data.rate,
    data.question,
    data.answer,
    data.note
  ];

  const result = await pool.query(query, params);
  return result.rows[0];
};

export const getJournalListByMonth = async (userId, year, month) => {
  const query = `
    SELECT journal_id, date, rate
    FROM journals
    WHERE user_id = $1
      AND EXTRACT(YEAR FROM date) = $2
      AND EXTRACT(MONTH FROM date) = $3
    ORDER BY date ASC
  `;
  const result = await pool.query(query, [userId, year, month]);
  return result.rows;
};
