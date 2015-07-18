module Virtual

  # This starts the Virtual machine machine at the given function.

  # The implementation is most likely a jump/branch , but since we have the extra layer
  # we make good use of it, ie give things descriptive names (what they do, not how)

  class VirtualMain < Instruction
    include Positioned

    def initialize method
      @method = method
    end
    attr_reader :method
    def word_length
      4
    end

    def to_s
      "#{self.class.name}( method: #{method.name})"
    end
  end
end
