require_relative "../../helper"
require "register/interpreter"

module Ticker

  def setup
    machine = Register.machine.boot
    syntax  = Parser::Salama.new.parse_with_debug(@string_input)
    parts = Parser::Transform.new.apply(syntax)
    #puts parts.inspect
    Soml.compile( parts )
    machine.collect
    @interpreter = Register::Interpreter.new
    @interpreter.start Register.machine.init
  end

  def check_chain should
    should.each_with_index do |name , index|
      got = ticks(1)
      assert got.class.name.index(name) , "Wrong class for #{index+1}, expect #{name} , got #{got}"
    end
  end

  def check_return val
    assert_equal Parfait::Message , @interpreter.get_register(:r0).class
    assert_equal val , @interpreter.get_register(:r0).return_value
  end

  def ticks num
    last = nil
    num.times do
      last = @interpreter.instruction
      @interpreter.tick
    end
    return last
  end

  def show_ticks
    classes = []
    tick = 1
    begin
      while true and (classes.length < 200)
        cl = ticks(1).class
        tick += 1
        classes << cl
        break if cl == NilClass
      end
    rescue => e
      puts "Error at tick #{tick}"
      puts e
    end
    classes = classes.collect {|c| '"' + c.name.sub("Register::","")  + '",' }
    classes << "length = #{classes.length}"
    classes.each_slice(5).each do |line|
      puts "     " + line.join
    end
    exit(1)
  end
end
