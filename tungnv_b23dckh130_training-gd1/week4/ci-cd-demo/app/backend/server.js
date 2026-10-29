const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const os = require('node:os');

const PORT = Number(process.env.PORT || 3000);
const APP_VERSION = process.env.APP_VERSION || '1.0.0';
const FRONTEND_DIR = path.join(__dirname, '../frontend');

// MIME types mapping
const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
};

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  const pathname = url.pathname;

  // Logging
  console.log(`[${new Date().toISOString()}] ${req.method} ${pathname}`);

  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    return res.end();
  }

  // API 1: Healthcheck endpoint (dùng cho Docker HEALTHCHECK & Jenkins Smoke Test)
  if (pathname === '/healthz') {
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    return res.end(JSON.stringify({
      status: 'healthy',
      service: 'docker-cloud-demo',
      version: APP_VERSION,
      timestamp: new Date().toISOString(),
      uptimeSeconds: Math.floor(process.uptime())
    }));
  }

  // API 2: Thông tin sinh viên & đề tài
  if (pathname === '/api/info') {
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    return res.end(JSON.stringify({
      student: {
        fullName: 'Nguyễn Vĩnh Tùng',
        studentId: 'B23DCKH130',
        program: 'TYP Cloud Training 2026'
      },
      project: {
        name: 'Hệ thống CI/CD tự động: Jenkins + Docker + Ansible + DevSecOps',
        description: 'Đóng gói ứng dụng Full-Stack, quét bảo mật Gitleaks & Trivy, triển khai Ansible lên Target VM',
        version: APP_VERSION
      }
    }));
  }

  // API 3: Thông số hạ tầng hệ thống
  if (pathname === '/api/system') {
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    return res.end(JSON.stringify({
      hostname: os.hostname(),
      platform: os.platform(),
      architecture: os.arch(),
      release: os.release(),
      nodeVersion: process.version,
      memoryUsageMB: Math.round(process.memoryUsage().rss / 1024 / 1024),
      uptimeSeconds: Math.floor(os.uptime())
    }));
  }

  // Phục vụ Frontend Static Files
  let filePath = pathname === '/' 
    ? path.join(FRONTEND_DIR, 'index.html') 
    : path.join(FRONTEND_DIR, pathname);

  // Chống Directory Traversal
  const safePath = path.normalize(filePath);
  if (!safePath.startsWith(FRONTEND_DIR)) {
    res.writeHead(403, { 'Content-Type': 'application/json; charset=utf-8' });
    return res.end(JSON.stringify({ error: 'Forbidden' }));
  }

  fs.stat(safePath, (err, stats) => {
    if (err || !stats.isFile()) {
      res.writeHead(404, { 'Content-Type': 'application/json; charset=utf-8' });
      return res.end(JSON.stringify({ error: 'Not Found', path: pathname }));
    }

    const ext = path.extname(safePath).toLowerCase();
    const contentType = MIME_TYPES[ext] || 'application/octet-stream';

    res.writeHead(200, { 'Content-Type': contentType });
    const readStream = fs.createReadStream(safePath);
    readStream.pipe(res);
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`=======================================================`);
  console.log(` Backend & Frontend Web Server running on port ${PORT}`);
  console.log(` Healthcheck endpoint: http://0.0.0.0:${PORT}/healthz`);
  console.log(` Student API endpoint: http://0.0.0.0:${PORT}/api/info`);
  console.log(` Web Dashboard UI:    http://0.0.0.0:${PORT}/`);
  console.log(`=======================================================`);
});
