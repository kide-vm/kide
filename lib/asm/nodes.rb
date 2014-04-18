module Asm

  class Node
    def initialize(s = nil)
      yield self if block_given?
    end
  end

  class ToplevelNode < Node
    attr_accessor :children
  end

  class DirectiveNode < Node
    attr_accessor :name, :value
  end

  class LabelNode < Node
    attr_accessor :name
  end

  class InstructionNode < Node
    attr_accessor :opcode, :args
  end

  class ArgNode < Node
  end

  class ShiftNode < Node
    attr_accessor :type, :value, :argument
  end

  class MathNode < Node
    attr_accessor :left, :right, :op
    alias_method :argument, :left
    alias_method :argument=, :left=
  end

  class RegisterArgNode < ArgNode
    attr_accessor :name
  end

  class RegisterListArgNode < ArgNode
    attr_accessor :registers
  end

  class NumLiteralArgNode < ArgNode
    attr_accessor :value
  end

  class NumEquivAddrArgNode < NumLiteralArgNode
  end
  class LabelRefArgNode < ArgNode
    attr_accessor :label, :label_object
  end
  class LabelEquivAddrArgNode < LabelRefArgNode
  end

  class ReferenceArgNode < ArgNode
    attr_accessor :argument
  end

  class ParseError < StandardError
    def initialize(message, s)
      super(message)
    end
  end
end
