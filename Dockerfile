FROM golang as builder
RUN mkdir -p /build/bin
ADD . /build/
RUN ls -al /build/
WORKDIR /build
RUN GO111MODULE=on go build -o bin/turn-client turn-client/main.go
RUN GO111MODULE=on go build -o bin/turn-server turn-server/main.go

FROM alpine
RUN adduser -S -D -H -h /app appuser
USER appuser
COPY --from=builder /build/bin/* /app/
WORKDIR /app
CMD ["./turn-server"]
