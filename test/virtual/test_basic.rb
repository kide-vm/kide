require_relative "virtual_helper"

class TestBasic < MiniTest::Test
  include VirtualHelper

  def test_number
    @string_input    = '42 '
    @output = "---RETURN_MARKER- !ruby/object:Virtual::IntegerConstantRETURN_MARKER  integer: 42RETURN_MARKER"
    check
  end

  def test_true
    @string_input    = 'true '
    @output = "---RETURN_MARKER- !ruby/object:Virtual::TrueValue {}RETURN_MARKER"
    check
  end
  def test_false
    @string_input    = 'false '
    @output = "---RETURN_MARKER- !ruby/object:Virtual::FalseValue {}RETURN_MARKER"
    check
  end
  def test_nil
    @string_input    = 'nil '
    @output = "---RETURN_MARKER- !ruby/object:Virtual::NilValue {}RETURN_MARKER"
    check
  end

  def test_name
    @string_input    = 'foo '
    @output = "---RETURN_MARKER- !ruby/object:Virtual::ReturnRETURN_MARKER  name: :returnRETURN_MARKER  type: !ruby/class 'Virtual::Mystery'RETURN_MARKER"
    check
  end

  def test_self
    @string_input    = 'self '
    @output = "---RETURN_MARKER- !ruby/object:Virtual::SelfRETURN_MARKER  name: :selfRETURN_MARKER  type: !ruby/object:Virtual::Mystery {}RETURN_MARKER"
    check
  end

  def test_instance_variable
    @string_input    = '@foo_bar '
    @output = "---RETURN_MARKER- !ruby/object:Virtual::ReturnRETURN_MARKER  name: :returnRETURN_MARKER  type: !ruby/object:Virtual::Mystery {}RETURN_MARKER"
    check
  end

  def test_module_name
    @string_input    = 'FooBar '
    @output = "---RETURN_MARKER- &1 !ruby/object:Boot::BootClassRETURN_MARKER  method_definitions: []RETURN_MARKER  name: :FooBarRETURN_MARKER  super_class_name: :ObjectRETURN_MARKER  meta_class: !ruby/object:Boot::MetaClassRETURN_MARKER    layout: !ruby/object:Virtual::LayoutRETURN_MARKER      members: []RETURN_MARKER    functions: []RETURN_MARKER    me_self: *1RETURN_MARKER"
    check
  end

  def test_string
    @string_input    = "\"hello\""
    @output =  "---RETURN_MARKER- !ruby/object:Virtual::StringConstantRETURN_MARKER  string: helloRETURN_MARKER"
    check
  end

end