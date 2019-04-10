FROM codeclimate/alpine-ruby:b38

WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

RUN apk --update add nodejs npm git zlib zlib-dev ruby ruby-dev ruby-bundler less build-base && \
    bundle install -j 4 && \
    apk del --purge build-base zlib zlib-dev && rm -fr /usr/share/ri

ENV CSSLINT_SHA=87aa604a4cbc5125db979576f1b09b35980fcf08
RUN npm install -g codeclimate/csslint.git#$CSSLINT_SHA

RUN adduser -u 9000 -D app
COPY . /usr/src/app
RUN chown -R app:app /usr/src/app
USER app

CMD ["/usr/src/app/bin/csslint"]
