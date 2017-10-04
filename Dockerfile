FROM ruby:2.4.1

MAINTAINER Ray Johnson <ray.johnson@gmail.com>

# Install Rails library dependencies
RUN apt-get update && apt-get install -y \
  nodejs \
  postgresql-client \
  --no-install-recommends && rm -rf /var/lib/apt/lists/*

# install rails
ENV APP_HOME=/usr/src/app \
    BUNDLER_VERSION=1.15.2 \
    RAILS_ENV=production \
    RAILS_VERSION=5.1.2

RUN gem install bundler:$BUNDLER_VERSION rails:$RAILS_VERSION && \
    gem cleanup all

RUN bundle config --global frozen 1

# Set up application directory
ENV APP_PATH /wp_app
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

EXPOSE 8080

# First just copy over the Gemfile and Gemfile.lock to do the bundle install
# This is expensive and doesn't happen as often as the rest of the source changing
# and as a result typical incremental docker builds go faster.
COPY Gemfile ${APP_PATH}/Gemfile
COPY Gemfile.lock ${APP_PATH}/Gemfile.lock
RUN bundle install --jobs=8 --without development:test

# Copy source (except that mentioned in .dockerignore)
COPY . ${APP_PATH}

# Command to run
CMD bash -c 'bundle exec puma -C config/puma.rb'

