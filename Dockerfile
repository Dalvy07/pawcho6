# syntax=docker/dockerfile:1.4

ARG APP_VERSION=1.0.0
FROM dalvy07/alpine-minimal:3.21.3 AS builer

ARG APP_VERSION
ENV VERSION=$APP_VERSION

RUN apk update && apk add --no-cache \
    nodejs \
    npm \
    curl \
    git \
    openssh-client

# RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

WORKDIR /app

# RUN --mount=type=ssh git clone git@github.com:Dalvy07/pawcho6.git

COPY package.json ./

RUN npm install

COPY . .

RUN nohup npm start & \
    sleep 3 && \
    curl -s http://localhost:3000 > index.html && \
    killall node

RUN mkdir dist && mv index.html dist/

FROM nginx:alpine

COPY --from=builer /app/dist/index.html /usr/share/nginx/html/

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s CMD \
    curl -f http://localhost:80 || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]