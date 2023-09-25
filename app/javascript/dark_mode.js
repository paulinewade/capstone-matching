document.addEventListener("DOMContentLoaded", function() {
  const darkModeToggle = document.getElementById("dark-mode-toggle");
  const htmlElement = document.documentElement;

  // Check for a stored dark mode preference
  const isDarkMode = localStorage.getItem("darkMode") === "true";

  // Apply dark mode class if the preference is set
  if (isDarkMode) {
    htmlElement.classList.add("dark-mode");
  }

  darkModeToggle.addEventListener("click", () => {
    // Toggle the dark mode class
    htmlElement.classList.toggle("dark-mode");

    // Update the preference in localStorage
    const newMode = htmlElement.classList.contains("dark-mode");
    localStorage.setItem("darkMode", newMode.toString());
  });
});

  