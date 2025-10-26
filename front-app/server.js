import express from "express";
import { createServer } from "http";
import { Server } from "socket.io";
import { createClient } from "redis";

const app = express();
const server = createServer(app);
const io = new Server(server);

app.use(express.static("public"));

// --- Connexion Redis ---
const redis = createClient();
await redis.connect();

// --- Chargement initial des données ---
let formData = { nom: "", prenom: "", email: "" };
const savedData = await redis.get("formData");
if (savedData) formData = JSON.parse(savedData);

// --- WebSocket ---
io.on("connection", (socket) => {
  console.log("Nouvel utilisateur connecté");

  // Envoi des données actuelles au nouveau client
  socket.emit("formUpdate", formData);

  // Quand un utilisateur modifie le formulaire
  socket.on("fieldChange", async ({ field, value }) => {
    formData[field] = value;
    await redis.set("formData", JSON.stringify(formData));

    // Diffusion à tous les autres clients
    socket.broadcast.emit("formUpdate", formData);
  });
});

server.listen(3000, () => console.log("Serveur en écoute sur http://localhost:3000"));
