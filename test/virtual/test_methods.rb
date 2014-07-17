require_relative "virtual_helper"

class TestMethods < MiniTest::Test
  include VirtualHelper
  
  def test_simplest_function
    @string_input    = <<HERE
def foo(x) 
  5
end
HERE
    @output = "---_MY_MY_MARKER- !ruby/object:Virtual::MethodDefinition_MY_MY_MARKER  name: :foo_MY_MY_MARKER  args:_MY_MY_MARKER  - !ruby/object:Virtual::Argument_MY_MY_MARKER    name: :x_MY_MY_MARKER    type: !ruby/object:Virtual::Mystery {}_MY_MY_MARKER  locals: []_MY_MY_MARKER  tmps: []_MY_MY_MARKER  receiver: !ruby/object:Virtual::SelfReference_MY_MY_MARKER    clazz: _MY_MY_MARKER  return_type: !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER    integer: 5_MY_MY_MARKER  start: &1 !ruby/object:Virtual::MethodEnter_MY_MY_MARKER    next: _MY_MY_MARKER  current: *1_MY_MY_MARKER"
    check
  end

  def test_class_function
    @string_input    = <<HERE
def String.length(x)
  @length
end
HERE
    @output = "---_MY_MY_MARKER- !ruby/object:Virtual::MethodDefinition_MY_MY_MARKER  name: :length_MY_MY_MARKER  args:_MY_MY_MARKER  - !ruby/object:Virtual::Argument_MY_MY_MARKER    name: :x_MY_MY_MARKER    type: !ruby/object:Virtual::Mystery {}_MY_MY_MARKER  locals: []_MY_MY_MARKER  tmps: []_MY_MY_MARKER  receiver: &4 !ruby/object:Boot::BootClass_MY_MY_MARKER    method_definitions:_MY_MY_MARKER    - !ruby/object:Virtual::MethodDefinition_MY_MY_MARKER      name: :get_MY_MY_MARKER      args:_MY_MY_MARKER      - &1 !ruby/class 'Virtual::Integer'_MY_MY_MARKER      locals: []_MY_MY_MARKER      tmps: []_MY_MY_MARKER      receiver: *1_MY_MY_MARKER      return_type: *1_MY_MY_MARKER      start: &2 !ruby/object:Virtual::MethodEnter_MY_MY_MARKER        next: _MY_MY_MARKER      current: *2_MY_MY_MARKER    - !ruby/object:Virtual::MethodDefinition_MY_MY_MARKER      name: :set_MY_MY_MARKER      args:_MY_MY_MARKER      - *1_MY_MY_MARKER      - *1_MY_MY_MARKER      locals: []_MY_MY_MARKER      tmps: []_MY_MY_MARKER      receiver: *1_MY_MY_MARKER      return_type: *1_MY_MY_MARKER      start: &3 !ruby/object:Virtual::MethodEnter_MY_MY_MARKER        next: _MY_MY_MARKER      current: *3_MY_MY_MARKER    name: :String_MY_MY_MARKER    super_class_name: :Object_MY_MY_MARKER    meta_class: !ruby/object:Boot::MetaClass_MY_MY_MARKER      layout: !ruby/object:Virtual::Layout_MY_MY_MARKER        members: []_MY_MY_MARKER      functions: []_MY_MY_MARKER      me_self: *4_MY_MY_MARKER  return_type: !ruby/object:Virtual::Return_MY_MY_MARKER    name: :return_MY_MY_MARKER    type: !ruby/object:Virtual::Mystery {}_MY_MY_MARKER  start: !ruby/object:Virtual::MethodEnter_MY_MY_MARKER    next: &5 !ruby/object:Virtual::ObjectGet_MY_MY_MARKER      next: _MY_MY_MARKER      name: :length_MY_MY_MARKER  current: *5_MY_MY_MARKER"
    check
  end

  def test_function_ops
    @string_input    = <<HERE
def foo(x) 
 abba = 5 
 2 + 5
end
HERE
    @output ="---_MY_MY_MARKER- !ruby/object:Virtual::MethodDefinition_MY_MY_MARKER  name: :foo_MY_MY_MARKER  args:_MY_MY_MARKER  - !ruby/object:Virtual::Argument_MY_MY_MARKER    name: :x_MY_MY_MARKER    type: !ruby/object:Virtual::Mystery {}_MY_MY_MARKER  locals:_MY_MY_MARKER  - !ruby/object:Virtual::Local_MY_MY_MARKER    name: :abba_MY_MY_MARKER    type: &1 !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER      integer: 5_MY_MY_MARKER  tmps: []_MY_MY_MARKER  receiver: !ruby/object:Virtual::SelfReference_MY_MY_MARKER    clazz: _MY_MY_MARKER  return_type: !ruby/object:Virtual::Return_MY_MY_MARKER    name: :return_MY_MY_MARKER    type: !ruby/class 'Virtual::Mystery'_MY_MY_MARKER  start: !ruby/object:Virtual::MethodEnter_MY_MY_MARKER    next: !ruby/object:Virtual::FrameSet_MY_MY_MARKER      next: !ruby/object:Virtual::LoadSelf_MY_MY_MARKER        next: &2 !ruby/object:Virtual::FrameSend_MY_MY_MARKER          next: _MY_MY_MARKER          name: :+_MY_MY_MARKER          args:_MY_MY_MARKER          - !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER            integer: 5_MY_MY_MARKER        value: !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER          integer: 2_MY_MY_MARKER      name: :abba_MY_MY_MARKER      value: *1_MY_MY_MARKER  current: *2_MY_MY_MARKER" 
    check
  end

  def test_function_ops_simple
    @string_input    = <<HERE
def foo()
  2 + 5
end
HERE
    @output = "---_MY_MY_MARKER- !ruby/object:Virtual::MethodDefinition_MY_MY_MARKER  name: :foo_MY_MY_MARKER  args: []_MY_MY_MARKER  locals: []_MY_MY_MARKER  tmps: []_MY_MY_MARKER  receiver: !ruby/object:Virtual::SelfReference_MY_MY_MARKER    clazz: _MY_MY_MARKER  return_type: !ruby/object:Virtual::Return_MY_MY_MARKER    name: :return_MY_MY_MARKER    type: !ruby/class 'Virtual::Mystery'_MY_MY_MARKER  start: !ruby/object:Virtual::MethodEnter_MY_MY_MARKER    next: !ruby/object:Virtual::LoadSelf_MY_MY_MARKER      next: &1 !ruby/object:Virtual::FrameSend_MY_MY_MARKER        next: _MY_MY_MARKER        name: :+_MY_MY_MARKER        args:_MY_MY_MARKER        - !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER          integer: 5_MY_MY_MARKER      value: !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER        integer: 2_MY_MY_MARKER  current: *1_MY_MY_MARKER"
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
      @output = "---_MY_MY_MARKER- !ruby/object:Virtual::MethodDefinition_MY_MY_MARKER  name: :ofthen_MY_MY_MARKER  args:_MY_MY_MARKER  - !ruby/object:Virtual::Argument_MY_MY_MARKER    name: :n_MY_MY_MARKER    type: !ruby/object:Virtual::Mystery {}_MY_MY_MARKER  locals:_MY_MY_MARKER  - !ruby/object:Virtual::Local_MY_MY_MARKER    name: :isit_MY_MY_MARKER    type: &2 !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER      integer: 42_MY_MY_MARKER  - &1 !ruby/object:Virtual::Local_MY_MY_MARKER    name: :maybenot_MY_MY_MARKER    type: &4 !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER      integer: 667_MY_MY_MARKER  tmps: []_MY_MY_MARKER  receiver: !ruby/object:Virtual::SelfReference_MY_MY_MARKER    clazz: _MY_MY_MARKER  return_type: *1_MY_MY_MARKER  start: !ruby/object:Virtual::MethodEnter_MY_MY_MARKER    next: !ruby/object:Virtual::ImplicitBranch_MY_MY_MARKER      next: !ruby/object:Virtual::FrameSet_MY_MY_MARKER        next: &3 !ruby/object:Virtual::Label_MY_MY_MARKER          next: _MY_MY_MARKER          name: :if_merge_1_MY_MY_MARKER        name: :isit_MY_MY_MARKER        value: *2_MY_MY_MARKER      name: :if_merge_1_MY_MY_MARKER      other: !ruby/object:Virtual::FrameSet_MY_MY_MARKER        next: *3_MY_MY_MARKER        name: :maybenot_MY_MY_MARKER        value: *4_MY_MY_MARKER  current: *3_MY_MY_MARKER" 
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
    @output = "---_MY_MY_MARKER- !ruby/object:Virtual::MethodDefinition_MY_MY_MARKER  name: :fibonaccit_MY_MY_MARKER  args:_MY_MY_MARKER  - !ruby/object:Virtual::Argument_MY_MY_MARKER    name: :n_MY_MY_MARKER    type: !ruby/object:Virtual::Mystery {}_MY_MY_MARKER  locals:_MY_MY_MARKER  - !ruby/object:Virtual::Local_MY_MY_MARKER    name: :a_MY_MY_MARKER    type: &6 !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER      integer: 0_MY_MY_MARKER  - &4 !ruby/object:Virtual::Local_MY_MY_MARKER    name: :some_MY_MY_MARKER    type: &5 !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER      integer: 43_MY_MY_MARKER  - &1 !ruby/object:Virtual::Local_MY_MY_MARKER    name: :other_MY_MY_MARKER    type: &3 !ruby/object:Virtual::Return_MY_MY_MARKER      name: :return_MY_MY_MARKER      type: !ruby/class 'Virtual::Mystery'_MY_MY_MARKER  tmps: []_MY_MY_MARKER  receiver: !ruby/object:Virtual::SelfReference_MY_MY_MARKER    clazz: _MY_MY_MARKER  return_type: *1_MY_MY_MARKER  start: !ruby/object:Virtual::MethodEnter_MY_MY_MARKER    next: !ruby/object:Virtual::FrameSet_MY_MY_MARKER      next: &2 !ruby/object:Virtual::Label_MY_MY_MARKER        next: !ruby/object:Virtual::FrameGet_MY_MY_MARKER          next: !ruby/object:Virtual::ImplicitBranch_MY_MY_MARKER            next: !ruby/object:Virtual::FrameSet_MY_MY_MARKER              next: !ruby/object:Virtual::FrameGet_MY_MY_MARKER                next: !ruby/object:Virtual::LoadSelf_MY_MY_MARKER                  next: !ruby/object:Virtual::FrameSend_MY_MY_MARKER                    next: !ruby/object:Virtual::FrameSet_MY_MY_MARKER                      next: *2_MY_MY_MARKER                      name: :other_MY_MY_MARKER                      value: *3_MY_MY_MARKER                    name: :*_MY_MY_MARKER                    args:_MY_MY_MARKER                    - !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER                      integer: 4_MY_MY_MARKER                  value: *4_MY_MY_MARKER                name: :some_MY_MY_MARKER              name: :some_MY_MY_MARKER              value: *5_MY_MY_MARKER            name: :while_1_MY_MY_MARKER            other: &7 !ruby/object:Virtual::Label_MY_MY_MARKER              next: _MY_MY_MARKER              name: :while_1_MY_MY_MARKER          name: :n_MY_MY_MARKER        name: while_start_MY_MY_MARKER      name: :a_MY_MY_MARKER      value: *6_MY_MY_MARKER  current: *7_MY_MY_MARKER"
    check
  end

  def test_function_return
    @string_input    = <<HERE
def retvar(n)
  i = 5
  return i 
end
HERE
    @output = "---_MY_MY_MARKER- !ruby/object:Virtual::MethodDefinition_MY_MY_MARKER  name: :retvar_MY_MY_MARKER  args:_MY_MY_MARKER  - !ruby/object:Virtual::Argument_MY_MY_MARKER    name: :n_MY_MY_MARKER    type: !ruby/object:Virtual::Mystery {}_MY_MY_MARKER  locals:_MY_MY_MARKER  - !ruby/object:Virtual::Local_MY_MY_MARKER    name: :i_MY_MY_MARKER    type: &1 !ruby/object:Virtual::IntegerConstant_MY_MY_MARKER      integer: 5_MY_MY_MARKER  tmps: []_MY_MY_MARKER  receiver: !ruby/object:Virtual::SelfReference_MY_MY_MARKER    clazz: _MY_MY_MARKER  return_type: !ruby/object:Virtual::Reference_MY_MY_MARKER    clazz: _MY_MY_MARKER  start: !ruby/object:Virtual::MethodEnter_MY_MY_MARKER    next: &2 !ruby/object:Virtual::FrameSet_MY_MY_MARKER      next: _MY_MY_MARKER      name: :i_MY_MY_MARKER      value: *1_MY_MY_MARKER  current: *2_MY_MY_MARKER"
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