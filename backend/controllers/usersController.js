import { getAllUsers, createUser } from "../models/usersModel.js";

export async function fetchUsers(req, res) {
  try {
    const users = await getAllUsers();
    res.json(users);
  } catch (error) {
    console.error("Error fetching users:", error);
    res.status(500).send("Internal Server Error");
  }
}

export async function addUser(req, res) {
  try {
    const { name, email } = req.body;
    if (!name || !email) {
      return res.status(400).json({ message: "Name and email are required" });
    }

    const newUser = await createUser(name, email);
    res.status(201).json(newUser);
  } catch (error) {
    console.error("Error adding user:", error);
    res.status(500).send("Internal Server Error");
  }
}
