module Virtual


  # MethodCall involves shuffling some registers about and doing a machine call
  class MethodCall < Instruction
    def initialize method
      @method = method
    end
    attr_reader :method
  end

end
