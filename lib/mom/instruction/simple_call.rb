module Mom

  # A SimpleCall is just that, a simple call. This could be called a function call too,
  # meaning we managed to resolve the function at compile time and all we have to do is
  # actually call it.
  #
  # As the call setup is done beforehand (for both simple and cached call), the
  # calling really means just jumping to the address. Simple.
  #
  class SimpleCall < Instruction
    attr_reader :method
    
    def initialize(method)
      @method = method
    end
  end

end
