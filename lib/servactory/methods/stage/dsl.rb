# frozen_string_literal: true

module Servactory
  module Methods
    module Stage
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
        end

        # stage start
        # factory wrap_in wrapper #<Proc:0x0000000106306e28 /Users/profox/Projects/GitHub/afuno/servactory/examples/usual/example37.rb:19 (lambda)>
        # factory make assign_number_5 in #<Proc:0x0000000106306e28 /Users/profox/Projects/GitHub/afuno/servactory/examples/usual/example37.rb:19 (lambda)>
        # factory make assign_number_6 in #<Proc:0x0000000106306e28 /Users/profox/Projects/GitHub/afuno/servactory/examples/usual/example37.rb:19 (lambda)>
        # factory make assign_number_7 in #<Proc:0x0000000106306e28 /Users/profox/Projects/GitHub/afuno/servactory/examples/usual/example37.rb:19 (lambda)>
        # stage end
        # stage start
        # factory wrap_in wrapper #<Proc:0x0000000106306ab8 /Users/profox/Projects/GitHub/afuno/servactory/examples/usual/example37.rb:27 (lambda)>
        # factory make assign_number_5 in #<Proc:0x0000000106306ab8 /Users/profox/Projects/GitHub/afuno/servactory/examples/usual/example37.rb:27 (lambda)>
        # factory make assign_number_6 in #<Proc:0x0000000106306ab8 /Users/profox/Projects/GitHub/afuno/servactory/examples/usual/example37.rb:27 (lambda)>
        # factory make assign_number_7 in #<Proc:0x0000000106306ab8 /Users/profox/Projects/GitHub/afuno/servactory/examples/usual/example37.rb:27 (lambda)>
        # stage end

        module ClassMethods
          private

          def stage(&block)
            puts "stage start"
            # puts "stage block #{block}"
            # puts "stage block #{block.__id__}"
            # puts "stage block #{block.object_id}"

            @stage_factory ||= Factory.new

            @stage_factory.instance_eval(&block)

            # instance_eval(&block)
            puts "stage end"
          end
        end
      end
    end
  end
end
