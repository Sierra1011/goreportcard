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
FROM golang:bullseye
RUN useradd -M user

COPY --from=build /app/goreportcard /usr/local/bin
RUN mkdir /usr/local/badger
RUN chown user:users /usr/local/badger

EXPOSE 8000

# Run as non-root user
RUN chmod 700 /usr/local/bin/goreportcard
RUN chown user:users /usr/local/bin/goreportcard

USER user
CMD ["goreportcard"]
