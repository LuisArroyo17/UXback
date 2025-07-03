FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o app-salud-back ./cmd/main.go

# Imagen final
FROM alpine:3.19

WORKDIR /app

COPY --from=builder /app/app-salud-back .
COPY ./internal/db/migrations ./internal/db/migrations

EXPOSE 8080

CMD ["./app-salud-back"]