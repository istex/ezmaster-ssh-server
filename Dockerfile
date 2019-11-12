FROM alpine:latest

# inspired by https://github.com/arvindr226/alpine-ssh

LABEL maintainer 'Claude Niederlender <claude.niederlender@inist.fr>'

RUN apk --update add --no-cache openssh bash python nano  jq \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && rm -rf /var/cache/apk/* /tmp/*

RUN mkdir /data && mkdir /www && mkdir /app
COPY ./index.html /www/
COPY ./parse-config.sh /app/
COPY ./config.json /app/
COPY ./entrypoint-overload.sh /app/

# Then create the /etc/ezmaster.json in your docker image.
# It will tell to ezmaster where is your web server (ex: port 3000),
# where is your JSON configuration file,
# and where is your data folder
# "configType" value can be "json" or "text" depending on your config format
RUN echo '{ \
  "httpPort": 80, \
  "configPath": "/app/config.json", \
  "configType": "json", \
  "dataPath": "/data", \
  "technicalApplication": true, \
  "capabilities": "SYS_ADMIN" \
}' > /etc/ezmaster.json

EXPOSE 22 80

ENTRYPOINT ["/app/entrypoint-overload.sh"]
