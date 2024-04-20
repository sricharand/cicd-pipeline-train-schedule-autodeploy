FROM alpine:3.16.0
RUN apk add --no-cache java-cacerts openjdk17-jdk

FROM node:carbon
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD [ "npm", "start" ]
