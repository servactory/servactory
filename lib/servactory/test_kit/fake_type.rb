# frozen_string_literal: true

module Servactory
  module TestKit
    # Dummy class used as a type mismatch value in tests.
    #
    # ## Purpose
    #
    # FakeType is an empty class that doesn't match any expected service
    # input types. It's used by ValidWithSubmatcher to test type validation
    # by providing a value guaranteed to fail type checks.
    #
    # ## Usage
    #
    # Used internally by valid_with tests:
    #
    # ```ruby
    # # In valid_with submatcher
    # prepared_attributes[attribute_name] = Servactory::TestKit::FakeType.new
    # # This triggers type validation failure
    # ```
    #
    # ## Note
    #
    # The class is intentionally empty - its sole purpose is to be a type
    # that doesn't match String, Integer, Hash, Array, or any other type
    # that a service might expect.
    class FakeType; end # rubocop:disable Lint/EmptyClass
  end
end
