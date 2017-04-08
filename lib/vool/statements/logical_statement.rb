module Vool
  # Logical Statements are guaranteed to return boolean
  # either :and or :or, which may be written as && and ||
  class LogicalStatement < Statement
    attr_reader :name , :left , :right

    def initialize(name , left , right)
      @name , @left , @right = name , left , right
    end

    def collect(arr)
      @receiver.collect(arr)
      @arguments.collect(arr)
      super
    end

  end
end
