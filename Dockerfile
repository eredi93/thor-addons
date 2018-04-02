FROM ruby:2.5.1

ENV WORKDIR /thor-addons

WORKDIR $WORKDIR

COPY . ./

RUN bundle install
