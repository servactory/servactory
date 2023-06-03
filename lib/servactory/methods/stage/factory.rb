# frozen_string_literal: true

module Servactory
  module Methods
    module Stage
      class Factory
        def wrap_in(wrapper)
          puts "factory wrap_in wrapper #{wrapper}"

          @wrapper = wrapper
        end

        def make(name, **)
          puts "factory make #{name} in #{@wrapper}"
        end



        # def wrap_in(wrapper)
        #   code = <<-RUBY
        #       def wrap_in_#{wrapper.object_id}
        #         #{wrapper.call(methods: nil)}
        #       end
        #   RUBY
        #
        #   puts "factory wrap_in #{code}"
        #   puts "factory wrap_in collection_of_methods #{collection_of_methods}"
        # end
        #
        # def make(name, **options)
        #   collection_of_methods << Servactory::Methods::Method.new(
        #     name,
        #     position: next_position,
        #     **options
        #   )
        # end
        #
        # def next_position
        #   collection_of_methods.size + 1
        # end
        #
        # def collection_of_methods
        #   @collection_of_methods ||= Set.new
        # end
      end
    end
  end
end
