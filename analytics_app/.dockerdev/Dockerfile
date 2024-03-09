FROM ruby:3.3-slim AS base

ARG RUBYGEMS_VERSION=3.4.16
ARG BUNDLER_VERSION=2.4.16

WORKDIR /code

ENV LANG=C.UTF-8 \
    BUNDLE_RETRY=3 \
    EDITOR=vim

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -yqq  \
      build-essential \
      git \
      vim \
      lsb-release \
      wget \
      gnupg2 \
      libpq-dev \
      libsqlite3-dev && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get -y update && \
    apt-get install --no-install-recommends -yqq postgresql-15 && \
    gem update --system ${RUBYGEMS_VERSION} && \
    gem install bundler -v ${BUNDLER_VERSION}
