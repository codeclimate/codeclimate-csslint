FROM codeclimate/alpine-ruby:b38

WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

RUN apk --update add nodejs git zlib zlib-dev ruby ruby-dev ruby-bundler less build-base && \
    bundle install -j 4 && \
    apk del --purge build-base zlib zlib-dev && rm -fr /usr/share/ri

ENV CSSLINT_SHA=0e7aeadd02f5babca5152993374043f9f736a116
RUN npm install -g codeclimate/csslint.git#$CSSLINT_SHA

RUN adduser -u 9000 -D app
USER app

COPY . /usr/src/app

CMD ["/usr/src/app/bin/csslint"]
