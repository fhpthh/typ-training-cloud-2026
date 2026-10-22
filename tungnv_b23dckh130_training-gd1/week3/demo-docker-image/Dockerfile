# ==========================================
# Single-stage Dockerfile (Phiên bản cơ bản)
# ==========================================
FROM node:20.18.0-bookworm

# Thiết lập nhãn metadata
LABEL maintainer="Nguyen Vinh Tung <B23DCKH130>" \
      project="TYP Cloud Training 2026" \
      version="1.0.0" \
      description="Single-stage Dockerfile for Node.js Demo App"

# Khai báo biến môi trường
ENV NODE_ENV=production \
    PORT=3000 \
    APP_VERSION=1.0.0

# Thiết lập thư mục làm việc bên trong container
WORKDIR /app

# Tận dụng Docker Cache: Chỉ sao chép package.json trước để cài đặt thư viện
COPY package*.json ./

# Cài đặt toàn bộ dependencies (bao gồm cả devDependencies nếu không chỉ định cờ)
RUN npm install

# Sao chép toàn bộ mã nguồn ứng dụng
COPY . .

# Khai báo cổng lắng nghe
EXPOSE 3000

# Chuyển đổi sang tài khoản không đặc quyền (Security Best Practice)
USER node

# Kiểm tra tình trạng sức khỏe định kỳ của Container
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/healthz', (res) => { if (res.statusCode !== 200) process.exit(1); })"

# Khởi chạy ứng dụng (Sử dụng Exec form để bắt tín hiệu Unix Signals)
CMD ["node", "src/index.js"]
