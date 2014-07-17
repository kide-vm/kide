require_relative "virtual_helper"

class TestBasic < MiniTest::Test
  include VirtualHelper

  def test_number
    @string_input    = '42 '
    @output = "---_MY_MY_MARKER- !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER  integer: 42_MY_MY_MARKER"
    check
  end

  def test_true
    @string_input    = 'true '
    @output = "---_MY_MY_MARKER- !ruby/object:Virtual::TrueValue {}_MY_MY_MARKER"
    check
  end
  def test_false
    @string_input    = 'false '
    @output = "---_MY_MY_MARKER- !ruby/object:Virtual::FalseValue {}_MY_MY_MARKER"
    check
  end
  def test_nil
    @string_input    = 'nil '
    @output = "---_MY_MY_MARKER- !ruby/object:Virtual::NilValue {}_MY_MY_MARKER"
    check
  end

  def test_name
    @string_input    = 'foo '
    @output = "---_MY_MY_MARKER- !ruby/object:Virtual::Return_MY_MY_MARKER  name: :return_MY_MY_MARKER  type: !ruby/class 'Virtual::Mystery'_MY_MY_MARKER"
    check
  end

  def test_self
    @string_input    = 'self '
    @output = "---_MY_MY_MARKER- !ruby/object:Virtual::Self_MY_MY_MARKER  name: :self_MY_MY_MARKER  type: !ruby/object:Virtual::Mystery {}_MY_MY_MARKER"
    check
  end

  def test_instance_variable
    @string_input    = '@foo_bar '
    @output = "---_MY_MY_MARKER- !ruby/object:Virtual::Return_MY_MY_MARKER  name: :return_MY_MY_MARKER  type: !ruby/object:Virtual::Mystery {}_MY_MY_MARKER"
    check
  end

  def test_module_name
    @string_input    = 'FooBar '
    @output = "---_MY_MY_MARKER- &1 !ruby/object:Boot::BootClass_MY_MY_MARKER  method_definitions: []_MY_MY_MARKER  name: :FooBar_MY_MY_MARKER  super_class_name: :Object_MY_MY_MARKER  meta_class: !ruby/object:Boot::MetaClass_MY_MY_MARKER    layout: !ruby/object:Virtual::Layout_MY_MY_MARKER      members: []_MY_MY_MARKER    functions: []_MY_MY_MARKER    me_self: *1_MY_MY_MARKER"
    check
  end

  def test_string
    @string_input    = "\"hello\""
    @output =  "---_MY_MY_MARKER- !ruby/object:Virtual::StringConstant_MY_MY_MARKER  string: hello_MY_MY_MARKER"
    check
  end

end