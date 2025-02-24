FROM python:3.13-alpine

WORKDIR /app

COPY priv priv
COPY index.html index.html

ENV PORT=6901

ENTRYPOINT python3 -m http.server -d /app $PORT
