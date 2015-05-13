require_relative "virtual_helper"

class TestMethods < MiniTest::Test
  include VirtualHelper

  def test_object
    @string_input    = <<HERE
class Object
  def get_class()
    @layout.get_class()
  end
end
HERE
    @output = "-&5 Virtual::BootClass(:length => -1, :name => :Object, :super_class_name => :Object)*^*  :instance_methods -Virtual::CompiledMethod(:name => :index_of, :class_name => :Object, :arg_names => &1 Virtual::Reference, :return_type => Virtual::Integer)*^*     :locals []*^*     :tmps []*^*     :receiver [*1]*^*     :blocks -Virtual::Block(:length => -1, :name => :enter)*^*        :codes -Virtual::MethodEnter(:length => -1)*^*      -Virtual::Block(:length => -1, :name => :return)*^*        :codes -Virtual::MethodReturn(:length => -1)*^*   -Virtual::CompiledMethod(:name => :_get_instance_variable, :class_name => :Object, :receiver => &1 Virtual::Reference, :return_type => &2 Virtual::Mystery)*^*     :arg_names [*1]*^*     :locals []*^*     :tmps []*^*     :blocks -Virtual::Block(:length => -1, :name => :enter)*^*        :codes -Virtual::MethodEnter(:length => -1)*^*      -Virtual::Block(:length => -1, :name => :return)*^*        :codes -Virtual::MethodReturn(:length => -1)*^*   -Virtual::CompiledMethod(:name => :_set_instance_variable, :class_name => :Object, :receiver => &1 Virtual::Reference, :return_type => &2 Virtual::Mystery)*^*     :arg_names [*1, *1]*^*     :locals []*^*     :tmps []*^*     :blocks -Virtual::Block(:length => -1, :name => :enter)*^*        :codes -Virtual::MethodEnter(:length => -1)*^*      -Virtual::Block(:length => -1, :name => :return)*^*        :codes -Virtual::MethodReturn(:length => -1)*^*   -&4 Virtual::CompiledMethod(:name => :get_class, :class_name => :Object)*^*     :arg_names []*^*     :locals []*^*     :tmps []*^*     :receiver Virtual::Self(:index => 3, :type => *2)*^*     :return_type Virtual::Return(:index => 5, :type => *2)*^*     :blocks -Virtual::Block(:length => -1, :name => :enter)*^*        :codes -Virtual::MethodEnter(:length => -1)*^*         -Virtual::InstanceGet(:name => :layout)*^*         -Virtual::NewMessage(:length => -1)*^*         -Virtual::Set()*^*           :to Virtual::NewSelf(:index => 3, :type => *2)*^*           :from &3 Virtual::Return(:index => 5, :type => *2)*^*         -Virtual::Set()*^*           :to Virtual::NewName(:index => 4, :type => *2)*^*           :from Parfait::Word(:string => :get_class)*^*         -Virtual::MessageSend(:name => :get_class)*^*           :me &3 Virtual::Return(:index => 5, :type => *2)*^*           :args []*^*      -Virtual::Block(:length => -1, :name => :return)*^*        :codes -Virtual::MethodReturn(:length => -1)*^*   -&4 Virtual::CompiledMethod(:name => :get_class, :class_name => :Object)*^*     :arg_names []*^*     :locals []*^*     :tmps []*^*     :receiver Virtual::Self(:index => 3, :type => *2)*^*     :return_type Virtual::Return(:index => 5, :type => *2)*^*     :blocks -Virtual::Block(:length => -1, :name => :enter)*^*        :codes -Virtual::MethodEnter(:length => -1)*^*         -Virtual::InstanceGet(:name => :layout)*^*         -Virtual::NewMessage(:length => -1)*^*         -Virtual::Set()*^*           :to Virtual::NewSelf(:index => 3, :type => *2)*^*           :from &3 Virtual::Return(:index => 5, :type => *2)*^*         -Virtual::Set()*^*           :to Virtual::NewName(:index => 4, :type => *2)*^*           :from Parfait::Word(:string => :get_class)*^*         -Virtual::MessageSend(:name => :get_class)*^*           :me &3 Virtual::Return(:index => 5, :type => *2)*^*           :args []*^*      -Virtual::Block(:length => -1, :name => :return)*^*        :codes -Virtual::MethodReturn(:length => -1)*^*  :meta_class Virtual::MetaClass(:length => -1, :me_self => *5)*^*    :functions []"
    check
  end

  def test_message_tpye
    @string_input    = <<HERE
class Message
  def get_type_for(name)
    index = @layout.get_index(name)
    get_at(index)
  end
end
HERE
    @output = ""
    check
  end

end
