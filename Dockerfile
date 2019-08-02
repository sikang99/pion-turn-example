FROM alpine
MAINTAINER Stoney Kang <sikang99@gmail.com>

RUN adduser -S -D -H -h /app appuser
USER appuser
COPY * /app/
WORKDIR /app
RUN ls -al .
ENV PIONS_LOG_INFO=all USERS=stoney=kang REALM=teamgrit UDP_PORT=3478 CHANNEL_BIND_TIMEOUT=100ms
CMD ["./turn-server"]
