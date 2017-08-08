# This is based on itzg/minecraft-server

FROM openjdk:8-jre

MAINTAINER Dylan Kauling <gunsmithy@gmail.com>

RUN apt-get update && apt-get install -y wget unzip
RUN addgroup --gid 1000 minecraft
RUN adduser --disabled-password --home=/data --uid 1000 --gid 1000 --gecos "minecraft user" minecraft

COPY entry.sh /srv/entry.sh

WORKDIR /srv

RUN wget -c  https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-10/files/2435268/download -O server.zip && \
	unzip server.zip && \
    rm server.zip && \
    echo "eula=TRUE" > eula.txt && \
    /bin/bash FTBInstall.sh && \
    chmod +x ServerStart.sh && \
	chown -R minecraft /srv

USER minecraft

EXPOSE 25565

CMD ["/bin/bash","entry.sh"]
