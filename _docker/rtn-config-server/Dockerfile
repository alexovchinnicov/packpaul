FROM demo/oracle8alpine


MAINTAINER  Aleksey Ovchinnikov

# Create app directory
WORKDIR /root

# Bundle app source
COPY target/rtn-config-server.jar .


EXPOSE 8080
CMD [ "java", "-Xmx268435456", "-jar", "/root/rtn-config-server.jar", "--server.port=8080", "--spring.cloud.consul.host=consul", "--spring.cloud.consul.port=8500", "--spring.cloud.config.server.git.uri=file:rtn-infrastructure-config", "--spring.cloud.config.label=local" ]

