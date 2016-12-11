require_relative '../../typed/helper'

# Benchmarks for the stuff in results.md

module BenchTests

  include RuntimeTests

  def setup
    @stdout =  ""
    @machine = Register.machine.boot
    # Typed::Compiler.load_parfait
    # most interesting parts saved as interger/word .soml in this dir
  end

  def main
runko = <<HERE
class Object
  int main()
    PROGRAM
  end
end
HERE
  runko.sub("PROGRAM" , @main )
  end

  def check_remote val
    check_r val , true
  end

  def connected
    make_box
  end
end
