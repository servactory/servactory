# frozen_string_literal: true

module Wrong
  class Example35Child < ApplicationService::Base
    make :method_fail!

    private

    def method_fail!
      fail!(message: "Some error", meta: { some: :data })
    end
  end

  class Example35 < ApplicationService::Base
    make :child_fail!

    private

    def child_fail!
      service_result = Example35Child.call

      fail_result!(service_result) if service_result.failure?
    end
  end
end
