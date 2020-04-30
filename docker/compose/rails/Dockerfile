FROM ruby:2.7
RUN apt-get update -qq && \
	apt-get install -y nodejs postgresql-client curl imagemagick yarn
WORKDIR /srv
COPY Gemfile /srv/Gemfile
COPY Gemfile.lock /srv/Gemfile.lock
RUN bundle install --without development test
COPY . /srv

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
VOLUME ["/srv"]