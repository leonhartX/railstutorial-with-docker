FROM ruby:2.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN apt-get update -qq && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update -qq && apt-get install -y mysql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /app
WORKDIR /app

ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN bundle install

ADD . /app
CMD rails server -p 3000 -b '0.0.0.0'

