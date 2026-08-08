FROM debian:12-slim

RUN apt-get update -y \
    && apt-get -y install mpd tzdata \
    && apt-get clean

RUN cp /usr/share/zoneinfo/Europe/Dublin /etc/localtime \
    && echo "Europe/Dublin" > /etc/timezone

RUN mkdir -p /fifo

COPY mpd.conf /etc/mpd.conf

EXPOSE 6600

CMD ["mpd","--no-daemon","/etc/mpd.conf"]
