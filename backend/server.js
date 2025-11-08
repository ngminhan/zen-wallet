import express from "express";
import dotenv from "dotenv";
import pool from "./db.js"; 
import userRoutes from "./routes/users.js"; 
import transactionRoutes from "./routes/transactions.js";
import goalRoutes from "./routes/goals.js";
import cors from "cors";

dotenv.config();

const app = express();
app.use(express.json());
app.use("/transactions", transactionRoutes);
app.use("/goals", goalRoutes);
app.use(cors());

const PORT = process.env.PORT || 3000;

// Route gốc
app.get("/", (req, res) => {
  res.send("✅ ZenWallet backend is running!");
});

// Gắn route users
app.use("/users", userRoutes);

// Khởi động server
app.listen(PORT, () => {
  console.log(`🚀 Server running at http://localhost:${PORT}`);
});
