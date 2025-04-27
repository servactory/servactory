# frozen_string_literal: true

require "zeitwerk"

lib_dir = File.expand_path("../..", __dir__)

loader = Zeitwerk::Loader.new

loader.tag = "servactory"

loader.inflector = Zeitwerk::GemInflector.new(
  File.expand_path("servactory.rb", lib_dir)
)

loader.inflector.inflect("dsl" => "DSL")

loader.ignore(__dir__)

loader.push_dir(lib_dir)

loader.setup
