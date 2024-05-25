# Node.js image as base
FROM node:20-alpine as build 

WORKDIR /app
COPY package*.json ./
RUN npm i --force
COPY . .
RUN npm run build

# Stage 2: Serve the built files with NGINX
FROM nginx:alpine
COPY ./Devops/nginx.conf /temp/prod.conf
#RUN envsubst /app < /temp/prod.conf > /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]