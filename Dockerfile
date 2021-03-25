FROM node:alpine as build

RUN mkdir -p /data
WORKDIR /data

COPY ./package.json /data/package.json
RUN npm install

COPY ./static-server.js /data/
COPY ./firmware  /data/firmware

## Release image
FROM node:alpine

RUN mkdir -p /data

COPY --from=build /data /data

WORKDIR /data

EXPOSE 8443

CMD ["node", "/data/static-server.js"]
