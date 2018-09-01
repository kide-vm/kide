module Ruby

  # Send and yield are very very similar, so they have a base class CallStatement
  #
  # The YieldStatement really only provides to_s, and has slightly
  # different constructor. See CallStatement
  #
  class YieldStatement < CallStatement

    # We give the instance of the yield and auto generated name
    # Also, a yield is always (for now) on self
    def initialize(arguments)
      super("yield_#{object_id}".to_sym , SelfExpression.new , arguments)
    end

    def to_s
      "yield(#{arguments.join(', ')})"
    end
  end
end
