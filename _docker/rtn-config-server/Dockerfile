#FROM openjdk:8u222-jdk-alpine
FROM openjdk:14-jdk-alpine

MAINTAINER  Aleksey Ovchinnikov

# Create app directory
WORKDIR /root

# Bundle app source
COPY rtn-config-server/target/rtn-config-server.jar .
COPY rtn-infrastructure-config/iasbp2-api-dev.yml ./rtn-infrastructure-config/


EXPOSE 8080
CMD [ "java", "-Xmx268435456", "-jar", "/root/rtn-config-server.jar", "--server.port=8080", "--spring.cloud.consul.host=consul", "--spring.cloud.consul.port=8500", "--spring.cloud.config.server.git.uri=file:rtn-infrastructure-config", "--spring.cloud.config.label=local" ]

