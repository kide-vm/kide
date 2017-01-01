require_relative '../helper'
require "register/interpreter"
require "rye"
Rye::Cmd.add_command :ld, '/usr/bin/ld'
Rye::Cmd.add_command :aout, './a.out'

# machinery to run a typed program in 2 ways
# - first by running it through the interpreter
# - second by assembling to arm , pushing the binary to a remote machine and executing it there
#
# The second obviously takes a fair bit of time so it's only done when an REMOTE_PI is set
#  REMOTE_PI has to be set to user@machine:port  or it will default to an emulator
#   the minimum is REMOTE_PI=username , and off course ssh keys have to be set up

# btw can't test with ruby on a PI as code creation only works on 64bit
#   that's because ruby nibbles 2 bits from a word, and typed code doesn't work around that
module RuntimeTests

  def setup
    @stdout =  ""
  end

  def load_program
    @machine = Register.machine.boot
    @machine.parse_and_compile main()
    @machine.collect
  end

  def check ret = nil
    i = check_local
    check_r ret
    i
  end

  def check_local ret = nil
    load_program
    interpreter = Register::Interpreter.new
    interpreter.start @machine.init
    count = 0
    begin
      count += 1
      #puts interpreter.instruction
      interpreter.tick
    end while( ! interpreter.instruction.nil?)
    assert_equal @stdout , interpreter.stdout , "stdout wrong locally"
    if ret
      assert_equal Parfait::Message , interpreter.get_register(:r0).class
      assert_equal ret , interpreter.get_register(:r0).return_value , "exit wrong #{@string_input}"
    end
    interpreter
  end

  def connected
    return false if ENV["REMOTE_PI"].nil? or (ENV["REMOTE_PI"] == "")
    return @@conn if defined?(@@conn)
    puts "remote " + ENV["REMOTE_PI"]
    user , rest = ENV["REMOTE_PI"].split("@")
    machine , port = rest.to_s.split(":")
    make_box machine , port , user
  end

  def make_box machine = nil , port = nil , user = nil
    @@conn = Rye::Box.new(machine || "localhost" , :port => (port || 2222) , :user => (user || "pi"))
  end

  def check_r ret_val , dont_run = false
    return unless box = connected
    load_program
    file = write_object_file
    r_file = file.sub("./" , "ruby-x/")
    box.file_upload file , r_file
    print "\nfile #{file} "
    return if dont_run
    box.ld "-N", r_file
    begin    #need to rescue here as rye throws if no return 0
      ret = box.aout           # and we use return to mean something
    rescue Rye::Err => e       # so it's basically never 0
      ret = e.rap
    end
    assert_equal @stdout , ret.stdout.join , "remote std was #{ret.stdout}" if @stdout
    assert_equal "" , ret.stderr.join , "remote had error"
    if ret_val
      ret_val &= 0xFF  # don't knwo why exit codes are restricted but there you are
      assert_equal ret_val , ret.exit_status.to_i  , "remote exit failed for #{@string_input}"
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

end
