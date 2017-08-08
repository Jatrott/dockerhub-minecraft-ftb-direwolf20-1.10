# This is based on itzg/minecraft-server

FROM openjdk:8-jre

LABEL org.freenas.interactive="false" 		\
      org.freenas.version="Latest (Auto Update)"		\
      org.freenas.upgradeable="true"		\
      org.freenas.expose-ports-at-host="true"	\
      org.freenas.autostart="true"		\
      org.freenas.port-mappings="25565:25565/tcp"			\
      org.freenas.volumes="[					\
          {							\
              \"name\": \"/data\",				\
              \"descr\": \"Minecraft server directory\"		\
          }							\
      ]"							\
      org.freenas.settings="[ 					\
          {							\
              \"env\": \"MOTD\",					\
              \"descr\": \"Server Message of the Day\",		\
              \"optional\": true				\
          },							\
          {							\
              \"env\": \"JVM_OPTS\",			\
              \"descr\": \"-Xms4096m -Xmx4096m\",	\
              \"optional\": true				\
          },							\
          {							\
              \"env\": \"LEVEL\",			\
              \"descr\": \"world\",			\
              \"optional\": true				\
          } 							\
      ]"

MAINTAINER Dylan Kauling <gunsmithy@gmail.com>

RUN apt-get update && apt-get install -y wget unzip
RUN addgroup --gid 1234 minecraft
RUN adduser --disabled-password --home=/data --uid 1234 --gid 1234 --gecos "minecraft user" minecraft

RUN mkdir /tmp/feed-the-beast && cd /tmp/feed-the-beast && \
	wget -c  https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-10/files/2435268/download -O FTBDirewolf20Server.zip && \
	unzip FTBDirewolf20Server.zip && \
	rm FTBDirewolf20Server.zip && \
	bash -x FTBInstall.sh && \
	chown -R minecraft /tmp/feed-the-beast


USER minecraft

EXPOSE 25565

ADD start.sh /start

VOLUME /data
ADD server.properties /tmp/server.properties
WORKDIR /data

CMD /start

ENV MOTD A Minecraft (FTB Presents Direwolf20-1.12.1-1.10.2) Server Powered by Docker
ENV LEVEL world
ENV JVM_OPTS -Xms4096m -Xmx4096m
