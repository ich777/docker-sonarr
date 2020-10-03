FROM ich777/mono-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/sonarr"
ENV SONARR_REL="latest"
ENV START_PARAMS=""
ENV MONO_START_PARAMS="--debug"
ENV UMASK=0000
ENV DATA_PERM=770
ENV UID=99
ENV GID=100
ENV USER="sonarr"

RUN mkdir $DATA_DIR && \
	mkdir /mnt/downloads && \
    mkdir /mnt/tv && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && \
	chmod -R 770 /mnt && \
	chown -R $UID:$GID /mnt

EXPOSE 8989

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]