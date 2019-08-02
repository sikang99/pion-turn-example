FROM golang as builder
MAINTAINER Stoney Kang <sikang99@gmail.com>

# build turn client and server programs
RUN mkdir -p /build/bin
ADD . /build/
RUN ls -al /build/
WORKDIR /build
ENV GO111MODULE=on
RUN go build -o bin/turn-client turn-client/main.go
RUN go build -o bin/turn-server turn-server/main.go

# make a run image with programs
FROM alpine
RUN adduser -S -D -H -h /app appuser
USER appuser
COPY --from=builder /build/bin/* /app/
WORKDIR /app
CMD ["./turn-server"]
