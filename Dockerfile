FROM ruby:latest
COPY convert.rb .
COPY Gemfile .
COPY Gemfile.lock .
ADD . .
RUN bundle install
ENTRYPOINT ["ruby", "convert.rb"]
