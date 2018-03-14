module Mom

  # Preamble when entering the method body.
  # Acquiring the message basically.
  #
  # Currently messages are hardwired as a linked list,
  # but this does not account for continuations or closures and
  # so will have to be changed.
  #
  # With the current setup this maps to a single SlotMove, ie 2 risc Instructions
  # But clearer this way.
  #
  class MessageSetup < Instruction
    attr_reader :method

    def initialize(method)
        @method = method
    end

    def to_risc(compiler)
      Risc::Label.new(self,"MethodSetup") 
    end

  end


end
