module Risc

  class OperatorInstruction < Instruction
    def initialize source , operator , left , right
      super(source)
      @operator = operator
      @left = left
      @right = right
    end
    attr_reader :operator, :left , :right

    def to_s
      class_source "#{left} #{operator} #{right}"
    end

  end
  def self.op source , operator , left , right
    OperatorInstruction.new source , operator , left , right
  end

end
