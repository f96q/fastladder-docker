FROM alpine:3.7

ENV RAILS_ENV="production" \
    RUNTIME_PACKAGES="ruby ruby-irb ruby-json ruby-rake ruby-bigdecimal ruby-io-console ruby-dev nodejs libxml2-dev libxslt-dev mariadb-client-libs tzdata git libffi imagemagick" \
    DEV_PACKAGES="build-base linux-headers mariadb-dev libffi-dev"

RUN apk add --update --no-cache $RUNTIME_PACKAGES && \
    git clone https://github.com/fastladder/fastladder.git

WORKDIR /fastladder

COPY config/database.yml ./config/database.yml
COPY config/secrets.yml ./config/secrets.yml

RUN echo "gem 'activerecord-nulldb-adapter'" >> Gemfile && \
    apk add --update --virtual build-dependencies --no-cache $DEV_PACKAGES && \
    sed -i -e "s/gem 'mysql2'/gem 'mysql2', '~> 0.3.20'/" Gemfile && \
    gem install bundler --no-document && \
    gem install foreman --no-document && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install --without development test && \
    apk del build-dependencies && \
    bundle exec rake assets:precompile DATABASE_URL=nulldb://localhost SECRET_KEY_BASE=secret_key_base && \
    rm ./config/database.yml

EXPOSE 5000
CMD ["foreman", "start"]
