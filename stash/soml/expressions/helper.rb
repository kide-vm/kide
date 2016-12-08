require_relative '../../helper'
require 'parslet/convenience'

Typed::Compiler.class_eval do
  def set_main main
    @clazz = Register.machine.space.get_class_by_name :Object
    @method = main
    @current = main.instructions.next
  end
end

module ExpressionHelper

  def set_main compiler
    compiler.set_main Register.machine.space.get_main
  end
  def check
    machine = Register.machine
    machine.boot unless machine.booted
    parser = Parser::Salama.new
    parser = parser.send @root
    syntax  = parser.parse_with_debug(@string_input, reporter: Parslet::ErrorReporter::Deepest.new)
    parts = Parser::Transform.new.apply(syntax)
    codes = Soml.ast_to_code parts
    #puts parts.inspect
    compiler = Typed::Compiler.new
    set_main(compiler)
    produced = compiler.process( codes )
    assert @output , "No output given"
    assert_equal  produced.class, @output , "Wrong class"
    produced
  end

end
