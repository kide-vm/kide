require_relative '../helper'

module ExpressionHelper

  def check
    Register.machine.boot unless Register.machine.booted
    compiler = Typed::MethodCompiler.new Parfait.object_space.get_main
    code = Typed.ast_to_code @input
    assert code.to_s , @input
    produced = compiler.process( code )
    assert @output , "No output given"
    assert_equal produced.class , @output , "Wrong class"
    produced
  end

  # test hack to in place change object type
  def add_space_field(name,type)
    class_type = Parfait.object_space.get_class_by_name(:Space).instance_type
    class_type.send(:private_add_instance_variable, name , type)
  end
end
