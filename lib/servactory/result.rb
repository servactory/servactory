# frozen_string_literal: true

module Servactory
  # Result object returned from Servactory service calls.
  #
  # ## Purpose
  #
  # Result provides a unified interface for handling service outcomes.
  # Supports both success and failure states with dynamic output attribute access.
  #
  # ## Usage
  #
  # Results are typically obtained from service calls:
  #
  # ```ruby
  # result = MyService.call(name: "John")
  #
  # if result.success?
  #   puts result.user  # Access output attribute
  # else
  #   puts result.error.message
  # end
  # ```
  #
  # ## Callback Chains
  #
  # Results support fluent callback chains:
  #
  # ```ruby
  # MyService.call(arguments)
  #   .on_success { |outputs:| redirect_to(outputs[:user]) }
  #   .on_failure(:validation) { |exception:| render_errors(exception) }
  #   .on_failure { |exception:| log_error(exception) }
  # ```
  #
  # ## Predicate Methods
  #
  # When `predicate_methods_enabled` is configured, outputs support
  # boolean predicates:
  #
  # ```ruby
  # result.active?  # Equivalent to Utils.query_attribute(result.active)
  # ```
  class Result
    # Internal container for service output values.
    #
    # Provides dynamic method access to output values.
    # Stores outputs in hash and supports predicate methods when enabled.
    class Outputs
      # Creates an Outputs container with given output values.
      #
      # @param outputs [Hash<Symbol, Object>] Output name-value pairs from warehouse
      # @param predicate_methods_enabled [Boolean] Enable predicate methods (e.g., user?)
      # @return [Outputs] New outputs container
      def initialize(outputs:, predicate_methods_enabled:)
        @outputs = outputs
        @predicate_methods_enabled = predicate_methods_enabled
      end

      # Returns string representation for debugging.
      #
      # @return [String] Formatted output values
      def inspect
        "#<#{self.class.name} #{draw_result}>"
      end

      # Delegates method calls to stored outputs.
      def method_missing(name, *args)
        if name.to_s.end_with?("?")
          base_name = name.to_s.chomp("?").to_sym
          if @predicate_methods_enabled && @outputs.key?(base_name)
            return Servactory::Utils.query_attribute(@outputs[base_name])
          end
        elsif @outputs.key?(name)
          return @outputs[name]
        end

        super
      end

      # Checks if method corresponds to stored output.
      def respond_to_missing?(name, include_private = false)
        if name.to_s.end_with?("?")
          base_name = name.to_s.chomp("?").to_sym
          return true if @predicate_methods_enabled && @outputs.key?(base_name)
        elsif @outputs.key?(name)
          return true
        end

        super
      end

      private

      # Returns array of output attribute names.
      #
      # @return [Array<Symbol>] Output names without predicates
      def output_names
        @outputs.keys
      end

      # Returns array of predicate method names.
      #
      # @return [Array<Symbol>] Predicate names (e.g., [:user?, :token?])
      def predicate_names
        return [] unless @predicate_methods_enabled

        @outputs.keys.map { |key| :"#{key}?" }
      end

      # Builds formatted string of output values.
      #
      # @return [String] Comma-separated output representations
      def draw_result
        (output_names + predicate_names).sort.map do |method_name|
          "@#{method_name}=#{public_send(method_name)}"
        end.join(", ")
      end
    end

    private_constant :Outputs

    ############################################################################

    # Creates a success result for the given context.
    #
    # @param context [Object] Service execution context with outputs
    # @return [Result] Success result with outputs accessible
    #
    # @example
    #   Result.success_for(context: service_context)
    def self.success_for(context:)
      new(context:, success: true)
    end

    # Creates a failure result for the given context.
    #
    # @param context [Object] Service execution context
    # @param exception [Exception] Failure exception with type and message
    # @return [Result] Failure result with error accessible
    #
    # @example
    #   Result.failure_for(context: ctx, exception: error)
    def self.failure_for(context:, exception:)
      new(context:, exception:, success: false)
    end

    # Initializes a Result instance.
    #
    # @param context [Object] Service execution context
    # @param exception [Exception, nil] Failure exception (nil for success)
    # @param success [Boolean] Success state flag
    def initialize(context:, exception: nil, success: true)
      @context = context
      @exception = exception
      @success = success
    end

    # Returns whether the service call succeeded.
    #
    # @return [Boolean] True if successful
    #
    # @example
    #   result.success? # => true
    def success?
      @success
    end

    # Returns whether the service call failed.
    #
    # Supports filtering by failure type when called with argument.
    #
    # @param type [Symbol] Failure type to check (default: :all matches any failure)
    # @return [Boolean] True if failed (optionally matching type)
    #
    # @example Check any failure
    #   result.failure? # => true
    #
    # @example Check specific failure type
    #   result.failure?(:validation) # => true
    #   result.failure?(:non_existent) # => false
    def failure?(type = :all)
      return false if @success

      [:all, @exception&.type].include?(type)
    end

    # Returns the failure exception.
    #
    # @return [Exception, nil] Exception for failures, nil for success
    #
    # @example
    #   result.error # => #<Servactory::Exceptions::Failure>
    #   result.error.message # => "Validation failed"
    def error
      @exception
    end

    # Converts outputs to hash.
    #
    # Excludes predicate methods from the result hash.
    #
    # @return [Hash<Symbol, Object>] Output name-value pairs
    #
    # @example
    #   result.to_h # => { user: #<User>, token: "abc123" }
    def to_h
      outputs.send(:output_names).each_with_object({}) do |key, hash|
        value = outputs.public_send(key)
        hash[key] = value unless value.nil?
      end
    end

    # Pattern matching support.
    #
    # Returns hash of result state and output values for use with case/in.
    # State keys (:success, :failure, :error) take priority over output names.
    #
    # @param keys [Array<Symbol>, nil] Keys to include, or nil for all
    # @return [Hash<Symbol, Object>] Hash of state and outputs for pattern matching
    #
    # @example Basic matching
    #   case result
    #   in { success: true, user: }
    #     redirect_to user
    #   in { failure: true }
    #     render :error
    #   end
    #
    # @example Matching with error details
    #   case result
    #   in { failure: true, error: { type: :validation, message: } }
    #     flash[:error] = message
    #   end
    def deconstruct_keys(keys)
      available = { success: success?, failure: failure? }
      available[:error] = error if failure?

      outputs.send(:output_names).each do |name|
        available[name] = outputs.public_send(name)
      end

      return available if keys.nil?

      available.slice(*keys)
    end

    # Returns string representation for debugging.
    #
    # @return [String] Formatted result state and outputs
    def inspect
      "#<#{self.class.name} #{draw_result}>"
    end

    # Executes block if result is success.
    #
    # Supports method chaining for fluent API.
    #
    # @yield [outputs:] Block to execute on success
    # @yieldparam outputs [Outputs] Container with output values
    # @return [self] For chaining
    #
    # @example
    #   result.on_success { |outputs:| puts outputs.user.name }
    def on_success
      yield(outputs:) if success?

      self
    end

    # Executes block if result is failure.
    #
    # Supports filtering by failure type and method chaining.
    #
    # @param type [Symbol] Failure type to match (default: :all matches any failure)
    # @yield [outputs:, exception:] Block to execute on failure
    # @yieldparam outputs [Outputs] Container with output values
    # @yieldparam exception [Exception] Failure exception
    # @return [self] For chaining
    #
    # @example Handle any failure
    #   result.on_failure { |exception:| log(exception.message) }
    #
    # @example Handle specific failure type
    #   result.on_failure(:validation) { |exception:| show_errors(exception) }
    def on_failure(type = :all)
      yield(outputs:, exception: @exception) if failure? && [:all, @exception&.type].include?(type)

      self
    end

    # Delegates method calls to the outputs container.
    #
    # @param name [Symbol] Method name (output attribute)
    # @param args [Array] Method arguments
    # @param block [Proc] Optional block
    # @return [Object] Output value when name matches an output attribute
    # @raise [NoMethodError] When method is truly undefined and no context present
    def method_missing(name, *args, &block)
      return outputs.public_send(name, *args, &block) if outputs.respond_to?(name)

      super
    rescue NoMethodError => e
      rescue_no_method_error_with(exception: e)
    end

    # Checks if method corresponds to output attribute.
    #
    # @param name [Symbol] Method name to check
    # @param include_private [Boolean] Include private methods in check
    # @return [Boolean] True if output exists
    def respond_to_missing?(name, include_private = false)
      outputs.respond_to?(name, include_private) || super
    end

    private

    # Builds formatted string of result state and outputs.
    #
    # @return [String] Comma-separated result representations
    def draw_result # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      result_parts = []

      result_parts << "@success?=#{success?}"
      result_parts << "@failure?=#{failure?}"
      result_parts << "@error=#{@exception}" if @exception

      outputs.send(:output_names).each do |method_name|
        result_parts << "@#{method_name}=#{outputs.public_send(method_name)}"
      end

      outputs.send(:predicate_names).each do |method_name|
        result_parts << "@#{method_name}=#{outputs.public_send(method_name)}"
      end

      result_parts.sort.join(", ")
    end

    # Returns outputs container, lazily initialized.
    #
    # @return [Outputs] Outputs container with service values
    def outputs
      @outputs ||= build_outputs
    end

    # Builds Outputs container with predicate configuration.
    #
    # @return [Outputs] New outputs container
    def build_outputs
      Outputs.new(
        outputs: build_outputs_hash,
        predicate_methods_enabled:
          @context.is_a?(Servactory::TestKit::Result) || @context.config.predicate_methods_enabled
      )
    end

    # Builds hash from warehouse outputs object.
    #
    # @return [Hash<Symbol, Object>] Output name-value pairs
    def build_outputs_hash
      hash = {}
      @context.send(:servactory_service_warehouse).outputs.each_pair do |key, value|
        hash[key] = value
      end
      hash
    end

    ########################################################################

    # Wraps NoMethodError with contextual failure.
    #
    # Converts undefined method errors to Servactory failure exceptions
    # with localized error messages.
    #
    # @param exception [NoMethodError] Original exception
    # @raise [Exception] Wrapped failure exception with context
    def rescue_no_method_error_with(exception:) # rubocop:disable Metrics/MethodLength
      raise exception if @context.blank? || @context.instance_of?(Servactory::TestKit::Result)

      raise @context.config.failure_class.new(
        type: :base,
        message: @context.send(:servactory_service_info).translate(
          "common.undefined_method.missing_name",
          error_text: exception.message
        ),
        meta: {
          original_exception: exception
        }
      )
    end
  end
end
