const API = "http://backend:8080"
const out = document.getElementById("output")
const loader = document.getElementById("loader")

function showLoader(show) {
  loader.classList.toggle("hidden", !show)
}

function clearUI() {
  out.innerHTML = ""
}

function showJSON(data) {
  out.innerHTML = `<pre>${JSON.stringify(data, null, 2)}</pre>`
}

async function scan() {
  showLoader(true)
  clearUI()
  const res = await fetch(`${API}/scan`)
  showJSON(await res.json())
  showLoader(false)
}

async function awsStatus() {
  showLoader(true)
  clearUI()
  const res = await fetch(`${API}/aws/status`)
  showJSON(await res.json())
  showLoader(false)
}

async function showHelp() {
  showJSON({
    commands: [
      "Scan Current IP",
      "View Logs",
      "Purge Logs",
      "AWS Status",
      "Help",
      "Exit"
    ]
  })
}

async function viewLogs() {
  showLoader(true)
  clearUI()
  const res = await fetch(`${API}/logs`)
  const logs = await res.json()

  if (!logs.length) {
    out.textContent = "No logs found."
    showLoader(false)
    return
  }

  let html = `<table>
    <tr>
      <th>Timestamp</th>
      <th>IP</th>
      <th>City</th>
      <th>Country</th>
      <th>ISP</th>
    </tr>`

  logs.forEach(l => {
    html += `
      <tr>
        <td>${l.timestamp}</td>
        <td>${l.ip}</td>
        <td>${l.city}</td>
        <td>${l.country}</td>
        <td>${l.isp}</td>
      </tr>`
  })

  html += "</table>"
  out.innerHTML = html
  showLoader(false)
}

async function purgeLogs() {
  if (!confirm("DELETE ALL LOGS?")) return
  showLoader(true)
  clearUI()
  const res = await fetch(`${API}/logs`, { method: "DELETE" })
  showJSON(await res.json())
  showLoader(false)
}
