module Vool
  class ReturnStatement < Statement
    attr_accessor :return_value

    def initialize(value)
      @return_value = value
    end
  end
end
