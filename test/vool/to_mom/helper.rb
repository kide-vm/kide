require_relative "../helper"

module MomCompile
  include CompilerHelper

  def compile_first_method input
    lst = Vool::VoolCompiler.compile as_main( input )
    assert_equal Parfait::Class , lst.clazz.class , input
    method = lst.clazz.get_method(:main)
    assert method
    lst.to_mom( nil ).first
  end

end
