# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.5
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim-bookworm

# Rails app lives here
WORKDIR /rails

# Install packages needed to build gems
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential git curl node-gyp sqlite3

# Install JavaScript dependencies
ARG NODE_VERSION=18.15.0
ARG YARN_VERSION=latest
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
  /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
  npm install -g yarn@$YARN_VERSION && \
  rm -rf /tmp/node-build-master

# Run bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
