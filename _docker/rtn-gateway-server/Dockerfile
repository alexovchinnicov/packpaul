FROM demo/oracle8alpine


MAINTAINER  Aleksey Ovchinnikov

# Create app directory
WORKDIR /root

# Bundle app source
COPY target/rtn-gateway-server.jar .


#EXPOSE 8200
CMD [ "java", "-Xmx134217728", "-jar", "/root/rtn-gateway-server.jar", "--spring.cloud.consul.host=consul", "--spring.cloud.consul.port=8500" ]

