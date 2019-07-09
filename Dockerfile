FROM alpine:latest

# inspired by https://github.com/arvindr226/alpine-ssh

LABEL maintainer 'Claude Niederlender <claude.niederlender@inist.fr>'

RUN apk --update add --no-cache openssh bash python nano \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && rm -rf /var/cache/apk/* /tmp/*

RUN mkdir /data && mkdir /www && mkdir /app
COPY ./index.html /www/
COPY ./parse-config.sh /app/
COPY ./config.json /app/
COPY ./entrypoint-overload.sh /app/

EXPOSE 22 80

ENTRYPOINT ["/app/entrypoint-overload.sh"]