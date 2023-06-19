# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]

# github_changelog_generator -u afuno -p servactory --output="website/docs/CHANGELOG.md" --breaking-labels="breaking-change" --enhancement_labels="features" --bug-labels="fix"
