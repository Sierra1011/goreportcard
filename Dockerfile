# Build container
FROM golang:1.19-alpine AS build

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
FROM golang:1.19-alpine
RUN useradd -M user

COPY --from=base /app/goreportcard /usr/local/bin

EXPOSE 8000

USER user
CMD ["goreportcard"]
