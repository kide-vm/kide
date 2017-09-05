
module Mom
  class WhileStatement < Instruction
    attr_reader :condition , :statements

    attr_accessor :hoisted

    def initialize( cond , statements)
      @condition = cond
      @statements = statements
    end
  end

end
