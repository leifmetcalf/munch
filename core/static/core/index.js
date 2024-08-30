const logButton = document.getElementById("open-log-button");
const closeButton = document.getElementById("close-log-button");
const logForm = document.getElementById("log-form");

logButton.addEventListener("click", () => {
  logForm.showModal();
});

cancelButton.addEventListener("click", () => {
  logForm.close();
});

