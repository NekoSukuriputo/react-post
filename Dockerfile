# --- Stage 1: Build React ---
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# Build project menjadi file statis (folder build/ atau dist/)
RUN npm run build

# --- Stage 2: Serve dengan Nginx ---
FROM nginx:alpine
# Hapus config default
RUN rm /etc/nginx/conf.d/default.conf
# Copy config custom kita
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Copy hasil build dari Stage 1 ke folder Nginx
# Perhatikan: Create React App biasanya output di /app/build
# Jika pakai Vite, outputnya biasanya /app/dist. Sesuaikan path di bawah ini:
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
