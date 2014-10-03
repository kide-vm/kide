module Virtual

  # following classes are stubs. currently in brainstorming mode, so anything may change anytime
  class MethodEnter < Instruction
  end

  class NewMessage < Instruction
  end
  class NewFrame < Instruction
  end

  class MessageSend < Instruction
    def initialize name , me , args = []
      @name = name.to_sym
      @me = me
      @args = args
    end
    attr_reader :name , :me ,  :args
  end

  class FunctionCall < Instruction
    def initialize method
      @method = method
    end
    attr_reader :method
  end

end
