# frozen_string_literal: true

module Wrong
  class Example8 < ApplicationService::Base
    input :ids, type: Array, array: true
  end
end
