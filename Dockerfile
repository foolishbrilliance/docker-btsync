# Dockerized BitTorrent Sync (btsync) for AWS Elastic Beanstalk
# VERSION 1.0
# forked from https://github.com/billt2006/docker-btsync

# My image with AWS CLI installed
FROM foolishbrilliance/awscli

MAINTAINER Joe Chan (@foolishbrilliance)

# Install btsync
ADD http://download-new.utorrent.com/endpoint/btsync/os/linux-x64/track/stable /usr/bin/btsync.tar.gz
RUN cd /usr/bin && tar -xzvf btsync.tar.gz && rm btsync.tar.gz
RUN mkdir -p /var/btsync/.sync

# Load custom btsync.conf from S3 via AWS CLI
RUN aws s3 cp s3://superjoeconfig/btsync/btsync.conf /etc/btsync.conf
ADD http://169.254.169.254/latest/meta-data/instance-id /tmp/instance-id
RUN sed -i "s/\(\s*\"device_name\"\s*:\s*\).*$/\1 \"$(cat /tmp/instance-id)\",\n/" /etc/btsync.conf

#
# Create script to run web server and btsync
#
RUN echo '#!'$(which bash) > /tmp/init.sh
# Run web server for Beanstalk health check
RUN echo 'while true; do echo -e "HTTP/1.1 200 OK\r\nDate: $(date)\r\n\r\nRunning as of $(date)" | nc -l 8080; done &' >> /tmp/init.sh
# Run btsync
RUN echo 'btsync --config /etc/btsync.conf --nodaemon' >> /tmp/init.sh
RUN chmod +x /tmp/init.sh

# For debugging
RUN cat /etc/btsync.conf

# For Beanstalk health check
EXPOSE 8080

CMD /tmp/init.sh
