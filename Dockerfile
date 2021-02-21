FROM ruby:2.6.6

ENV APP_ROOT /app
RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

COPY . $APP_ROOT

RUN cd $APP_ROOT

RUN bundle install --without test

EXPOSE 3000

CMD ['bundle', 'exec', 'rails', 'server -b "0.0.0.0"']
