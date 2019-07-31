FROM node:10-alpine

MAINTAINER  Aleksey Ovchinnikov

# Create app directory
WORKDIR /root/checklist-ui

# Bundle app source
COPY . .
RUN npm install

EXPOSE 4200
CMD [ "npm", "run", "dev" ]
