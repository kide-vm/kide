module Vool
  # Logical Statements are guaranteed to return boolean
  # either :and or :or, which may be written as && and ||
  class LogicalStatement < Statement
    attr_reader :name , :left , :right

    def initialize(name , left , right)
      @name , @left , @right = name , left , right
    end

    def to_s(depth = 0)
      at_depth(depth , "#{left} #{name} #{right}")
    end

  end
end
