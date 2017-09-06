module Mom
  class IfStatement < Statement
    attr_reader :condition , :if_true , :if_false

    attr_accessor :hoisted

    def initialize( cond , if_true , if_false = nil)
      @condition = cond
      @if_true = if_true
      @if_false = if_false
    end
  end

end
