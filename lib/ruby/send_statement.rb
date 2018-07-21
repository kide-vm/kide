module Ruby

  class SendStatement < Callable
    def to_s
      "#{receiver}.#{name}(#{arguments.join(', ')})"
    end
  end
end
