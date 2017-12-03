FROM ruby:2.4.2

ENV RAILS_ENV production
RUN apt-get update -qq && apt-get install -y nodejs
RUN gem install foreman
RUN git clone https://github.com/fastladder/fastladder.git
WORKDIR /fastladder
ADD config/database.yml ./config/database.yml
ADD config/secrets.yml ./config/secrets.yml
RUN echo "gem 'activerecord-nulldb-adapter'" >> Gemfile
RUN bundle install --without development test
RUN bundle exec rake assets:precompile DATABASE_URL=nulldb://localhost SECRET_KEY_BASE=secret_key_base
RUN rm ./config/database.yml

EXPOSE 5000
CMD ["/usr/local/bundle/bin/foreman", "start"]
