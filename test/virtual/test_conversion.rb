require_relative "../helper"

class TestConversion < MiniTest::Test

  def pest_number
    @string_input    = '42 '
    @output = "-Virtual::Return(:index => 5, :type => Virtual::Integer)*^*  :value Virtual::IntegerConstant(:integer => 42)"
    check
  end

  def pest_true
    @string_input    = 'true '
    @output = "-Virtual::Return(:index => 5, :type => Virtual::Reference)*^*  :value Virtual::TrueConstant(:length => -1)"
    check
  end
  def pest_false
    @string_input    = 'false '
    @output = "-Virtual::Return(:index => 5, :type => Virtual::Reference)*^*  :value Virtual::FalseConstant(:length => -1)"
    check
  end
  def pest_nil
    @string_input    = 'nil '
    @output = "-Virtual::Return(:index => 5, :type => Virtual::Reference)*^*  :value Virtual::NilConstant(:length => -1)"
    check
  end

  def pest_name
    @string_input    = 'foo '
    @output = "-Virtual::Return(:index => 5, :type => Virtual::Mystery)"
    check
  end

  def pest_self
    @string_input    = 'self '
    @output = "-Virtual::Self(:index => 3, :type => Virtual::Mystery)"
    check
  end

  def pest_instance_variable
    @string_input    = '@foo_bar '
    @output = "-Virtual::Return(:index => 5, :type => Virtual::Mystery)"
    check
  end

  def pest_module_name
    @string_input    = 'FooBar '
    @output = "---RETURN_MARKER- &1 !ruby/object:Boot::BootClassRETURN_MARKER  instance_methods: []RETURN_MARKER  name: :FooBarRETURN_MARKER  super_class_name: :ObjectRETURN_MARKER  meta_class: !ruby/object:Boot::MetaClassRETURN_MARKER    functions: []RETURN_MARKER    me_self: *1RETURN_MARKER"
    check
  end

  def test_string
    string    = "hello"
    word = Parfait.new_word string
    assert_equal word , Parfait.new_word(string)
    assert_equal string , word.to_s
  end

end
