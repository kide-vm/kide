module Ruby
  # Send and yield are very very similar, so they have a base class CallStatement
  #
  # The SendStatement really only provides to_s, so see CallStatement
  #
  class SendStatement < CallStatement
    def to_s
      "#{receiver}.#{name}(#{arguments.join(', ')})"
    end
  end
end
