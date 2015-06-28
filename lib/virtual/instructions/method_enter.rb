module Virtual

  # following classes are stubs. currently in brainstorming mode, so anything may change anytime
  class MethodEnter < Instruction
    def initialize method
      @method = method
    end

    attr_reader :method
  end

end
