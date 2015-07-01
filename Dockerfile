FROM alpine:edge

WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

RUN apk --update add nodejs git ruby ruby-dev ruby-bundler less ruby-nokogiri build-base && \
    npm install -g codeclimate/csslint.git#2a53712c61710840c023978418c7b48e3f32ac64 && \
    bundle install -j 4 && \
    apk del build-base && rm -fr /usr/share/ri

RUN adduser -u 9000 -D app
USER app

COPY . /usr/src/app

CMD ["/usr/src/app/bin/csslint"]
