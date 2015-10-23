require_relative '../../helper'
require 'parslet/convenience'

Soml::Compiler.class_eval do
  def set_main main
    @clazz = Register.machine.space.get_class_by_name :Object
    @method = main
  end
end

module CompilerHelper

  def set_main compiler
    compiler.set_main Register.machine.space.get_main
  end
  def check
    machine = Register.machine
    machine.boot unless machine.booted
    parser = Parser::Salama.new
    parser = parser.send @root
    syntax  = parser.parse_with_debug(@string_input)
    parts = Parser::Transform.new.apply(syntax)
    #puts parts.inspect
    compiler = Soml::Compiler.new
    set_main(compiler)
    produced = compiler.process( parts )
    assert @output , "No output given"
    assert_equal  produced.class, @output , "Wrong class"
    produced
  end

end
