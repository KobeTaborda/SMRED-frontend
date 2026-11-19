# Imagen del frontend de SMRED. Primera etapa: compila React con Vite. Segunda: nginx sirve dist/.
# En el despliegue principal se usa Vercel (vercel.json); este Dockerfile es el plan B en un contenedor.

FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
# Valores por defecto; en Render se cambian en Environment
ENV PORT=80 \
    API_URL=https://smred-backend.onrender.com \
    API_HOST=smred-backend.onrender.com
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
