FROM node:alpine
LABEL maintainer="Code Climate <hello@codeclimate.com>"

RUN adduser -u 9000 -D app

WORKDIR /usr/src/app

COPY package.json yarn.lock engine.json ./

RUN yarn install && \
  chown -R app:app ./ && \
  apk add --no-cache --virtual .dev-deps jq && \
  export csslint_version=$(yarn --json list --pattern csslint 2>/dev/null | jq -r '.data.trees[0].name' | cut -d@ -f2) && \
  cat engine.json | jq '.version = .version + "/" + env.csslint_version' > /engine.json && \
  apk del .dev-deps

COPY . ./

COPY . /usr/src/app

USER app

VOLUME /code
WORKDIR /code

CMD ["/usr/src/app/bin/csslint"]
