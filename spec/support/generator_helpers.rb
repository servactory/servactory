# frozen_string_literal: true

begin
  require "rails/generators"
  require "rails/generators/testing/behavior"
  require "rails/generators/testing/assertions"

  module GeneratorHelpers
    extend ActiveSupport::Concern

    included do
      include Rails::Generators::Testing::Behavior
      include Rails::Generators::Testing::Assertions

      destination File.expand_path("../../tmp/generators", __dir__)

      before { prepare_destination }

      after { FileUtils.rm_rf(destination_root) }
    end

    def file_content(path)
      File.read(File.join(destination_root, path))
    end
  end
rescue LoadError
  # Rails generators are not available in this environment.
  # Generator tests will be skipped.
  module GeneratorHelpers; end
end
