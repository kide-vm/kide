require_relative "virtual_helper"

class TestMethods < MiniTest::Test
  include VirtualHelper

  def test_simplest_function
    @string_input    = <<HERE
def foo(x)
  5
end
HERE
    @output = "-Virtual::CompiledMethod(:name => :foo, :class_name => :Object)*^*  :arg_names [:x]*^*  :locals []*^*  :tmps []*^*  :receiver Virtual::Self(:index => 3, :type => Virtual::Mystery)*^*  :return_type &1 Virtual::Return(:index => 5, :type => Virtual::Integer)*^*    :value &2 Virtual::IntegerConstant(:integer => 5)*^*  :blocks -Virtual::Block(:length => -1, :name => :enter)*^*     :codes -Virtual::MethodEnter(:length => -1)*^*      -Virtual::Set(:to => *1, :from => *2)*^*   -Virtual::Block(:length => -1, :name => :return)*^*     :codes -Virtual::MethodReturn(:length => -1)"
    check
  end

  def test_puts_string
    @string_input    = <<HERE
def foo()
  puts("Hello")
end
foo()
HERE
    @output = "-Virtual::CompiledMethod(:name => :foo, :class_name => :Object)*^*  :arg_names []*^*  :locals []*^*  :tmps []*^*  :receiver Virtual::Self(:index => 3, :type => *1)*^*  :return_type Virtual::Return(:index => 5, :type => *1)*^*  :blocks -Virtual::Block(:length => -1, :name => :enter)*^*     :codes -Virtual::MethodEnter(:length => -1)*^*      -Virtual::NewMessage(:length => -1)*^*      -Virtual::Set()*^*        :to Virtual::NewSelf(:index => 3, :type => *1)*^*        :from &5 Virtual::Self(:index => 3, :type => *1)*^*      -Virtual::Set()*^*        :to Virtual::NewName(:index => 4, :type => *1)*^*        :from Parfait::Word(:string => :puts)*^*      -Virtual::Set()*^*        :to &4 Virtual::Return(:index => 5, :type => &3 Virtual::Reference, :value => *2)*^*        :from &2 Parfait::Word(:string => 'Hello')*^*      -Virtual::Set()*^*        :to &6 Virtual::NewMessageSlot(:index => 0, :type => &3 Virtual::Reference, :value => *4)*^*        :from &4 Virtual::Return(:index => 5, :type => &3 Virtual::Reference, :value => *2)*^*      -Virtual::MessageSend(:name => :puts)*^*        :me &5 Virtual::Self(:index => 3, :type => *1)*^*        :args [*6]*^*   -Virtual::Block(:length => -1, :name => :return)*^*     :codes -Virtual::MethodReturn(:length => -1)*^*-Virtual::Return(:index => 5, :type => &1 Virtual::Mystery)"
    check
  end

  def pest_class_function
    @string_input    = <<HERE
def String.length(x)
  @length
end
HERE
    @output = "---RETURN_MARKER- &7 !ruby/object:Virtual::CompiledMethodRETURN_MARKER  name: :lengthRETURN_MARKER  args:RETURN_MARKER  - :xRETURN_MARKER  locals: []RETURN_MARKER  tmps: []RETURN_MARKER  receiver: &6 !ruby/object:Boot::BootClassRETURN_MARKER    instance_methods:RETURN_MARKER    - &2 !ruby/object:Virtual::CompiledMethodRETURN_MARKER      name: :getRETURN_MARKER      args:RETURN_MARKER      - &1 !ruby/class 'Virtual::Integer'RETURN_MARKER      locals: []RETURN_MARKER      tmps: []RETURN_MARKER      receiver: *1RETURN_MARKER      return_type: *1RETURN_MARKER      blocks:RETURN_MARKER      - &3 !ruby/object:Virtual::BlockRETURN_MARKER        method: *2RETURN_MARKER        name: :getRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER      - !ruby/object:Virtual::BlockRETURN_MARKER        method: *2RETURN_MARKER        name: :get_returnRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER      current: *3RETURN_MARKER    - &4 !ruby/object:Virtual::CompiledMethodRETURN_MARKER      name: :setRETURN_MARKER      args:RETURN_MARKER      - *1RETURN_MARKER      - *1RETURN_MARKER      locals: []RETURN_MARKER      tmps: []RETURN_MARKER      receiver: *1RETURN_MARKER      return_type: *1RETURN_MARKER      blocks:RETURN_MARKER      - &5 !ruby/object:Virtual::BlockRETURN_MARKER        method: *4RETURN_MARKER        name: :setRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER      - !ruby/object:Virtual::BlockRETURN_MARKER        method: *4RETURN_MARKER        name: :set_returnRETURN_MARKER        branch: RETURN_MARKER        codes:RETURN_MARKER        - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER      current: *5RETURN_MARKER    name: :WordRETURN_MARKER    super_class_name: :ObjectRETURN_MARKER    meta_class: !ruby/object:Boot::MetaClassRETURN_MARKER      functions: []RETURN_MARKER      me_self: *6RETURN_MARKER  return_type: !ruby/object:Virtual::ReturnRETURN_MARKER    index: 0RETURN_MARKER    type: !ruby/class 'Virtual::Mystery'RETURN_MARKER  blocks:RETURN_MARKER  - &8 !ruby/object:Virtual::BlockRETURN_MARKER    method: *7RETURN_MARKER    name: :lengthRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodEnter {}RETURN_MARKER    - !ruby/object:Virtual::InstanceGetRETURN_MARKER      name: :lengthRETURN_MARKER  - !ruby/object:Virtual::BlockRETURN_MARKER    method: *7RETURN_MARKER    name: :length_returnRETURN_MARKER    branch: RETURN_MARKER    codes:RETURN_MARKER    - !ruby/object:Virtual::MethodReturn {}RETURN_MARKER  current: *8RETURN_MARKER"
    check
  end

  def test_function_ops
    @string_input    = <<HERE
def foo(x)
 abba = 5
 2 + 5
end
HERE
    @output = "-Virtual::CompiledMethod(:name => :foo, :class_name => :Object)*^*  :arg_names [:x]*^*  :locals [:abba]*^*  :tmps []*^*  :receiver Virtual::Self(:index => 3, :type => &1 Virtual::Mystery)*^*  :return_type Virtual::Return(:index => 5, :type => &1 Virtual::Mystery)*^*  :blocks -Virtual::Block(:length => -1, :name => :enter)*^*     :codes -Virtual::MethodEnter(:length => -1)*^*      -Virtual::Set()*^*        :to &4 Virtual::Return(:index => 5, :type => &3 Virtual::Integer, :value => *2)*^*        :from &2 Virtual::IntegerConstant(:integer => 5)*^*      -Virtual::Set()*^*        :to Virtual::Return(:index => 5, :type => *1)*^*        :from Virtual::FrameSlot(:index => 1, :type => &3 Virtual::Integer, :value => *4)*^*      -Virtual::Set()*^*        :to &6 Virtual::Return(:index => 5, :type => &3 Virtual::Integer, :value => *5)*^*        :from &5 Virtual::IntegerConstant(:integer => 2)*^*      -Virtual::NewMessage(:length => -1)*^*      -Virtual::Set()*^*        :to Virtual::NewSelf(:index => 3, :type => &3 Virtual::Integer)*^*        :from &6 Virtual::Return(:index => 5, :type => &3 Virtual::Integer, :value => *5)*^*      -Virtual::Set(:from => Parfait::Word(:string => :+))*^*        :to Virtual::NewName(:index => 4, :type => *1)*^*      -Virtual::Set()*^*        :to &8 Virtual::Return(:index => 5, :type => &3 Virtual::Integer, :value => *7)*^*        :from &7 Virtual::IntegerConstant(:integer => 5)*^*      -Virtual::Set()*^*        :to &9 Virtual::NewMessageSlot(:index => 0, :type => &3 Virtual::Integer, :value => *8)*^*        :from &8 Virtual::Return(:index => 5, :type => &3 Virtual::Integer, :value => *7)*^*      -Virtual::MessageSend(:name => :+)*^*        :me &6 Virtual::Return(:index => 5, :type => &3 Virtual::Integer, :value => *5)*^*        :args [*9]*^*   -Virtual::Block(:length => -1, :name => :return)*^*     :codes -Virtual::MethodReturn(:length => -1)"
    check
  end

  def test_function_ops_simple
    @string_input    = <<HERE
def foo()
  2 + 5
end
HERE
    @output = "-Virtual::CompiledMethod(:name => :foo, :class_name => :Object)*^*  :arg_names []*^*  :locals []*^*  :tmps []*^*  :receiver Virtual::Self(:index => 3, :type => &1 Virtual::Mystery)*^*  :return_type Virtual::Return(:index => 5, :type => &1 Virtual::Mystery)*^*  :blocks -Virtual::Block(:length => -1, :name => :enter)*^*     :codes -Virtual::MethodEnter(:length => -1)*^*      -Virtual::Set()*^*        :to &4 Virtual::Return(:index => 5, :type => &3 Virtual::Integer, :value => *2)*^*        :from &2 Virtual::IntegerConstant(:integer => 2)*^*      -Virtual::NewMessage(:length => -1)*^*      -Virtual::Set()*^*        :to Virtual::NewSelf(:index => 3, :type => &3 Virtual::Integer)*^*        :from &4 Virtual::Return(:index => 5, :type => &3 Virtual::Integer, :value => *2)*^*      -Virtual::Set(:from => Parfait::Word(:string => :+))*^*        :to Virtual::NewName(:index => 4, :type => *1)*^*      -Virtual::Set()*^*        :to &6 Virtual::Return(:index => 5, :type => &3 Virtual::Integer, :value => *5)*^*        :from &5 Virtual::IntegerConstant(:integer => 5)*^*      -Virtual::Set()*^*        :to &7 Virtual::NewMessageSlot(:index => 0, :type => &3 Virtual::Integer, :value => *6)*^*        :from &6 Virtual::Return(:index => 5, :type => &3 Virtual::Integer, :value => *5)*^*      -Virtual::MessageSend(:name => :+)*^*        :me &4 Virtual::Return(:index => 5, :type => &3 Virtual::Integer, :value => *2)*^*        :args [*7]*^*   -Virtual::Block(:length => -1, :name => :return)*^*     :codes -Virtual::MethodReturn(:length => -1)"
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
    @output = "-Virtual::CompiledMethod(:name => :ofthen, :class_name => :Object)*^*  :arg_names [:n]*^*  :locals [:isit, :maybenot]*^*  :tmps []*^*  :receiver Virtual::Self(:index => 3, :type => &4 Virtual::Mystery)*^*  :return_type &6 Virtual::Return(:index => 5, :type => &1 Virtual::Integer)*^*    :value &7 Virtual::IntegerConstant(:integer => 667)*^*  :blocks -Virtual::Block(:length => -1, :name => :enter)*^*     :codes -Virtual::MethodEnter(:length => -1)*^*      -Virtual::Set()*^*        :to Virtual::Return(:index => 5, :type => *1, :value => *2)*^*        :from &2 Virtual::IntegerConstant(:integer => 0)*^*      -Virtual::IsTrueBranch(:to => *8)*^*   -Virtual::Block(:length => -1, :name => :if_false)*^*     :codes -Virtual::Set(:to => *6, :from => *7)*^*      -Virtual::Set()*^*        :to Virtual::Return(:index => 5, :type => *4)*^*        :from Virtual::FrameSlot(:index => 2, :type => *1, :value => *6)*^*      -Virtual::UnconditionalBranch(:to => *9)*^*   -&8 Virtual::Block(:length => -1, :name => :if_true)*^*     :codes -Virtual::Set()*^*        :to &5 Virtual::Return(:index => 5, :type => *1)*^*          :value &3 Virtual::IntegerConstant(:integer => 42)*^*        :from &3 Virtual::IntegerConstant(:integer => 42)*^*      -Virtual::Set()*^*        :to Virtual::Return(:index => 5, :type => *4)*^*        :from Virtual::FrameSlot(:index => 1, :type => *1)*^*          :value &5 Virtual::Return(:index => 5, :type => *1)*^*            :value &3 Virtual::IntegerConstant(:integer => 42)*^*   -&9 Virtual::Block(:length => -1, :name => :if_merge)*^*     :codes []*^*   -Virtual::Block(:length => -1, :name => :return)*^*     :codes -Virtual::MethodReturn(:length => -1)"
    check
  end

  def pest_function_while
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

  def pest_function_return
    @string_input    = <<HERE
def retvar(n)
  i = 5
  return i
end
HERE
    @output = ""
    check
  end

  def pest_function_return_if
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

  def est_function_return_while
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

  def pest_function_big_while
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
