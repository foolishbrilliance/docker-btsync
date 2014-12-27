# BitTorrent Sync
# VERSION 0.2
# forked from https://github.com/billt2006/docker-btsync

FROM foolishbrilliance/awscli

MAINTAINER Joe Chan (@foolishbrilliance)

# Download and extract the executable to /usr/bin
ADD http://download-new.utorrent.com/endpoint/btsync/os/linux-x64/track/stable /usr/bin/btsync.tar.gz
RUN cd /usr/bin && tar -xzvf btsync.tar.gz && rm btsync.tar.gz
RUN mkdir -p /var/btsync/.sync

# Load btsync config from S3 via AWS CLI
RUN aws s3 cp s3://superjoeconfig/btsync/btsync.conf /etc/btsync.conf
RUN cat /etc/btsync.conf

# Commented out because I don't use the WebGUI
# Web GUI
EXPOSE 80
# Listening port
EXPOSE 55555

ENTRYPOINT ["btsync"]
CMD ["--config", "/etc/btsync.conf", "--nodaemon"]
