module Virtual


  # also the return shuffles our objects beck before actually transferring control
  class MethodReturn < Instruction
    def initialize method
      @method = method
    end

    attr_reader :method

  end

end
