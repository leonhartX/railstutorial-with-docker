FROM ruby:2.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN apt-get update -qq && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update -qq && apt-get install -y mysql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app
WORKDIR /app

ADD . /app
RUN bundle update rails
RUN bundle install

CMD rails server -p 3000 -b '0.0.0.0'
