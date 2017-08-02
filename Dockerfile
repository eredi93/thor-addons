FROM ruby:2.3.3

ENV WORKDIR /thor-addons

WORKDIR $WORKDIR

COPY . ./

RUN bundle install
