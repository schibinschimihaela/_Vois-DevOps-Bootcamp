const API_URL = "PLACEHOLDER_API_URL";

const result = document.getElementById("result");
const status = document.getElementById("status");

if (!result || !status) {
  console.error("UI elements not found");
}


function setStatus(text) {
  status.textContent = text;
}

function clearUI() {
  result.innerHTML = "";
  setStatus("");
}

function showResult(data) {
  result.innerHTML = `<pre>${JSON.stringify(data, null, 2)}</pre>`;
}


async function scanIP() {
  clearUI();
  setStatus("🔍 Scanning current IP...");

  try {
    const res = await fetch(`${API_URL}/scan`);
    const data = await res.json();
    showResult(data);
    setStatus(" Scan complete");
  } catch (e) {
    setStatus(" Scan failed");
  }
}

async function viewLogs() {
  clearUI();
  setStatus(" Loading logs...");

  try {
    const res = await fetch(`${API_URL}/logs`);
    const data = await res.json();

    if (data.length === 0) {
      showResult({ message: "No logs found" });
      return;
    }

    let table = `<table>
      <tr>
        <th>Timestamp</th>
        <th>IP</th>
        <th>City</th>
        <th>Country</th>
        <th>ISP</th>
      </tr>`;

    data.forEach(row => {
      table += `
        <tr>
          <td>${row.timestamp}</td>
          <td>${row.ip}</td>
          <td>${row.city}</td>
          <td>${row.country}</td>
          <td>${row.isp}</td>
        </tr>`;
    });

    table += `</table>`;
    result.innerHTML = table;
    setStatus(" Logs loaded");
  } catch (e) {
    setStatus(" Failed to load logs");
  }
}

async function purgeLogs() {
  clearUI();
  setStatus(" Purging logs...");

  try {
    const res = await fetch(`${API_URL}/logs`, { method: "DELETE" });
    const data = await res.json();
    showResult(data);
    setStatus(" Logs deleted");
  } catch (e) {
    setStatus(" Purge failed");
  }
}

async function awsStatus() {
  clearUI();
  setStatus(" Checking AWS status...");

  try {
    const res = await fetch(`${API_URL}/aws/status`);
    const data = await res.json();
    showResult(data);
    setStatus(" AWS connected");
  } catch (e) {
    setStatus(" AWS status failed");
  }
}

function showHelp() {
  clearUI();
  result.innerHTML = `
    <ul>
      <li><b>Scan IP</b> – detect current public IP</li>
      <li><b>View Logs</b> – show DynamoDB logs</li>
      <li><b>Purge Logs</b> – delete all records</li>
      <li><b>AWS Status</b> – check IAM identity</li>
    </ul>
  `;
  setStatus(" Help");
}
