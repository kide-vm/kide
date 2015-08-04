module Register

  class OperatorInstruction < Instruction
    def initialize source , operator , left , right
      super(source)
      @operator = operator
      @left = left
      @right = right
    end
    attr_reader :left , :right

    def to_s
      "OperatorInstruction: #{left} #{operator} #{right}"
    end

  end

end
