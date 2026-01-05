# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# Required for testing Rails generators locally (spec/generators/).
# Generators use Rails::Generators::Base from railties.
# In CI, Appraisal gemfiles provide railties for each Rails version (see Appraisals).
# Here we use the latest version for local development with `bundle exec rspec`.
gem "railties", "~> 8.1.0"
