require_relative "virtual_helper"

class TestMethods < MiniTest::Test
  include VirtualHelper

  def test_simplest_function
    @string_input    = <<HERE
def foo(x)
  5
end
HERE
    @output = "-&7 Parfait::Method(:name => 'foo', :code => '')*^*  :memory -0*^*   -&1 ['name', 'code', 'arg_names', 'locals', 'tmps']*^*  :arg_names [:x]*^*  :locals []*^*  :tmps []*^*  :info Virtual::CompiledMethodInfo()*^*    :return_type &15 Virtual::Return(:index => 5, :type => &9 Virtual::Integer)*^*      :value &16 Virtual::IntegerConstant(:integer => 5)*^*    :blocks -Virtual::Block(:length => -1, :name => :enter)*^*       :codes -Virtual::MethodEnter()*^*        -Virtual::Set(:to => *15, :from => *16)*^*     -Virtual::Block(:length => -1, :name => :return)*^*       :codes [Virtual::MethodReturn()]*^*    :receiver Virtual::Self(:index => 3, :type => &6 Virtual::Unknown)"
    check
  end

  def test_puts_string
    @string_input    = <<HERE
def foo()
  puts("Hello")
end
foo()
HERE
    @output = "-&7 Parfait::Method(:name => 'foo', :code => '')*^*  :memory -0*^*   -&1 ['name', 'code', 'arg_names', 'locals', 'tmps']*^*  :arg_names []*^*  :locals []*^*  :tmps []*^*  :info Virtual::CompiledMethodInfo()*^*    :return_type Virtual::Return(:index => 5, :type => *6)*^*    :blocks -Virtual::Block(:length => -1, :name => :enter)*^*       :codes -Virtual::MethodEnter()*^*        -Virtual::NewMessage()*^*        -Virtual::Set()*^*          :to Virtual::NewSelf(:index => 3)*^*            :type &15 Virtual::Reference(:of_class => *2)*^*          :from &17 Virtual::Self(:index => 3)*^*            :type &15 Virtual::Reference(:of_class => *2)*^*        -Virtual::Set(:from => 'puts')*^*          :to Virtual::NewMessageName(:index => 4, :type => *6)*^*        -Virtual::Set(:from => 'Hello')*^*          :to &16 Virtual::Return(:index => 5, :type => &5 Virtual::Reference, :value => 'Hello')*^*        -Virtual::Set()*^*          :to &18 Virtual::NewMessageSlot(:index => 0, :type => &5 Virtual::Reference, :value => *16)*^*          :from &16 Virtual::Return(:index => 5, :type => &5 Virtual::Reference, :value => 'Hello')*^*        -Virtual::MessageSend(:name => :puts)*^*          :me &17 Virtual::Self(:index => 3)*^*            :type &15 Virtual::Reference(:of_class => *2)*^*          :args [*18]*^*     -Virtual::Block(:length => -1, :name => :return)*^*       :codes [Virtual::MethodReturn()]*^*    :receiver Virtual::Self(:index => 3, :type => *6)*^*-Virtual::Return(:index => 5, :type => &6 Virtual::Unknown)"
    check
  end

  def pest_class_function
    @string_input    = <<HERE
def String.length(x)
  @length
end
HERE
    @output = nil
    check
  end

  def test_function_ops
    @string_input    = <<HERE
def foo(x)
 abba = 5
 2 + 5
end
HERE
    @output = "-&7 Parfait::Method(:name => 'foo', :code => '')*^*  :memory -0*^*   -&1 ['name', 'code', 'arg_names', 'locals', 'tmps']*^*  :arg_names [:x]*^*  :locals ['abba']*^*  :tmps []*^*  :info Virtual::CompiledMethodInfo()*^*    :return_type Virtual::Return(:index => 5, :type => &6 Virtual::Unknown)*^*    :blocks -Virtual::Block(:length => -1, :name => :enter)*^*       :codes -Virtual::MethodEnter()*^*        -Virtual::Set()*^*          :to &16 Virtual::Return(:index => 5, :type => &9 Virtual::Integer, :value => *15)*^*          :from &15 Virtual::IntegerConstant(:integer => 5)*^*        -Virtual::Set()*^*          :to Virtual::Return(:index => 5, :type => *6)*^*          :from Virtual::FrameSlot(:index => 1, :type => &9 Virtual::Integer, :value => *16)*^*        -Virtual::Set()*^*          :to &18 Virtual::Return(:index => 5, :type => &9 Virtual::Integer, :value => *17)*^*          :from &17 Virtual::IntegerConstant(:integer => 2)*^*        -Virtual::NewMessage()*^*        -Virtual::Set()*^*          :to Virtual::NewSelf(:index => 3, :type => &9 Virtual::Integer)*^*          :from &18 Virtual::Return(:index => 5, :type => &9 Virtual::Integer, :value => *17)*^*        -Virtual::Set(:from => '+')*^*          :to Virtual::NewMessageName(:index => 4, :type => *6)*^*        -Virtual::Set()*^*          :to &20 Virtual::Return(:index => 5, :type => &9 Virtual::Integer, :value => *19)*^*          :from &19 Virtual::IntegerConstant(:integer => 5)*^*        -Virtual::Set()*^*          :to &21 Virtual::NewMessageSlot(:index => 0, :type => &9 Virtual::Integer, :value => *20)*^*          :from &20 Virtual::Return(:index => 5, :type => &9 Virtual::Integer, :value => *19)*^*        -Virtual::MessageSend(:name => :+)*^*          :me &18 Virtual::Return(:index => 5, :type => &9 Virtual::Integer, :value => *17)*^*          :args [*21]*^*     -Virtual::Block(:length => -1, :name => :return)*^*       :codes [Virtual::MethodReturn()]*^*    :receiver Virtual::Self(:index => 3, :type => &6 Virtual::Unknown)"
    check
  end

  def test_function_ops_simple
    @string_input    = <<HERE
def foo()
  2 + 5
end
HERE
    @output = "-&7 Parfait::Method(:name => 'foo', :code => '')*^*  :memory -0*^*   -&1 ['name', 'code', 'arg_names', 'locals', 'tmps']*^*  :arg_names []*^*  :locals []*^*  :tmps []*^*  :info Virtual::CompiledMethodInfo()*^*    :return_type Virtual::Return(:index => 5, :type => &6 Virtual::Unknown)*^*    :blocks -Virtual::Block(:length => -1, :name => :enter)*^*       :codes -Virtual::MethodEnter()*^*        -Virtual::Set()*^*          :to &16 Virtual::Return(:index => 5, :type => &9 Virtual::Integer, :value => *15)*^*          :from &15 Virtual::IntegerConstant(:integer => 2)*^*        -Virtual::NewMessage()*^*        -Virtual::Set()*^*          :to Virtual::NewSelf(:index => 3, :type => &9 Virtual::Integer)*^*          :from &16 Virtual::Return(:index => 5, :type => &9 Virtual::Integer, :value => *15)*^*        -Virtual::Set(:from => '+')*^*          :to Virtual::NewMessageName(:index => 4, :type => *6)*^*        -Virtual::Set()*^*          :to &18 Virtual::Return(:index => 5, :type => &9 Virtual::Integer, :value => *17)*^*          :from &17 Virtual::IntegerConstant(:integer => 5)*^*        -Virtual::Set()*^*          :to &19 Virtual::NewMessageSlot(:index => 0, :type => &9 Virtual::Integer, :value => *18)*^*          :from &18 Virtual::Return(:index => 5, :type => &9 Virtual::Integer, :value => *17)*^*        -Virtual::MessageSend(:name => :+)*^*          :me &16 Virtual::Return(:index => 5, :type => &9 Virtual::Integer, :value => *15)*^*          :args [*19]*^*     -Virtual::Block(:length => -1, :name => :return)*^*       :codes [Virtual::MethodReturn()]*^*    :receiver Virtual::Self(:index => 3, :type => &6 Virtual::Unknown)"
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
    @output = "-&7 Parfait::Method(:name => 'ofthen', :code => '')*^*  :memory -0*^*   -&1 ['name', 'code', 'arg_names', 'locals', 'tmps']*^*  :arg_names [:n]*^*  :locals ['isit', 'maybenot']*^*  :tmps []*^*  :info Virtual::CompiledMethodInfo()*^*    :return_type &18 Virtual::Return(:index => 5, :type => &9 Virtual::Integer)*^*      :value &19 Virtual::IntegerConstant(:integer => 667)*^*    :blocks -Virtual::Block(:length => -1, :name => :enter)*^*       :codes -Virtual::MethodEnter()*^*        -Virtual::Set()*^*          :to Virtual::Return(:index => 5, :type => *9, :value => *15)*^*          :from &15 Virtual::IntegerConstant(:integer => 0)*^*        -Virtual::IsTrueBranch(:to => *20)*^*     -Virtual::Block(:length => -1, :name => :if_false)*^*       :codes -Virtual::Set(:to => *18, :from => *19)*^*        -Virtual::Set()*^*          :to Virtual::Return(:index => 5, :type => *6)*^*          :from Virtual::FrameSlot(:index => 2, :type => *9, :value => *18)*^*        -Virtual::UnconditionalBranch(:to => *21)*^*     -&20 Virtual::Block(:length => -1, :name => :if_true)*^*       :codes -Virtual::Set()*^*          :to &17 Virtual::Return(:index => 5, :type => *9)*^*            :value &16 Virtual::IntegerConstant(:integer => 42)*^*          :from &16 Virtual::IntegerConstant(:integer => 42)*^*        -Virtual::Set()*^*          :to Virtual::Return(:index => 5, :type => *6)*^*          :from Virtual::FrameSlot(:index => 1, :type => *9)*^*            :value &17 Virtual::Return(:index => 5, :type => *9)*^*              :value &16 Virtual::IntegerConstant(:integer => 42)*^*     -&21 Virtual::Block(:length => -1, :name => :if_merge)*^*       :codes []*^*     -Virtual::Block(:length => -1, :name => :return)*^*       :codes [Virtual::MethodReturn()]*^*    :receiver Virtual::Self(:index => 3, :type => &6 Virtual::Unknown)"
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
    @output = "-Virtual::CompiledMethod(:name => :ofthen, :class_name => 'Object')*^*  :arg_names [:n]*^*  :locals [:isit, :maybenot]*^*  :tmps []*^*  :receiver Virtual::Self(:index => 3, :type => &4 Virtual::Unknown)*^*  :return_type &6 Virtual::Return(:index => 5, :type => &1 Virtual::Integer)*^*    :value &7 Virtual::IntegerConstant(:integer => 667)*^*  :blocks -Virtual::Block(:length => -1, :name => :enter)*^*     :codes -Virtual::MethodEnter(:length => -1)*^*      -Virtual::Set()*^*        :to Virtual::Return(:index => 5, :type => *1, :value => *2)*^*        :from &2 Virtual::IntegerConstant(:integer => 0)*^*      -Virtual::IsTrueBranch(:to => *8)*^*   -Virtual::Block(:length => -1, :name => :if_false)*^*     :codes -Virtual::Set(:to => *6, :from => *7)*^*      -Virtual::Set()*^*        :to Virtual::Return(:index => 5, :type => *4)*^*        :from Virtual::FrameSlot(:index => 2, :type => *1, :value => *6)*^*      -Virtual::UnconditionalBranch(:to => *9)*^*   -&8 Virtual::Block(:length => -1, :name => :if_true)*^*     :codes -Virtual::Set()*^*        :to &5 Virtual::Return(:index => 5, :type => *1)*^*          :value &3 Virtual::IntegerConstant(:integer => 42)*^*        :from &3 Virtual::IntegerConstant(:integer => 42)*^*      -Virtual::Set()*^*        :to Virtual::Return(:index => 5, :type => *4)*^*        :from Virtual::FrameSlot(:index => 1, :type => *1)*^*          :value &5 Virtual::Return(:index => 5, :type => *1)*^*            :value &3 Virtual::IntegerConstant(:integer => 42)*^*   -&9 Virtual::Block(:length => -1, :name => :if_merge)*^*     :codes []*^*   -Virtual::Block(:length => -1, :name => :return)*^*     :codes -Virtual::MethodReturn(:length => -1)"
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
