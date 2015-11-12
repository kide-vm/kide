require_relative '../helper'
require "interpreter/interpreter"

module RuntimeTests

  def setup
    @stdout =  ""
  end
  def main
<<HERE
class Object
  int main()
    PROGRAM
  end
end
HERE
  end
  def check
    machine = Register.machine.boot
    Soml::Compiler.load_parfait
    machine.parse_and_compile  main.sub("PROGRAM" , @string_input )
    machine.collect
    @interpreter = Interpreter::Interpreter.new
    @interpreter.start machine.init
    count = 0
    begin
      count += 1
      #puts interpreter.instruction
      @interpreter.tick
    end while( ! @interpreter.instruction.nil?)
    assert_equal @stdout , @interpreter.stdout
#    write_file if true
  end

  def write_file
    file_name = caller(3).first.split("in ").last.chop.reverse.chop.reverse
    file_name = File.dirname(__FILE__) + "/" + file_name + ".o"
    Register.machine.translate_arm
    writer = Elf::ObjectWriter.new
    writer.save file_name
  end

  def check_return val
    check
    assert_equal Parfait::Message , @interpreter.get_register(:r0).class
    assert_equal val , @interpreter.get_register(:r0).return_value
  end

  def check_return_class val
    check
    assert_equal val , @interpreter.get_register(:r0).return_value.class
  end
end
