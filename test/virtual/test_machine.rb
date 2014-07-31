require_relative "virtual_helper"

class TestMethods < MiniTest::Test
  include VirtualHelper
  
  def test_object
    @string_input    = <<HERE
class Object
end
HERE
    @output = "---RETURN_MARKER- !ruby/object:Virtual::MethodDefinitionRETURN_MARKER  name: :fooRETURN_MARKER  args:RETURN_MARKER  - !ruby/object:Virtual::ArgumentRETURN_MARKER    name: :xRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  locals: []RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfReferenceRETURN_MARKER    clazz: RETURN_MARKER  return_type: !ruby/object:Virtual::IntegerConstantRETURN_MARKER    integer: 5RETURN_MARKER  start: &1 !ruby/object:Virtual::MethodEnterRETURN_MARKER    next: !ruby/object:Virtual::MethodReturnRETURN_MARKER      next: RETURN_MARKER  current: *1RETURN_MARKER"
    check
  end

end