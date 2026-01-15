const button = document.getElementById("analyzeBtn")
const input = document.getElementById("ipInput")
const result = document.getElementById("result")
const status = document.getElementById("status")

const API_URL = "http://backend:8080";

button.addEventListener("click", async () => {
  const ip = input.value.trim()

  if (!ip) {
    status.textContent = "Please enter an IP address"
    return
  }

  status.textContent = "Analyzing..."
  result.textContent = ""

  try {
    const response = await fetch(`${API_URL}?ip=${ip}`)
    const data = await response.json()

    status.textContent = "Analysis complete"
    result.textContent = JSON.stringify(data, null, 2)
  } catch (error) {
    status.textContent = "Failed to fetch data"
    console.error(error)
  }
})
