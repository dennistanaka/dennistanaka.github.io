FROM ruby:2.7.2

RUN gem install bundler:1.16.2

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

ARG USER_ID
ARG GROUP_ID

RUN mkdir /app
ENV APP_ROOT /app
ENV BUNDLE_PATH /home/appuser/.local/bundle
WORKDIR $APP_ROOT

RUN groupadd appuser && useradd -g appuser -m -d /home/appuser appuser

RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    usermod -u $USER_ID appuser &&\
    groupmod -g $GROUP_ID appuser\
;fi

COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install

COPY . $APP_ROOT

RUN chown -R appuser:appuser $APP_ROOT $BUNDLE_PATH /usr/local/bundle/config

USER appuser
