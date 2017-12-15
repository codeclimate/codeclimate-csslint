FROM node:alpine

RUN adduser -u 9000 -D app

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn install && \
  chown -R app:app ./

COPY . ./

USER app

COPY . /usr/src/app

CMD ["/usr/src/app/bin/csslint"]
