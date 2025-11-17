import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import pool from "./db.js";

import authRoutes from "./routes/auth.js";
import userRoutes from "./routes/users.js";
import transactionRoutes from "./routes/transactions.js";
import goalRoutes from "./routes/goals.js";
import statisticsRoute from "./routes/statistic.js";
import journalRoutes from "./routes/journals.js";

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);
app.use("/api/transactions", transactionRoutes);
app.use("/api/goals", goalRoutes);
app.use("/api/statistic", statisticsRoute);
app.use("/api/journals", journalRoutes);

app.get("/", (req, res) => {
  res.send("ZenWallet backend is running!");
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
