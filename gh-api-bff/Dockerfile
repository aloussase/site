FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app

COPY go.mod .
COPY go.sum .
COPY main.go .
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o server .

FROM alpine
COPY --from=build /app/server /server

ENV GH_API_BFF_ACCESS_TOKEN=
ENV PORT=3000

ENTRYPOINT ["/server"]
