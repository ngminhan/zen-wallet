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

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const quotes = JSON.parse(fs.readFileSync(path.join(__dirname, "../data/quotes.json"), "utf8"));
const questions = JSON.parse(fs.readFileSync(path.join(__dirname, "../data/questions.json"), "utf8"));

function getRandomItem(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

export const getJournal = async (req, res) => {

    console.log("getJournal() CALLED");
    console.log("URL:", req.originalUrl);
    console.log("Query date:", req.query.date);
    console.log("User:", req.user);

    try {
        const userId = req.user.user_id;
        const date = req.query.date;

        if (!userId) return res.status(400).json({ error: "Missing userId" });
        if (!date) return res.status(400).json({ error: "Missing date" });

        const journal = await getJournalByDate(userId, date);

        const autoSummary = await getDailySummary(userId, date);

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

        res.json({
            ...response,
            autoSummary: autoSummary
        });

        console.log("▶ getJournal OK — userId =", userId, "date =", date);

    } catch (error) {
        console.error("getJournal error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

export const postJournal = async (req, res) => {
    try {
        const userId = req.user.user_id;
        const data = req.body;

        if (!userId) return res.status(400).json({ error: "Missing userId" });

        const journal = await createJournal(userId, data);
        res.json(journal);

    } catch (error) {
        console.error("postJournal error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

export const putJournal = async (req, res) => {
    try {
        const userId = req.user.user_id;
        const data = req.body;

        if (!userId) return res.status(400).json({ error: "Missing userId" });

        const updated = await updateJournal(userId, data);
        res.json(updated);

    } catch (error) {
        console.error("putJournal error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

export const listJournalByMonth = async (req, res) => {
    try {
        const userId = req.user.user_id;
        const { year, month } = req.query;

        if (!userId) return res.status(400).json({ error: "Missing userId" });

        const result = await getJournalListByMonth(userId, year, month);
        res.json(result);

    } catch (error) {
        console.error("listJournalByMonth error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};
