BitTorrent Sync Dockerfile and Dockerrun.aws.json for AWS Elastic Beanstalk
==========================

## Beanstalk Instructions

* upload `btsync.conf` to S3
* modify `Dockerfile` with custom `btsync.conf` S3 Path
* zip `Dockerfile` and `Dockerrun.aws.json`
* Deploy .zip to AWS Elastic Beanstalk per  http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_console.html
