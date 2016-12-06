require_relative '../helper'

# Parfait test test just that, parfait.
#
# The idea is to have really really small main programs that test one very small thing
# AND return an exit code (or write stdout) that can be checked by
#  compiling and running the thing remotely
#
module ParfaitTests
  include RuntimeTests

  def setup
    @stdout =  ""
    @machine = Register.machine.boot
    Soml::Compiler.load_parfait
  end

  def main
runko = <<HERE
class Space < Object
  int main()
    PROGRAM
  end
end
HERE
  runko.sub("PROGRAM" , @main )
  end
end
