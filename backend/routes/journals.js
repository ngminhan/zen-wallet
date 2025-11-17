// routes/journal.routes.js
import express from "express";
import {
  getJournal,
  postJournal,
  putJournal,
  listJournalByMonth
} from "../controllers/journalsController.js";

import { verifyToken } from "../middleware/authMiddleware.js";

const router = express.Router();

router.get("/", verifyToken, getJournal);
router.post("/", verifyToken, postJournal);
router.put("/", verifyToken, putJournal);

router.get("/list", verifyToken, listJournalByMonth);

export default router;
