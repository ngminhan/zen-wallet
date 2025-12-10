import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import pool from "../db.js";

export const signup = async (req, res) => {
    try {
        const { name, email, password } = req.body;

        if (!name || !email || !password)
            return res.status(400).json({ message: "Missing required fields" });

        const existingUser = await pool.query("SELECT * FROM users WHERE email = $1", [email]);
        if (existingUser.rows.length > 0)
            return res.status(400).json({ message: "Email already registered" });

        const hashed = await bcrypt.hash(password, 10);
        const result = await pool.query(
            "INSERT INTO users (name, email, password_hash) VALUES ($1, $2, $3) RETURNING user_id, name, email",
            [name, email, hashed]
        );

        const token = jwt.sign(
            { user_id: result.rows[0].user_id },
            process.env.JWT_SECRET,
            { expiresIn: "7d" }
        );

        res.json({ ...result.rows[0], token });
    } catch (error) {
        console.error("Signup error:", error);
        res.status(500).json({ error: error.message });
    }
};

export const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        const userResult = await pool.query("SELECT * FROM users WHERE email = $1", [email]);
        if (userResult.rows.length === 0)
            return res.status(400).json({ message: "Invalid email or password" });

        const user = userResult.rows[0];
        const isValid = await bcrypt.compare(password, user.password_hash);
        if (!isValid)
            return res.status(400).json({ message: "Invalid email or password" });

        const token = jwt.sign(
            { user_id: user.user_id },
            process.env.JWT_SECRET,
            { expiresIn: "7d" }
        );

        res.json({
            user_id: user.user_id,
            name: user.name,
            email: user.email,
            token
        });

    } catch (error) {
        console.error("Login error:", error);
        res.status(500).json({ error: error.message });
    }
};
