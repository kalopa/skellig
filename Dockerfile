FROM ruby:2.4-alpine3.6
MAINTAINER dtynan@kalopa.com

WORKDIR /skellig
ADD . .

ENTRYPOINT ["/skellig/startup.rb"]
