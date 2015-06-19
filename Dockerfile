FROM mhart/alpine-node

WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

RUN npm install -g csslint && \
    apk --update add ruby ruby-dev ruby-bundler less ruby-nokogiri build-base && \
    bundle install -j 4 && \
    apk del build-base && rm -fr /usr/share/ri

COPY . /usr/src/app

CMD ["/usr/src/app/bin/csslint"]
