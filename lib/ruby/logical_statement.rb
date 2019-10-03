module Ruby
  # Logical Statements are guaranteed to return boolean
  # either :and or :or, which may be written as && and ||
  #
  # Also they guarantee that the right expression does not get evaluated
  # if the whole expression fails on the left expression.
  # ie: false && non_existant_method
  # will never call the non_existant_method , but instead evaluate to false
  #
  # Sol has no concept of this, so the Statement is expanded into the if
  # that it really is
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
