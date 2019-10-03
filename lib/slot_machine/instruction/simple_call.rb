module Mom

  # A SimpleCall is just that, a simple call. This could be called a function call too,
  # meaning we managed to resolve the function at compile time and all we have to do is
  # actually call it.
  #
  # As the call setup is done beforehand (for both simple and cached call), the
  # calling really means mostly jumping to the address. Simple.
  #
  class SimpleCall < Instruction
    attr_reader :method

    def initialize(method)
      @method = method
    end

    def to_s
      "SimpleCall #{@method.name}"
    end

    # Calling a Method is basically jumping to the Binary (+ offset).
    # We just swap in the new message and go.
    #
    # For returning, we add a label after the call, and load it's address into the
    # return_address of the next_message, for the ReturnSequence to pick it up.
    def to_risc(compiler)
      method = @method
      return_label = Risc.label(self,"continue_#{object_id}")
      compiler.build("SimpleCall") do
        return_address! << return_label
        next_message! << message[:next_message]
        next_message[:return_address] << return_address
        message << message[:next_message]
        add_code Risc::FunctionCall.new("SimpleCall", method )
        add_code return_label
      end
    end

  end

end
