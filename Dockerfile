FROM ruby:3-alpine

  WORKDIR /app

  RUN gem install bundler

  COPY ./Gemfile ./Gemfile.lock /app/
  RUN apk add --no-cache make g++ musl-dev \
    && bundle install \
    && apk del make g++ musl-dev

  COPY ./*.rb /app/

  ENV PALAI_USER=
  ENV PALAI_PASSWORD=
  ENTRYPOINT [ "bundle", "exec", "./palai.rb" ]
