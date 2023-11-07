FROM alpine:3.15 AS avr-libc-builder

RUN apk update \
  && apk --no-cache add gcc-avr alpine-sdk sudo python3 \
  && ln -s /usr/bin/python3 /usr/bin/python \
  && abuild-keygen -ain

COPY APKBUILD_avr-libc /avr-libc-git/APKBUILD
WORKDIR /avr-libc-git/
RUN abuild -F checksum \
  && abuild -rF



FROM alpine:3.15

RUN --mount=from=avr-libc-builder,source=/root/packages,target=/packages \
  apk --no-cache --allow-untrusted add bash perl make /packages/*/avr-libc*.apk

WORKDIR /src
ENTRYPOINT ["./make"]
