// controllers/journal.controller.js
import {
    getJournalByDate,
    createJournal,
    updateJournal,
    getJournalListByMonth
} from "../models/journalsModel.js";

import { getDailySummary } from "../services/autoSummary.js";

import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

// __dirname fix
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load JSON
const quotes = JSON.parse(fs.readFileSync(path.join(__dirname, "../data/quotes.json"), "utf8"));
const questions = JSON.parse(fs.readFileSync(path.join(__dirname, "../data/questions.json"), "utf8"));

function getRandomItem(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

// GET /journal?date=YYYY-MM-DD
export const getJournal = async (req, res) => {

    console.log("🔥 getJournal() CALLED");
    console.log("URL:", req.originalUrl);
    console.log("Query date:", req.query.date);
    console.log("User:", req.user);

    try {
        const userId = req.user.user_id;   // ← FIXED
        const date = req.query.date;

        if (!userId) return res.status(400).json({ error: "Missing userId" });
        if (!date) return res.status(400).json({ error: "Missing date" });

        // Fetch today's journal entry
        const journal = await getJournalByDate(userId, date);

        // Auto Summary for the day
        const autoSummary = await getDailySummary(userId, date);

        // Build response
        const response = journal
            ? {
                date: journal.date,
                quote: journal.quote,
                question: journal.question,
                answer: journal.answer,
                rate: journal.rate,
                note: journal.note
            }
            : {
                date,
                quote: getRandomItem(quotes),
                question: getRandomItem(questions),
                answer: null,
                rate: null,
                note: null
            };

        // Final output
        res.json({
            ...response,
            autoSummary: autoSummary   // ← FIXED to camelCase
        });

        console.log("▶ getJournal OK — userId =", userId, "date =", date);

    } catch (error) {
        console.error("❌ getJournal error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

// POST /journal
export const postJournal = async (req, res) => {
    try {
        const userId = req.user.user_id;  // ← FIXED
        const data = req.body;

        if (!userId) return res.status(400).json({ error: "Missing userId" });

        const journal = await createJournal(userId, data);
        res.json(journal);

    } catch (error) {
        console.error("❌ postJournal error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

// PUT /journal
export const putJournal = async (req, res) => {
    try {
        const userId = req.user.user_id; // ← FIXED
        const data = req.body;

        if (!userId) return res.status(400).json({ error: "Missing userId" });

        const updated = await updateJournal(userId, data);
        res.json(updated);

    } catch (error) {
        console.error("❌ putJournal error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

// GET /journal/list
export const listJournalByMonth = async (req, res) => {
    try {
        const userId = req.user.user_id; // ← FIXED
        const { year, month } = req.query;

        if (!userId) return res.status(400).json({ error: "Missing userId" });

        const result = await getJournalListByMonth(userId, year, month);
        res.json(result);

    } catch (error) {
        console.error("❌ listJournalByMonth error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};
