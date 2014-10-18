require_relative "virtual_helper"

class TestMethods < MiniTest::Test
  include VirtualHelper
  
  def test_simplest_function
    @string_input    = <<HERE
def foo(x) 
  5
end
HERE
    @output = "---RETURN_MARKER- &1 !ruby/object:Virtual::CompiledMethodRETURN_MARKER  name: :fooRETURN_MARKER  args:RETURN_MARKER  - :xRETURN_MARKER  locals: []RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfRETURN_MARKER    index: 1RETURN_MARKER    type: !ruby/class 'Virtual::Mystery'RETURN_MARKER  return_type: &2 !ruby/object:Virtual::ReturnRETURN_MARKER    index: 0RETURN_MARKER    type: !ruby/class 'Virtual::Integer'RETURN_MARKER  blocks:RETURN_MARKER  - &3 !ruby/object:Virtual::BlockRETURN_MARKER    method: *1RETURN_MARKER    name: :fooRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER    - !ruby/object:Virtual::SetRETURN_MARKER      to: *2RETURN_MARKER      from: !ruby/object:Virtual::IntegerConstantRETURN_MARKER        integer: 5RETURN_MARKER  - !ruby/object:Virtual::BlockRETURN_MARKER    method: *1RETURN_MARKER    name: :foo_returnRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER  current: *3RETURN_MARKER"
    check
  end

  def test_puts_string
    @string_input    = <<HERE
def foo()
  puts("Hello")
end
foo()
HERE
    @output = "---RETURN_MARKER- &2 !ruby/object:Virtual::CompiledMethodRETURN_MARKER  name: :fooRETURN_MARKER  args: []RETURN_MARKER  locals: []RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfRETURN_MARKER    index: 1RETURN_MARKER    type: &1 !ruby/class 'Virtual::Mystery'RETURN_MARKER  return_type: !ruby/object:Virtual::ReturnRETURN_MARKER    index: 0RETURN_MARKER    type: *1RETURN_MARKER  blocks:RETURN_MARKER  - &5 !ruby/object:Virtual::BlockRETURN_MARKER    method: *2RETURN_MARKER    name: :fooRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER    - !ruby/object:Virtual::SetRETURN_MARKER      to: !ruby/object:Virtual::NewSelfRETURN_MARKER        index: 1RETURN_MARKER        type: *1RETURN_MARKER      from: &3 !ruby/object:Virtual::SelfRETURN_MARKER        index: 1RETURN_MARKER        type: *1RETURN_MARKER    - !ruby/object:Virtual::SetRETURN_MARKER      to: !ruby/object:Virtual::NewNameRETURN_MARKER        index: 3RETURN_MARKER        type: *1RETURN_MARKER      from: :putsRETURN_MARKER    - !ruby/object:Virtual::SetRETURN_MARKER      to: !ruby/object:Virtual::NewMessageSlotRETURN_MARKER        index: 4RETURN_MARKER        type: !ruby/class 'Virtual::Reference'RETURN_MARKER      from: &4 !ruby/object:Virtual::StringConstantRETURN_MARKER        string: HelloRETURN_MARKER    - !ruby/object:Virtual::MessageSendRETURN_MARKER      name: :putsRETURN_MARKER      me: *3RETURN_MARKER      args:RETURN_MARKER      - *4RETURN_MARKER  - !ruby/object:Virtual::BlockRETURN_MARKER    method: *2RETURN_MARKER    name: :foo_returnRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER  current: *5RETURN_MARKER- !ruby/object:Virtual::ReturnRETURN_MARKER  index: 0RETURN_MARKER  type: *1RETURN_MARKER"
    check
  end

  def test_class_function
    @string_input    = <<HERE
def String.length(x)
  @length
end
HERE
    @output = "---RETURN_MARKER- &7 !ruby/object:Virtual::CompiledMethodRETURN_MARKER  name: :lengthRETURN_MARKER  args:RETURN_MARKER  - :xRETURN_MARKER  locals: []RETURN_MARKER  tmps: []RETURN_MARKER  receiver: &6 !ruby/object:Boot::BootClassRETURN_MARKER    instance_methods:RETURN_MARKER    - &2 !ruby/object:Virtual::CompiledMethodRETURN_MARKER      name: :getRETURN_MARKER      args:RETURN_MARKER      - &1 !ruby/class 'Virtual::Integer'RETURN_MARKER      locals: []RETURN_MARKER      tmps: []RETURN_MARKER      receiver: *1RETURN_MARKER      return_type: *1RETURN_MARKER      blocks:RETURN_MARKER      - &3 !ruby/object:Virtual::BlockRETURN_MARKER        method: *2RETURN_MARKER        name: :getRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER      - !ruby/object:Virtual::BlockRETURN_MARKER        method: *2RETURN_MARKER        name: :get_returnRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER      current: *3RETURN_MARKER    - &4 !ruby/object:Virtual::CompiledMethodRETURN_MARKER      name: :setRETURN_MARKER      args:RETURN_MARKER      - *1RETURN_MARKER      - *1RETURN_MARKER      locals: []RETURN_MARKER      tmps: []RETURN_MARKER      receiver: *1RETURN_MARKER      return_type: *1RETURN_MARKER      blocks:RETURN_MARKER      - &5 !ruby/object:Virtual::BlockRETURN_MARKER        method: *4RETURN_MARKER        name: :setRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER      - !ruby/object:Virtual::BlockRETURN_MARKER        method: *4RETURN_MARKER        name: :set_returnRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER      current: *5RETURN_MARKER    name: :StringRETURN_MARKER    super_class_name: :ObjectRETURN_MARKER    meta_class: !ruby/object:Boot::MetaClassRETURN_MARKER      functions: []RETURN_MARKER      me_self: *6RETURN_MARKER  return_type: !ruby/object:Virtual::ReturnRETURN_MARKER    index: 0RETURN_MARKER    type: !ruby/class 'Virtual::Mystery'RETURN_MARKER  blocks:RETURN_MARKER  - &8 !ruby/object:Virtual::BlockRETURN_MARKER    method: *7RETURN_MARKER    name: :lengthRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER    - !ruby/object:Virtual::InstanceGetRETURN_MARKER      name: :lengthRETURN_MARKER  - !ruby/object:Virtual::BlockRETURN_MARKER    method: *7RETURN_MARKER    name: :length_returnRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER  current: *8RETURN_MARKER"
    check
  end

  def test_function_ops
    @string_input    = <<HERE
def foo(x) 
 abba = 5 
 2 + 5
end
HERE
    @output =""
    check
  end

  def test_function_ops_simple
    @string_input    = <<HERE
def foo()
  2 + 5
end
HERE
    @output = ""
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
      @output = "---RETURN_MARKER- &2 !ruby/object:Virtual::CompiledMethodRETURN_MARKER  name: :ofthenRETURN_MARKER  args:RETURN_MARKER  - !ruby/object:Virtual::ArgumentRETURN_MARKER    name: :nRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  locals:RETURN_MARKER  - !ruby/object:Virtual::LocalRETURN_MARKER    name: :isitRETURN_MARKER    type: &3 !ruby/object:Virtual::IntegerConstantRETURN_MARKER      integer: 42RETURN_MARKER  - &1 !ruby/object:Virtual::LocalRETURN_MARKER    name: :maybenotRETURN_MARKER    type: &4 !ruby/object:Virtual::IntegerConstantRETURN_MARKER      integer: 667RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfReferenceRETURN_MARKER    clazz: RETURN_MARKER  return_type: *1RETURN_MARKER  blocks:RETURN_MARKER  - !ruby/object:Virtual::BlockRETURN_MARKER    method: *2RETURN_MARKER    name: :ofthenRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER    - !ruby/object:Virtual::IsTrueBranchRETURN_MARKER      to: &5 !ruby/object:Virtual::BlockRETURN_MARKER        method: *2RETURN_MARKER        name: :ofthen_if_trueRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::FrameSetRETURN_MARKER          name: :isitRETURN_MARKER          value: *3RETURN_MARKER  - !ruby/object:Virtual::BlockRETURN_MARKER    method: *2RETURN_MARKER    name: :ofthen_if_falseRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::FrameSetRETURN_MARKER      name: :maybenotRETURN_MARKER      value: *4RETURN_MARKER    - !ruby/object:Virtual::UnconditionalBranchRETURN_MARKER      to: &6 !ruby/object:Virtual::BlockRETURN_MARKER        method: *2RETURN_MARKER        name: :ofthen_if_mergeRETURN_MARKER        branch: RETURN_MARKER        codes: []RETURN_MARKER  - *5RETURN_MARKER  - *6RETURN_MARKER  - !ruby/object:Virtual::BlockRETURN_MARKER    method: *2RETURN_MARKER    name: :ofthen_returnRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER  current: *6RETURN_MARKER"
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