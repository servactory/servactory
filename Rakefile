# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/extensiontask"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

# Add the compile task for the C extension
Rake::ExtensionTask.new("servactory") do |ext|
  ext.lib_dir = "lib/servactory"
  ext.ext_dir = "ext/servactory"
end

# Make sure the extension is compiled before running tests
task spec: :compile

task default: %i[spec rubocop]
