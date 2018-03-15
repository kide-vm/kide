require_relative "../helper"

module VoolHelper
  include CompilerHelper

  def compile_main( input )
    st = Vool::VoolCompiler.ruby_to_vool as_test_main( input )
    assert_equal st.class , Vool::ClassStatement
    assert_equal st.body.class , Vool::MethodStatement
    st.body.body
  end

  def compile_plain( input )
    Vool::VoolCompiler.ruby_to_vool input
  end
end
