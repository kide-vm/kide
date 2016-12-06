require_relative '../helper'

# Fragments are small programs that we run through the interpreter and really only check
# - the no. of instructions processed
# - the stdout output

module Fragments
  include RuntimeTests

  # define setup to NOT load parfait.
  def setup
    @stdout =  ""
    @machine = Register.machine.boot
  end

  def main()
    @string_input
  end

end
