const express = require('express');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 3000;
const APP_VERSION = process.env.APP_VERSION || '1.0.0';

// Middleware logging request
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    status: 'success',
    message: 'TYP Cloud Training 2026 - Docker Image & Dockerfile Demo',
    student: {
      name: 'Nguyen Vinh Tung',
      studentId: 'B23DCKH130'
    },
    system: {
      hostname: os.hostname(),
      platform: os.platform(),
      architecture: os.arch(),
      uptimeSeconds: Math.floor(os.uptime()),
      memoryUsageMB: Math.round(process.memoryUsage().rss / 1024 / 1024)
    },
    version: APP_VERSION
  });
});

// Healthcheck endpoint for Docker HEALTHCHECK
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Start server
const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`Application running on http://0.0.0.0:${PORT}`);
  console.log(`Process ID (PID): ${process.pid}`);
});

// Handle graceful shutdown signals
process.on('SIGTERM', () => {
  console.log('Received SIGTERM signal. Performing graceful shutdown...');
  server.close(() => {
    console.log('HTTP server closed successfully. Process exiting.');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('Received SIGINT signal (Ctrl+C). Performing graceful shutdown...');
  server.close(() => {
    console.log('HTTP server closed successfully. Process exiting.');
    process.exit(0);
  });
});
