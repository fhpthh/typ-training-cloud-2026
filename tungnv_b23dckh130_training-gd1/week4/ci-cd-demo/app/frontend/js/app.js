// Fetch initial info on page load
document.addEventListener('DOMContentLoaded', () => {
  loadStudentInfo();
  loadSystemTelemetry();

  // Auto-refresh telemetry every 5 seconds
  setInterval(loadSystemTelemetry, 5000);
});

async function loadStudentInfo() {
  try {
    const res = await fetch('/api/info');
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();

    document.getElementById('student-name').textContent = data.student.fullName || 'Nguyễn Vĩnh Tùng';
    document.getElementById('student-id').textContent = data.student.studentId || 'B23DCKH130';
    document.getElementById('app-version').textContent = data.project.version || 'v1.0.0';
  } catch (err) {
    console.warn('Could not load student info from API:', err);
  }
}

async function loadSystemTelemetry() {
  try {
    const res = await fetch('/api/system');
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();

    document.getElementById('host-name').textContent = data.hostname || 'Unknown';
    document.getElementById('host-platform').textContent = `${data.platform} (${data.architecture})`;
    document.getElementById('host-memory').textContent = `${data.memoryUsageMB} MB`;
    document.getElementById('host-uptime').textContent = `${data.uptimeSeconds}s`;
    document.getElementById('node-ver').textContent = data.nodeVersion || 'v20';
  } catch (err) {
    console.warn('Could not load system telemetry:', err);
  }
}

async function testEndpoint(endpoint) {
  const resultBox = document.getElementById('api-result');
  const timeBox = document.getElementById('response-time');
  resultBox.textContent = `// Đang gửi request tới ${endpoint}...`;
  
  const startTime = performance.now();
  try {
    const res = await fetch(endpoint);
    const duration = Math.round(performance.now() - startTime);
    const json = await res.json();

    timeBox.textContent = `Thời gian: ${duration} ms (Status: ${res.status})`;
    resultBox.textContent = JSON.stringify(json, null, 2);
  } catch (err) {
    const duration = Math.round(performance.now() - startTime);
    timeBox.textContent = `Thời gian: ${duration} ms (Lỗi)`;
    resultBox.textContent = `// Lỗi gọi API: ${err.message}`;
  }
}
