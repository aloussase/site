FROM golang:alpine AS build

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app

COPY . .
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o server .

FROM alpine
COPY --from=build /app/server /server

ENV PORT=3000

ENTRYPOINT ["/server"]
