require_relative "virtual_helper"

class TestMethods < MiniTest::Test
  include VirtualHelper
  
  def test_simplest_function
    @string_input    = <<HERE
def foo(x) 
  5
end
HERE
    @output = "---RETURN_MARKER- !ruby/object:Virtual::MethodDefinitionRETURN_MARKER  name: :fooRETURN_MARKER  args:RETURN_MARKER  - !ruby/object:Virtual::ArgumentRETURN_MARKER    name: :xRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  locals: []RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfReferenceRETURN_MARKER    clazz: RETURN_MARKER  return_type: !ruby/object:Virtual::IntegerConstantRETURN_MARKER    integer: 5RETURN_MARKER  start: &1 !ruby/object:Virtual::MethodEnterRETURN_MARKER    next: RETURN_MARKER  current: *1RETURN_MARKER"
    check
  end

  def test_class_function
    @string_input    = <<HERE
def String.length(x)
  @length
end
HERE
    @output = "---RETURN_MARKER- !ruby/object:Virtual::MethodDefinitionRETURN_MARKER  name: :lengthRETURN_MARKER  args:RETURN_MARKER  - !ruby/object:Virtual::ArgumentRETURN_MARKER    name: :xRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  locals: []RETURN_MARKER  tmps: []RETURN_MARKER  receiver: &4 !ruby/object:Boot::BootClassRETURN_MARKER    method_definitions:RETURN_MARKER    - !ruby/object:Virtual::MethodDefinitionRETURN_MARKER      name: :getRETURN_MARKER      args:RETURN_MARKER      - &1 !ruby/class 'Virtual::Integer'RETURN_MARKER      locals: []RETURN_MARKER      tmps: []RETURN_MARKER      receiver: *1RETURN_MARKER      return_type: *1RETURN_MARKER      start: &2 !ruby/object:Virtual::MethodEnterRETURN_MARKER        next: RETURN_MARKER      current: *2RETURN_MARKER    - !ruby/object:Virtual::MethodDefinitionRETURN_MARKER      name: :setRETURN_MARKER      args:RETURN_MARKER      - *1RETURN_MARKER      - *1RETURN_MARKER      locals: []RETURN_MARKER      tmps: []RETURN_MARKER      receiver: *1RETURN_MARKER      return_type: *1RETURN_MARKER      start: &3 !ruby/object:Virtual::MethodEnterRETURN_MARKER        next: RETURN_MARKER      current: *3RETURN_MARKER    name: :StringRETURN_MARKER    super_class_name: :ObjectRETURN_MARKER    meta_class: !ruby/object:Boot::MetaClassRETURN_MARKER      layout: !ruby/object:Virtual::LayoutRETURN_MARKER        members: []RETURN_MARKER      functions: []RETURN_MARKER      me_self: *4RETURN_MARKER  return_type: !ruby/object:Virtual::ReturnRETURN_MARKER    name: :returnRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  start: !ruby/object:Virtual::MethodEnterRETURN_MARKER    next: &5 !ruby/object:Virtual::ObjectGetRETURN_MARKER      next: RETURN_MARKER      name: :lengthRETURN_MARKER  current: *5RETURN_MARKER"
    check
  end

  def test_function_ops
    @string_input    = <<HERE
def foo(x) 
 abba = 5 
 2 + 5
end
HERE
    @output ="---RETURN_MARKER- !ruby/object:Virtual::MethodDefinitionRETURN_MARKER  name: :fooRETURN_MARKER  args:RETURN_MARKER  - !ruby/object:Virtual::ArgumentRETURN_MARKER    name: :xRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  locals:RETURN_MARKER  - !ruby/object:Virtual::LocalRETURN_MARKER    name: :abbaRETURN_MARKER    type: &1 !ruby/object:Virtual::IntegerConstantRETURN_MARKER      integer: 5RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfReferenceRETURN_MARKER    clazz: RETURN_MARKER  return_type: !ruby/object:Virtual::ReturnRETURN_MARKER    name: :returnRETURN_MARKER    type: !ruby/class 'Virtual::Mystery'RETURN_MARKER  start: !ruby/object:Virtual::MethodEnterRETURN_MARKER    next: !ruby/object:Virtual::FrameSetRETURN_MARKER      next: !ruby/object:Virtual::LoadSelfRETURN_MARKER        next: &2 !ruby/object:Virtual::FrameSendRETURN_MARKER          next: RETURN_MARKER          name: :+RETURN_MARKER          args:RETURN_MARKER          - !ruby/object:Virtual::IntegerConstantRETURN_MARKER            integer: 5RETURN_MARKER        value: !ruby/object:Virtual::IntegerConstantRETURN_MARKER          integer: 2RETURN_MARKER      name: :abbaRETURN_MARKER      value: *1RETURN_MARKER  current: *2RETURN_MARKER" 
    check
  end

  def test_function_ops_simple
    @string_input    = <<HERE
def foo()
  2 + 5
end
HERE
    @output = "---RETURN_MARKER- !ruby/object:Virtual::MethodDefinitionRETURN_MARKER  name: :fooRETURN_MARKER  args: []RETURN_MARKER  locals: []RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfReferenceRETURN_MARKER    clazz: RETURN_MARKER  return_type: !ruby/object:Virtual::ReturnRETURN_MARKER    name: :returnRETURN_MARKER    type: !ruby/class 'Virtual::Mystery'RETURN_MARKER  start: !ruby/object:Virtual::MethodEnterRETURN_MARKER    next: !ruby/object:Virtual::LoadSelfRETURN_MARKER      next: &1 !ruby/object:Virtual::FrameSendRETURN_MARKER        next: RETURN_MARKER        name: :+RETURN_MARKER        args:RETURN_MARKER        - !ruby/object:Virtual::IntegerConstantRETURN_MARKER          integer: 5RETURN_MARKER      value: !ruby/object:Virtual::IntegerConstantRETURN_MARKER        integer: 2RETURN_MARKER  current: *1RETURN_MARKER"
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
      @output = "---RETURN_MARKER- !ruby/object:Virtual::MethodDefinitionRETURN_MARKER  name: :ofthenRETURN_MARKER  args:RETURN_MARKER  - !ruby/object:Virtual::ArgumentRETURN_MARKER    name: :nRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  locals:RETURN_MARKER  - !ruby/object:Virtual::LocalRETURN_MARKER    name: :isitRETURN_MARKER    type: &2 !ruby/object:Virtual::IntegerConstantRETURN_MARKER      integer: 42RETURN_MARKER  - &1 !ruby/object:Virtual::LocalRETURN_MARKER    name: :maybenotRETURN_MARKER    type: &4 !ruby/object:Virtual::IntegerConstantRETURN_MARKER      integer: 667RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfReferenceRETURN_MARKER    clazz: RETURN_MARKER  return_type: *1RETURN_MARKER  start: !ruby/object:Virtual::MethodEnterRETURN_MARKER    next: !ruby/object:Virtual::ImplicitBranchRETURN_MARKER      next: !ruby/object:Virtual::FrameSetRETURN_MARKER        next: &3 !ruby/object:Virtual::LabelRETURN_MARKER          next: RETURN_MARKER          name: :if_merge_1RETURN_MARKER        name: :isitRETURN_MARKER        value: *2RETURN_MARKER      name: :if_merge_1RETURN_MARKER      other: !ruby/object:Virtual::FrameSetRETURN_MARKER        next: *3RETURN_MARKER        name: :maybenotRETURN_MARKER        value: *4RETURN_MARKER  current: *3RETURN_MARKER"
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
    @output = "---RETURN_MARKER- !ruby/object:Virtual::MethodDefinitionRETURN_MARKER  name: :fibonaccitRETURN_MARKER  args:RETURN_MARKER  - !ruby/object:Virtual::ArgumentRETURN_MARKER    name: :nRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  locals:RETURN_MARKER  - !ruby/object:Virtual::LocalRETURN_MARKER    name: :aRETURN_MARKER    type: &6 !ruby/object:Virtual::IntegerConstantRETURN_MARKER      integer: 0RETURN_MARKER  - &4 !ruby/object:Virtual::LocalRETURN_MARKER    name: :someRETURN_MARKER    type: &5 !ruby/object:Virtual::IntegerConstantRETURN_MARKER      integer: 43RETURN_MARKER  - &1 !ruby/object:Virtual::LocalRETURN_MARKER    name: :otherRETURN_MARKER    type: &3 !ruby/object:Virtual::ReturnRETURN_MARKER      name: :returnRETURN_MARKER      type: !ruby/class 'Virtual::Mystery'RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfReferenceRETURN_MARKER    clazz: RETURN_MARKER  return_type: *1RETURN_MARKER  start: !ruby/object:Virtual::MethodEnterRETURN_MARKER    next: !ruby/object:Virtual::FrameSetRETURN_MARKER      next: &2 !ruby/object:Virtual::LabelRETURN_MARKER        next: !ruby/object:Virtual::FrameGetRETURN_MARKER          next: !ruby/object:Virtual::ImplicitBranchRETURN_MARKER            next: !ruby/object:Virtual::FrameSetRETURN_MARKER              next: !ruby/object:Virtual::FrameGetRETURN_MARKER                next: !ruby/object:Virtual::LoadSelfRETURN_MARKER                  next: !ruby/object:Virtual::FrameSendRETURN_MARKER                    next: !ruby/object:Virtual::FrameSetRETURN_MARKER                      next: *2RETURN_MARKER                      name: :otherRETURN_MARKER                      value: *3RETURN_MARKER                    name: :*RETURN_MARKER                    args:RETURN_MARKER                    - !ruby/object:Virtual::IntegerConstantRETURN_MARKER                      integer: 4RETURN_MARKER                  value: *4RETURN_MARKER                name: :someRETURN_MARKER              name: :someRETURN_MARKER              value: *5RETURN_MARKER            name: :while_1RETURN_MARKER            other: &7 !ruby/object:Virtual::LabelRETURN_MARKER              next: RETURN_MARKER              name: :while_1RETURN_MARKER          name: :nRETURN_MARKER        name: while_startRETURN_MARKER      name: :aRETURN_MARKER      value: *6RETURN_MARKER  current: *7RETURN_MARKER"
    check
  end

  def test_function_return
    @string_input    = <<HERE
def retvar(n)
  i = 5
  return i 
end
HERE
    @output = "---RETURN_MARKER- !ruby/object:Virtual::MethodDefinitionRETURN_MARKER  name: :retvarRETURN_MARKER  args:RETURN_MARKER  - !ruby/object:Virtual::ArgumentRETURN_MARKER    name: :nRETURN_MARKER    type: !ruby/object:Virtual::Mystery {}RETURN_MARKER  locals:RETURN_MARKER  - !ruby/object:Virtual::LocalRETURN_MARKER    name: :iRETURN_MARKER    type: &1 !ruby/object:Virtual::IntegerConstantRETURN_MARKER      integer: 5RETURN_MARKER  tmps: []RETURN_MARKER  receiver: !ruby/object:Virtual::SelfReferenceRETURN_MARKER    clazz: RETURN_MARKER  return_type: !ruby/object:Virtual::ReferenceRETURN_MARKER    clazz: RETURN_MARKER  start: !ruby/object:Virtual::MethodEnterRETURN_MARKER    next: &2 !ruby/object:Virtual::FrameSetRETURN_MARKER      next: RETURN_MARKER      name: :iRETURN_MARKER      value: *1RETURN_MARKER  current: *2RETURN_MARKER"
    check
  end

  def ttest_function_return_if
    @string_input    = <<HERE
def retvar(n)
  if( n > 5)
    return 10
  else
    return 20
  end 
end
HERE
    @output = [Virtual::MethodDefinition.new(:foo,[Ast::NameExpression.new(:x)])]
    check
  end

  def ttest_function_return_while
    @string_input    = <<HERE
def retvar(n)
  while( n > 5) do
    n = n + 1
    return n
  end 
end
HERE
    @output = [Virtual::MethodDefinition.new(:foo,[Ast::NameExpression.new(:x)])]
    check
  end

  def ttest_function_big_while
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
    @output = [Virtual::MethodDefinition.new(:foo,[Ast::NameExpression.new(:x)])]
    check
  end  
end