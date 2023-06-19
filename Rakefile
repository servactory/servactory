# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

require "github_changelog_generator/task"

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = "afuno"
  config.project = "servactory"
  config.output = "website/docs/CHANGELOG.md"
  config.enhancement_labels = %w[features breaking-change]
  # config.breaking_labels = %w[breaking-change]
  config.bug_labels = %w[fix]
end

task default: %i[spec rubocop]
