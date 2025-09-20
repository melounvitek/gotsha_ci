# frozen_string_literal: true

module Gotsha
  module Errors
    class HardFail < StandardError; end
    class SoftFail < StandardError; end
  end
end
