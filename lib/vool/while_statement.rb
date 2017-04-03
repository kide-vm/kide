module Vool
  class WhileStatement < Statement
    attr_accessor :condition , :statements

    def initialize( condition )
      @condition = condition
    end
  end
end
