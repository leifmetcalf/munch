const openLogFormButton = document.getElementById("open-log-form");
const closeLogFormButton = document.getElementById("close-log-form");
const logFormDialog = document.getElementById("log-form-dialog");

openLogFormButton.addEventListener("click", () => {
  logFormDialog.showModal();
});

closeLogFormButton.addEventListener("click", () => {
  logFormDialog.close();
});

