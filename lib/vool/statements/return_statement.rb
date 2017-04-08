module Vool
  class ReturnStatement < Statement
    attr_reader :return_value

    def initialize(value)
      @return_value = value
    end

    def collect(arr)
      @return_value.collect(arr)
      super
    end
  end
end
