# Build container
FROM golang:alpine AS build

# set Go envvars
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# set code location and build app
WORKDIR /app
ADD ./src .
RUN go build -o goreportcard

# Deploy container
FROM golang:alpine
RUN useradd -M user

COPY --from=build /app/goreportcard /usr/local/bin

EXPOSE 8000

# Run as non-root user
RUN chmod 700 /usr/local/bin/app
RUN chown infra:users /usr/local/bin/app

USER user
CMD ["goreportcard"]
