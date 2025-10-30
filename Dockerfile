# Stage 1: Build
FROM node:16.17.0-alpine as builder
WORKDIR /app

# Installer les dépendances
COPY package*.json ./
RUN npm install

# Copier le reste du code et build
COPY . .
ARG TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"
RUN npm run build

# Stage 2: Nginx
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/dist .
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
