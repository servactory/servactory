# frozen_string_literal: true

require "fileutils"
require "tempfile"

begin
  require "rails/generators"

  # Rails 8+ uses "behavior", Rails 7 and earlier use "behaviour"
  begin
    require "rails/generators/testing/behavior"
    GENERATOR_TESTING_BEHAVIOR = Rails::Generators::Testing::Behavior
  rescue LoadError
    require "rails/generators/testing/behaviour"
    GENERATOR_TESTING_BEHAVIOR = Rails::Generators::Testing::Behaviour
  end

  require "rails/generators/testing/assertions"

  module GeneratorHelpers
    extend ActiveSupport::Concern

    # Rails generator assertions use Minitest's assert method
    def assert(condition, message = nil)
      expect(condition).to be_truthy, message
    end

    def assert_equal(expected, actual, message = nil)
      expect(actual).to eq(expected), message
    end

    def assert_match(pattern, string, message = nil)
      expect(string).to match(pattern), message
    end

    class_methods do
      # Generator class under test
      def tests(generator)
        define_method(:generator_class) { generator }
      end
    end

    included do
      include FileUtils
      include GENERATOR_TESTING_BEHAVIOR
      include Rails::Generators::Testing::Assertions

      destination File.expand_path("../../tmp/generators", __dir__)

      before { prepare_destination }

      after { FileUtils.rm_rf(destination_root) }
    end

    def file_content(path)
      File.read(File.join(destination_root, path))
    end

    private

    # Default generator class (can be overridden with `tests` class method)
    def generator_class
      raise NotImplementedError, "Define generator class using `tests MyGenerator`"
    end
  end
rescue LoadError
  # Rails generators are not available in this environment.
  # Generator tests will be skipped.
  module GeneratorHelpers; end
end
