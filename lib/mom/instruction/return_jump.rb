module Mom

  # the return jump jumps to the return label
  # the method setup is such that there is exactly one return_label in a method
  # This is so the actual code that executes the return can be quite complicated
  # and big, and won't be repeated
  #
  class ReturnJump < Instruction

    def to_risc(compiler)
      compiler.add_code Risc::Branch.new(self , compiler.return_label)
    end
  end


end
