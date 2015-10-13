require_relative '../helper'
require 'parslet/convenience'

module CompilerHelper

  Phisol::Compiler.class_eval do
    def set_main
      @clazz = Virtual.machine.space.get_class_by_name :Object
      @method = Virtual.machine.space.get_main
    end
  end
  def check
    machine = Virtual.machine
    machine.boot unless machine.booted
    parser = Parser::Salama.new
    parser = parser.send @root
    syntax  = parser.parse_with_debug(@string_input)
    parts = Parser::Transform.new.apply(syntax)
    #puts parts.inspect
    compiler = Phisol::Compiler.new
    compiler.set_main
    produced = compiler.process( parts )
    assert @output , "No output given"
    assert_equal  produced.class, @output , "Wrong class"
  end

end
