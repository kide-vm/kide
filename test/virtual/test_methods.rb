require_relative "virtual_helper"

class TestMethods < MiniTest::Test
  include VirtualHelper
  
  def test_simplest_function
    @string_input    = <<HERE
def foo(x) 
  5
end
HERE
    @output = "---RETURN_MARKER- &1 !ruby/object:Virtual::MethodDefinitionRETURN_MARKER  name: :fooRETURN_MARKER  args:RETURN_MARKER  - !ruby/object:Virtual::ArgumentRETURN_MARKER    name: :xRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  locals: []RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfReferenceRETURN_MARKER    clazz: RETURN_MARKER  return_type: !ruby/object:Virtual::IntegerConstantRETURN_MARKER    integer: 5RETURN_MARKER  blocks:RETURN_MARKER  - &2 !ruby/object:Virtual::BlockRETURN_MARKER    method: *1RETURN_MARKER    name: :fooRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER  - !ruby/object:Virtual::BlockRETURN_MARKER    method: *1RETURN_MARKER    name: :foo_returnRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER  current: *2RETURN_MARKER"
    check
  end

  def test_class_function
    @string_input    = <<HERE
def String.length(x)
  @length
end
HERE
    @output = "---RETURN_MARKER- &7 !ruby/object:Virtual::MethodDefinitionRETURN_MARKER  name: :lengthRETURN_MARKER  args:RETURN_MARKER  - !ruby/object:Virtual::ArgumentRETURN_MARKER    name: :xRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  locals: []RETURN_MARKER  tmps: []RETURN_MARKER  receiver: &6 !ruby/object:Boot::BootClassRETURN_MARKER    method_definitions:RETURN_MARKER    - &2 !ruby/object:Virtual::MethodDefinitionRETURN_MARKER      name: :getRETURN_MARKER      args:RETURN_MARKER      - &1 !ruby/class 'Virtual::Integer'RETURN_MARKER      locals: []RETURN_MARKER      tmps: []RETURN_MARKER      receiver: *1RETURN_MARKER      return_type: *1RETURN_MARKER      blocks:RETURN_MARKER      - &3 !ruby/object:Virtual::BlockRETURN_MARKER        method: *2RETURN_MARKER        name: :getRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER      - !ruby/object:Virtual::BlockRETURN_MARKER        method: *2RETURN_MARKER        name: :get_returnRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER      current: *3RETURN_MARKER    - &4 !ruby/object:Virtual::MethodDefinitionRETURN_MARKER      name: :setRETURN_MARKER      args:RETURN_MARKER      - *1RETURN_MARKER      - *1RETURN_MARKER      locals: []RETURN_MARKER      tmps: []RETURN_MARKER      receiver: *1RETURN_MARKER      return_type: *1RETURN_MARKER      blocks:RETURN_MARKER      - &5 !ruby/object:Virtual::BlockRETURN_MARKER        method: *4RETURN_MARKER        name: :setRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER      - !ruby/object:Virtual::BlockRETURN_MARKER        method: *4RETURN_MARKER        name: :set_returnRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER      current: *5RETURN_MARKER    name: :StringRETURN_MARKER    super_class_name: :ObjectRETURN_MARKER    meta_class: !ruby/object:Boot::MetaClassRETURN_MARKER      functions: []RETURN_MARKER      me_self: *6RETURN_MARKER  return_type: !ruby/object:Virtual::ReturnRETURN_MARKER    name: :returnRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  blocks:RETURN_MARKER  - &8 !ruby/object:Virtual::BlockRETURN_MARKER    method: *7RETURN_MARKER    name: :lengthRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER    - !ruby/object:Virtual::ObjectGetRETURN_MARKER      name: :lengthRETURN_MARKER  - !ruby/object:Virtual::BlockRETURN_MARKER    method: *7RETURN_MARKER    name: :length_returnRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER  current: *8RETURN_MARKER"
    check
  end

  def test_function_ops
    @string_input    = <<HERE
def foo(x) 
 abba = 5 
 2 + 5
end
HERE
    @output ="---RETURN_MARKER- &1 !ruby/object:Virtual::MethodDefinitionRETURN_MARKER  name: :fooRETURN_MARKER  args:RETURN_MARKER  - !ruby/object:Virtual::ArgumentRETURN_MARKER    name: :xRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  locals:RETURN_MARKER  - !ruby/object:Virtual::LocalRETURN_MARKER    name: :abbaRETURN_MARKER    type: &2 !ruby/object:Virtual::IntegerConstantRETURN_MARKER      integer: 5RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfReferenceRETURN_MARKER    clazz: RETURN_MARKER  return_type: !ruby/object:Virtual::ReturnRETURN_MARKER    name: :returnRETURN_MARKER    type: !ruby/class 'Virtual::Mystery'RETURN_MARKER  blocks:RETURN_MARKER  - &3 !ruby/object:Virtual::BlockRETURN_MARKER    method: *1RETURN_MARKER    name: :fooRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER    - !ruby/object:Virtual::FrameSetRETURN_MARKER      name: :abbaRETURN_MARKER      value: *2RETURN_MARKER    - !ruby/object:Virtual::LoadSelfRETURN_MARKER      value: !ruby/object:Virtual::IntegerConstantRETURN_MARKER        integer: 2RETURN_MARKER    - !ruby/object:Virtual::MessageSendRETURN_MARKER      name: :+RETURN_MARKER      args:RETURN_MARKER      - !ruby/object:Virtual::IntegerConstantRETURN_MARKER        integer: 5RETURN_MARKER  - !ruby/object:Virtual::BlockRETURN_MARKER    method: *1RETURN_MARKER    name: :foo_returnRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER  current: *3RETURN_MARKER"
    check
  end

  def test_function_ops_simple
    @string_input    = <<HERE
def foo()
  2 + 5
end
HERE
    @output = "---RETURN_MARKER- &1 !ruby/object:Virtual::MethodDefinitionRETURN_MARKER  name: :fooRETURN_MARKER  args: []RETURN_MARKER  locals: []RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfReferenceRETURN_MARKER    clazz: RETURN_MARKER  return_type: !ruby/object:Virtual::ReturnRETURN_MARKER    name: :returnRETURN_MARKER    type: !ruby/class 'Virtual::Mystery'RETURN_MARKER  blocks:RETURN_MARKER  - &2 !ruby/object:Virtual::BlockRETURN_MARKER    method: *1RETURN_MARKER    name: :fooRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER    - !ruby/object:Virtual::LoadSelfRETURN_MARKER      value: !ruby/object:Virtual::IntegerConstantRETURN_MARKER        integer: 2RETURN_MARKER    - !ruby/object:Virtual::MessageSendRETURN_MARKER      name: :+RETURN_MARKER      args:RETURN_MARKER      - !ruby/object:Virtual::IntegerConstantRETURN_MARKER        integer: 5RETURN_MARKER  - !ruby/object:Virtual::BlockRETURN_MARKER    method: *1RETURN_MARKER    name: :foo_returnRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER  current: *2RETURN_MARKER"
    check
  end

  def test_function_if
    @string_input    = <<HERE
def ofthen(n)
  if(0)
    isit = 42
  else
    maybenot = 667
  end
end
HERE
      @output = ""
      check
  end

  def test_function_while
    @string_input    = <<HERE
def fibonaccit(n)
  a = 0
  while (n) do
    some = 43
    other = some * 4
  end
end
HERE
    @output = ""
    check
  end

  def test_function_return
    @string_input    = <<HERE
def retvar(n)
  i = 5
  return i 
end
HERE
    @output = ""
    check
  end

  def test_function_return_if
    @string_input    = <<HERE
def retvar(n)
  if( n > 5)
    return 10
  else
    return 20
  end 
end
HERE
    @output = ""
    check
  end

  def test_function_return_while
    @string_input    = <<HERE
def retvar(n)
  while( n > 5) do
    n = n + 1
    return n
  end 
end
HERE
    @output = ""
    check
  end

  def test_function_big_while
    @string_input    = <<HERE
def fibonaccit(n)
  a = 0 
  b = 1
  while( n > 1 ) do
    tmp = a
    a = b
    b = tmp + b
    puts(b)
    n = n - 1
  end
end
HERE
    @output = ""
    check
  end  
end