ARG APP_VERSION=1.0.0
FROM scratch AS base

ADD alpine-minirootfs-3.21.3-x86_64.tar.gz /
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ARG APP_VERSION
ENV VERSION=$APP_VERSION

RUN apk update && apk add --no-cache \
    nodejs \
    npm \
    curl

FROM base AS dependencies

WORKDIR /app

COPY package.json .
RUN npm install 

# COPY . .
COPY ./src ./src
COPY ./public ./public

RUN nohup npm start & \
    sleep 3 && \
    curl -s http://localhost:3000 > index.html && \
    killall node

RUN mkdir dist && mv index.html dist/

FROM nginx:alpine

COPY --from=builder /app/dist/index.html /usr/share/nginx/html/

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s CMD \
    curl -f http://localhost:80 || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]