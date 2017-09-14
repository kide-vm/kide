module Mom

  # A dynamic call calls a method at runtime. This off course implies that we don't know the
  # method at compile time and so must "find" it. Resolving, or finding the method, is a
  # a seperate step though, and here we assume there is a Method instance in some variable
  #
  # The only argument given is the variable's name.
  # The instruction thus load the variable, finds the jump address from it and jumps there
  # (ie calls). Calls are after all just jumps with the intent to return. Return addresses
  # are setup in the preamble.
  #
  # As a side note: All argument setup/handling is outside the scope of this Instruction
  # and assumed to be done beforehand.
  # Also, in an ideal world we would check that the variable actually holds a Method
  # but at the momeent we just assume it.
  #
  class DynamicCall < Instruction
    attr_reader :method_var_name

    def initialize(method_var_name)
      @method_var_name = method_var_name
    end
  end

end
