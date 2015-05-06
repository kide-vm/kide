module Virtual

  class MessageSend < Instruction
    def initialize name , me , args = []
      @name = name.to_sym
      @me = me
      @args = args
    end
    attr_reader :name , :me ,  :args
  end

end
