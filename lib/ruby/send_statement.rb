module Ruby

  class SendStatement < CallStatement
    def to_s
      "#{receiver}.#{name}(#{arguments.join(', ')})"
    end
  end
end
