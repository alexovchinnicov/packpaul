FROM demo/oracle8alpine


MAINTAINER  Aleksey Ovchinnikov

# Create app directory
WORKDIR /root

# Bundle app source
COPY target/iasbp2-api.jar .

CMD [ "java", "-Xmx536870912", "-jar", "/root/iasbp2-api.jar", "--spring.cloud.consul.host=consul", "--spring.cloud.consul.port=8500" ]

