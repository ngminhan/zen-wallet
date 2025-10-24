import admin from "../firebase.js";
import pool from "../db.js";

export async function verifyToken(req, res, next) {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "Missing or invalid token" });
    }

    const idToken = authHeader.split(" ")[1];

    // ✅ 1. Xác minh token qua Firebase Admin
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const firebase_uid = decodedToken.uid;
    const email = decodedToken.email || null;
    const name = decodedToken.name || "New User";

    // ✅ 2. Kiểm tra trong database
    const userCheck = await pool.query(
      "SELECT * FROM users WHERE firebase_uid = $1",
      [firebase_uid]
    );

    // ✅ 3. Nếu user chưa tồn tại, tự thêm mới
    if (userCheck.rows.length === 0) {
      console.log(`🆕 Creating new user for Firebase UID: ${firebase_uid}`);
      await pool.query(
        `INSERT INTO users (firebase_uid, name, email)
         VALUES ($1, $2, $3)`,
        [firebase_uid, name, email]
      );
    } else {
      console.log(`👤 Existing user logged in: ${email}`);
    }

    // ✅ 4. Lưu thông tin user để route khác sử dụng
    req.user = {
      firebase_uid,
      email,
      name,
      user_id: userCheck.rows[0]?.user_id, // nếu đã có sẵn trong DB
    };

    next();
  } catch (error) {
    console.error("❌ Token verification failed:", error.message);
    res.status(401).json({ message: "Unauthorized" });
  }
}
