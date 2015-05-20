require_relative "virtual_helper"

class TestMethods < MiniTest::Test
  include VirtualHelper

  def test_simplest_function
    @string_input    = <<HERE
def foo(x)
  5
end
HERE
    @output = "-&2 Parfait::Method(:name => Parfait::Word('foo'))*^*  :arg_names [:x]*^*  :locals []*^*  :tmps []*^*  :for_class &1 Parfait::Class(:name => Parfait::Word('Object'))*^*    :instance_methods -Parfait::Method(:name => Parfait::Word('main'), :for_class => *1)*^*       :arg_names []*^*       :locals []*^*       :tmps []*^*       :info Virtual::CompiledMethodInfo(:return_type => *6)*^*         :blocks -Virtual::Block(:length => -1, :name => :enter)*^*            :codes -Virtual::MethodEnter(:length => -1)*^*          -Virtual::Block(:length => -1, :name => :return)*^*            :codes -Virtual::MethodReturn(:length => -1)*^*     -*2*^*    :super_class &3 Parfait::Class(:name => Parfait::Word('Value'))*^*      :instance_methods []*^*      :meta_class Virtual::MetaClass(:me_self => *3)*^*        :functions []*^*      :object_layout []*^*    :meta_class Virtual::MetaClass(:me_self => *1)*^*      :functions []*^*    :object_layout []*^*  :info Virtual::CompiledMethodInfo()*^*    :return_type &4 Virtual::Return(:index => 5, :type => Virtual::Integer)*^*      :value &5 Virtual::IntegerConstant(:integer => 5)*^*    :blocks -Virtual::Block(:length => -1, :name => :enter)*^*       :codes -Virtual::MethodEnter(:length => -1)*^*        -Virtual::Set(:to => *4, :from => *5)*^*     -Virtual::Block(:length => -1, :name => :return)*^*       :codes -Virtual::MethodReturn(:length => -1)*^*    :receiver Virtual::Self(:index => 3, :type => &6 Virtual::Mystery)"
    check
  end

  def test_puts_string
    @string_input    = <<HERE
def foo()
  puts("Hello")
end
foo()
HERE
    @output = "-&4 Parfait::Method(:name => Parfait::Word('foo'))*^*  :arg_names []*^*  :locals []*^*  :tmps []*^*  :for_class &1 Parfait::Class(:name => Parfait::Word('Object'))*^*    :instance_methods -Parfait::Method(:name => Parfait::Word('main'), :for_class => *1)*^*       :arg_names []*^*       :locals []*^*       :tmps []*^*       :info Virtual::CompiledMethodInfo(:return_type => *2)*^*         :blocks -Virtual::Block(:length => -1, :name => :enter)*^*            :codes -Virtual::MethodEnter(:length => -1)*^*             -Virtual::NewMessage(:length => -1)*^*             -Virtual::Set()*^*               :to Virtual::NewSelf(:index => 3, :type => *2)*^*               :from &3 Virtual::Self(:index => 3, :type => *2)*^*             -Virtual::Set(:from => Parfait::Word('foo'))*^*               :to Virtual::NewName(:index => 4, :type => *2)*^*             -Virtual::MessageSend(:name => :foo)*^*               :me &3 Virtual::Self(:index => 3, :type => *2)*^*               :args []*^*          -Virtual::Block(:length => -1, :name => :return)*^*            :codes -Virtual::MethodReturn(:length => -1)*^*     -*4*^*    :super_class &5 Parfait::Class(:name => Parfait::Word('Value'))*^*      :instance_methods []*^*      :meta_class Virtual::MetaClass(:me_self => *5)*^*        :functions []*^*      :object_layout []*^*    :meta_class Virtual::MetaClass(:me_self => *1)*^*      :functions []*^*    :object_layout []*^*  :info Virtual::CompiledMethodInfo()*^*    :return_type Virtual::Return(:index => 5, :type => *2)*^*    :blocks -Virtual::Block(:length => -1, :name => :enter)*^*       :codes -Virtual::MethodEnter(:length => -1)*^*        -Virtual::NewMessage(:length => -1)*^*        -Virtual::Set()*^*          :to Virtual::NewSelf(:index => 3, :type => *2)*^*          :from &8 Virtual::Self(:index => 3, :type => *2)*^*        -Virtual::Set(:from => Parfait::Word('puts'))*^*          :to Virtual::NewName(:index => 4, :type => *2)*^*        -Virtual::Set(:from => Parfait::Word('Hello'))*^*          :to &7 Virtual::Return(:index => 5, :type => &6 Virtual::Reference, :value => Parfait::Word('Hello'))*^*        -Virtual::Set()*^*          :to &9 Virtual::NewMessageSlot(:index => 0, :type => &6 Virtual::Reference, :value => *7)*^*          :from &7 Virtual::Return(:index => 5, :type => &6 Virtual::Reference, :value => Parfait::Word('Hello'))*^*        -Virtual::MessageSend(:name => :puts)*^*          :me &8 Virtual::Self(:index => 3, :type => *2)*^*          :args [*9]*^*     -Virtual::Block(:length => -1, :name => :return)*^*       :codes -Virtual::MethodReturn(:length => -1)*^*    :receiver Virtual::Self(:index => 3, :type => *2)*^*-Virtual::Return(:index => 5, :type => &2 Virtual::Mystery)"
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
    @output = "-&2 Parfait::Method(:name => Parfait::Word('foo'))*^*  :arg_names [:x]*^*  :locals [Parfait::Word('abba')]*^*  :tmps []*^*  :for_class &1 Parfait::Class(:name => Parfait::Word('Object'))*^*    :instance_methods -Parfait::Method(:name => Parfait::Word('main'), :for_class => *1)*^*       :arg_names []*^*       :locals []*^*       :tmps []*^*       :info Virtual::CompiledMethodInfo(:return_type => *4)*^*         :blocks -Virtual::Block(:length => -1, :name => :enter)*^*            :codes -Virtual::MethodEnter(:length => -1)*^*          -Virtual::Block(:length => -1, :name => :return)*^*            :codes -Virtual::MethodReturn(:length => -1)*^*     -*2*^*    :super_class &3 Parfait::Class(:name => Parfait::Word('Value'))*^*      :instance_methods []*^*      :meta_class Virtual::MetaClass(:me_self => *3)*^*        :functions []*^*      :object_layout []*^*    :meta_class Virtual::MetaClass(:me_self => *1)*^*      :functions []*^*    :object_layout []*^*  :info Virtual::CompiledMethodInfo()*^*    :return_type Virtual::Return(:index => 5, :type => &4 Virtual::Mystery)*^*    :blocks -Virtual::Block(:length => -1, :name => :enter)*^*       :codes -Virtual::MethodEnter(:length => -1)*^*        -Virtual::Set()*^*          :to &7 Virtual::Return(:index => 5, :type => &6 Virtual::Integer, :value => *5)*^*          :from &5 Virtual::IntegerConstant(:integer => 5)*^*        -Virtual::Set()*^*          :to Virtual::Return(:index => 5, :type => *4)*^*          :from Virtual::FrameSlot(:index => 1, :type => &6 Virtual::Integer, :value => *7)*^*        -Virtual::Set()*^*          :to &9 Virtual::Return(:index => 5, :type => &6 Virtual::Integer, :value => *8)*^*          :from &8 Virtual::IntegerConstant(:integer => 2)*^*        -Virtual::NewMessage(:length => -1)*^*        -Virtual::Set()*^*          :to Virtual::NewSelf(:index => 3, :type => &6 Virtual::Integer)*^*          :from &9 Virtual::Return(:index => 5, :type => &6 Virtual::Integer, :value => *8)*^*        -Virtual::Set(:from => Parfait::Word('+'))*^*          :to Virtual::NewName(:index => 4, :type => *4)*^*        -Virtual::Set()*^*          :to &11 Virtual::Return(:index => 5, :type => &6 Virtual::Integer, :value => *10)*^*          :from &10 Virtual::IntegerConstant(:integer => 5)*^*        -Virtual::Set()*^*          :to &12 Virtual::NewMessageSlot(:index => 0, :type => &6 Virtual::Integer, :value => *11)*^*          :from &11 Virtual::Return(:index => 5, :type => &6 Virtual::Integer, :value => *10)*^*        -Virtual::MessageSend(:name => :+)*^*          :me &9 Virtual::Return(:index => 5, :type => &6 Virtual::Integer, :value => *8)*^*          :args [*12]*^*     -Virtual::Block(:length => -1, :name => :return)*^*       :codes -Virtual::MethodReturn(:length => -1)*^*    :receiver Virtual::Self(:index => 3, :type => &4 Virtual::Mystery)"
    check
  end

  def test_function_ops_simple
    @string_input    = <<HERE
def foo()
  2 + 5
end
HERE
    @output = "-&2 Parfait::Method(:name => Parfait::Word('foo'))*^*  :arg_names []*^*  :locals []*^*  :tmps []*^*  :for_class &1 Parfait::Class(:name => Parfait::Word('Object'))*^*    :instance_methods -Parfait::Method(:name => Parfait::Word('main'), :for_class => *1)*^*       :arg_names []*^*       :locals []*^*       :tmps []*^*       :info Virtual::CompiledMethodInfo(:return_type => *4)*^*         :blocks -Virtual::Block(:length => -1, :name => :enter)*^*            :codes -Virtual::MethodEnter(:length => -1)*^*          -Virtual::Block(:length => -1, :name => :return)*^*            :codes -Virtual::MethodReturn(:length => -1)*^*     -*2*^*    :super_class &3 Parfait::Class(:name => Parfait::Word('Value'))*^*      :instance_methods []*^*      :meta_class Virtual::MetaClass(:me_self => *3)*^*        :functions []*^*      :object_layout []*^*    :meta_class Virtual::MetaClass(:me_self => *1)*^*      :functions []*^*    :object_layout []*^*  :info Virtual::CompiledMethodInfo()*^*    :return_type Virtual::Return(:index => 5, :type => &4 Virtual::Mystery)*^*    :blocks -Virtual::Block(:length => -1, :name => :enter)*^*       :codes -Virtual::MethodEnter(:length => -1)*^*        -Virtual::Set()*^*          :to &7 Virtual::Return(:index => 5, :type => &6 Virtual::Integer, :value => *5)*^*          :from &5 Virtual::IntegerConstant(:integer => 2)*^*        -Virtual::NewMessage(:length => -1)*^*        -Virtual::Set()*^*          :to Virtual::NewSelf(:index => 3, :type => &6 Virtual::Integer)*^*          :from &7 Virtual::Return(:index => 5, :type => &6 Virtual::Integer, :value => *5)*^*        -Virtual::Set(:from => Parfait::Word('+'))*^*          :to Virtual::NewName(:index => 4, :type => *4)*^*        -Virtual::Set()*^*          :to &9 Virtual::Return(:index => 5, :type => &6 Virtual::Integer, :value => *8)*^*          :from &8 Virtual::IntegerConstant(:integer => 5)*^*        -Virtual::Set()*^*          :to &10 Virtual::NewMessageSlot(:index => 0, :type => &6 Virtual::Integer, :value => *9)*^*          :from &9 Virtual::Return(:index => 5, :type => &6 Virtual::Integer, :value => *8)*^*        -Virtual::MessageSend(:name => :+)*^*          :me &7 Virtual::Return(:index => 5, :type => &6 Virtual::Integer, :value => *5)*^*          :args [*10]*^*     -Virtual::Block(:length => -1, :name => :return)*^*       :codes -Virtual::MethodReturn(:length => -1)*^*    :receiver Virtual::Self(:index => 3, :type => &4 Virtual::Mystery)"
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
    @output = "-&2 Parfait::Method(:name => Parfait::Word('ofthen'))*^*  :arg_names [:n]*^*  :locals [Parfait::Word('isit'), Parfait::Word('maybenot')]*^*  :tmps []*^*  :for_class &1 Parfait::Class(:name => Parfait::Word('Object'))*^*    :instance_methods -Parfait::Method(:name => Parfait::Word('main'), :for_class => *1)*^*       :arg_names []*^*       :locals []*^*       :tmps []*^*       :info Virtual::CompiledMethodInfo(:return_type => *7)*^*         :blocks -Virtual::Block(:length => -1, :name => :enter)*^*            :codes -Virtual::MethodEnter(:length => -1)*^*          -Virtual::Block(:length => -1, :name => :return)*^*            :codes -Virtual::MethodReturn(:length => -1)*^*     -*2*^*    :super_class &3 Parfait::Class(:name => Parfait::Word('Value'))*^*      :instance_methods []*^*      :meta_class Virtual::MetaClass(:me_self => *3)*^*        :functions []*^*      :object_layout []*^*    :meta_class Virtual::MetaClass(:me_self => *1)*^*      :functions []*^*    :object_layout []*^*  :info Virtual::CompiledMethodInfo()*^*    :return_type &9 Virtual::Return(:index => 5, :type => &4 Virtual::Integer)*^*      :value &10 Virtual::IntegerConstant(:integer => 667)*^*    :blocks -Virtual::Block(:length => -1, :name => :enter)*^*       :codes -Virtual::MethodEnter(:length => -1)*^*        -Virtual::Set()*^*          :to Virtual::Return(:index => 5, :type => *4, :value => *5)*^*          :from &5 Virtual::IntegerConstant(:integer => 0)*^*        -Virtual::IsTrueBranch(:to => *11)*^*     -Virtual::Block(:length => -1, :name => :if_false)*^*       :codes -Virtual::Set(:to => *9, :from => *10)*^*        -Virtual::Set()*^*          :to Virtual::Return(:index => 5, :type => *7)*^*          :from Virtual::FrameSlot(:index => 2, :type => *4, :value => *9)*^*        -Virtual::UnconditionalBranch(:to => *12)*^*     -&11 Virtual::Block(:length => -1, :name => :if_true)*^*       :codes -Virtual::Set()*^*          :to &8 Virtual::Return(:index => 5, :type => *4)*^*            :value &6 Virtual::IntegerConstant(:integer => 42)*^*          :from &6 Virtual::IntegerConstant(:integer => 42)*^*        -Virtual::Set()*^*          :to Virtual::Return(:index => 5, :type => *7)*^*          :from Virtual::FrameSlot(:index => 1, :type => *4)*^*            :value &8 Virtual::Return(:index => 5, :type => *4)*^*              :value &6 Virtual::IntegerConstant(:integer => 42)*^*     -&12 Virtual::Block(:length => -1, :name => :if_merge)*^*       :codes []*^*     -Virtual::Block(:length => -1, :name => :return)*^*       :codes -Virtual::MethodReturn(:length => -1)*^*    :receiver Virtual::Self(:index => 3, :type => &7 Virtual::Mystery)"
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
    @output = "-Virtual::CompiledMethod(:name => :ofthen, :class_name => 'Object')*^*  :arg_names [:n]*^*  :locals [:isit, :maybenot]*^*  :tmps []*^*  :receiver Virtual::Self(:index => 3, :type => &4 Virtual::Mystery)*^*  :return_type &6 Virtual::Return(:index => 5, :type => &1 Virtual::Integer)*^*    :value &7 Virtual::IntegerConstant(:integer => 667)*^*  :blocks -Virtual::Block(:length => -1, :name => :enter)*^*     :codes -Virtual::MethodEnter(:length => -1)*^*      -Virtual::Set()*^*        :to Virtual::Return(:index => 5, :type => *1, :value => *2)*^*        :from &2 Virtual::IntegerConstant(:integer => 0)*^*      -Virtual::IsTrueBranch(:to => *8)*^*   -Virtual::Block(:length => -1, :name => :if_false)*^*     :codes -Virtual::Set(:to => *6, :from => *7)*^*      -Virtual::Set()*^*        :to Virtual::Return(:index => 5, :type => *4)*^*        :from Virtual::FrameSlot(:index => 2, :type => *1, :value => *6)*^*      -Virtual::UnconditionalBranch(:to => *9)*^*   -&8 Virtual::Block(:length => -1, :name => :if_true)*^*     :codes -Virtual::Set()*^*        :to &5 Virtual::Return(:index => 5, :type => *1)*^*          :value &3 Virtual::IntegerConstant(:integer => 42)*^*        :from &3 Virtual::IntegerConstant(:integer => 42)*^*      -Virtual::Set()*^*        :to Virtual::Return(:index => 5, :type => *4)*^*        :from Virtual::FrameSlot(:index => 1, :type => *1)*^*          :value &5 Virtual::Return(:index => 5, :type => *1)*^*            :value &3 Virtual::IntegerConstant(:integer => 42)*^*   -&9 Virtual::Block(:length => -1, :name => :if_merge)*^*     :codes []*^*   -Virtual::Block(:length => -1, :name => :return)*^*     :codes -Virtual::MethodReturn(:length => -1)"
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
