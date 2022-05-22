FROM alpine:latest AS avr-libc-builder

RUN apk update && \
  apk --no-cache add gcc-avr alpine-sdk sudo python3 && \
  ln -s /usr/bin/python3 /usr/bin/python && \
  abuild-keygen -ain

COPY APKBUILD_avr-libc /avr-libc-git/APKBUILD
WORKDIR /avr-libc-git/
RUN abuild -F checksum && \
  abuild -rF



FROM alpine:latest

COPY --from=avr-libc-builder /root/packages/x86_64/avr-libc*.apk /tmp/avr-libc/
RUN apk --no-cache --allow-untrusted add bash perl make /tmp/avr-libc/*.apk

ENV ATTINY_DFP=/not/existing
RUN mkdir -p /src/ToyKeeper/spaghetti-monster/anduril
WORKDIR /src/ToyKeeper/spaghetti-monster/anduril
ENTRYPOINT ["./build-all.sh"]
