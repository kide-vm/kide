module Ruby
  # Send and yield are very very similar, so they have a base class CallStatement
  #
  # The SendStatement really only provides to_s, so see CallStatement
  #
  class SendStatement < CallStatement

    def to_vool
      return super unless @receiver.is_a?(ModuleName) and @receiver.name == :X
      args = @arguments.collect { |arg| arg.to_vool }
      Vool::MacroExpression.new(name , args)
    end
    def to_s(depth = 0)
      at_depth( depth , "#{receiver}.#{name}(#{arguments.join(', ')})")
    end
  end
  class SuperStatement < SendStatement
    def initialize(args)
      super(:super , SelfExpression.new , args)
    end
  end

end
