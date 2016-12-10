require_relative '../helper'

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
    compiler = Typed::Compiler.new
    set_main(compiler)
    code = Typed.ast_to_code @input
    produced = compiler.process( code )
    assert @output , "No output given"
    assert_equal  produced.class , @output , "Wrong class"
    produced
  end

  # test hack to in place change object type
  def add_object_field(name,type)
    class_type = Register.machine.space.get_class_by_name(:Object).instance_type
    class_type.send(:private_add_instance_variable, name , type)
  end
end
