module Register

  class OperatorInstruction < Instruction
    def initialize source , operator , left , right
      super(source)
      @operator = operator
      @left = left
      @right = right
    end
    attr_reader :operator, :left , :right

    def to_s
      "OperatorInstruction: #{left} #{operator} #{right}"
    end

    def self.op source , operator , left , right
      OperatorInstruction.new source , operator , left , right
    end
  end

end
