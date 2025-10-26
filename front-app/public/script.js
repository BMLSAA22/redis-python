const socket = io();

// Recevoir les mises à jour depuis le serveur
socket.on("formUpdate", (data) => {
  for (const [field, value] of Object.entries(data)) {
    const input = document.getElementById(field);
    if (input && input.value !== value) input.value = value;
  }
});

// Envoyer les changements au serveur
document.querySelectorAll("input").forEach((input) => {
  input.addEventListener("input", () => {
    socket.emit("fieldChange", { field: input.id, value: input.value });
  });
});
