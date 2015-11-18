require_relative '../helper'
require "interpreter/interpreter"
require "rye"
Rye::Cmd.add_command :ld, '/usr/bin/ld'
Rye::Cmd.add_command :aout, './a.out'

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
  def check ret = nil
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
    assert_equal @stdout , @interpreter.stdout , "stdout wrong locally"
    if ret
      assert_equal Parfait::Message , @interpreter.get_register(:r0).class
      assert_equal ret , @interpreter.get_register(:r0).return_value , "exit wrong #{@string_input}"
    end
    check_remote ret
    file = write_object_file
  end

  def connected
    return @@conn if defined?(@@conn)
    return @@conn = false
    begin
      box = Rye::Box.new("localhost" , :port => 2222 , :user => "pi")
      box.pwd
      puts "connected, testing also remotely"
      @@conn = box
    rescue Rye::Err
      @@conn = false
    end
    return @@conn
  end
  def check_remote ret
    return unless box = connected
    return unless ret.is_a?(Numeric)
    file = write_object_file
    r_file = file.sub("./" , "salama/")
    box.file_upload file , r_file
    box.ld "-N", r_file
    begin    #need to rescue here as rye throws if no return 0
      ret = box.aout           # and we use return to mean something
    rescue Rye::Err => e       # so it's basically never 0
      ret = e.rap
    end
    assert_equal @stdout , ret.stdout.join , "remote std was #{ret.stdout}" if @stdout
    assert_equal "" , ret.stderr.join , "remote had error"
    if ret
      should =  @interpreter.get_register(:r0).return_value
      assert_equal should , ret.exit_status.to_i  , "remote exit failed for #{@string_input}"
    end
  end

  def write_object_file
    file_name = caller(3).first.split("in ").last.chop.sub("`","")
    return if file_name.include?("run")
    file_name =  "./tmp/" + file_name + ".o"
    Register.machine.translate_arm
    writer = Elf::ObjectWriter.new
    writer.save file_name
    file_name
  end

  def check_return val
    check val
  end

  def check_return_class val
    check
    assert_equal val , @interpreter.get_register(:r0).return_value.class
  end
end
