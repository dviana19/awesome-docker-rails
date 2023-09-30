# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim

# Rails app lives here
WORKDIR /rails

# Install packages needed to build gems
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config curl gnupg2 postgresql-client nano nodejs npm

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN npm install --global yarn

# Copy application code
COPY . .

RUN bundle install
RUN gem install foreman

# Entrypoint prepares the database.
ENTRYPOINT ["sh", "/rails/entrypoint.sh"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
