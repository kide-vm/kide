
# A message is what is created when a message is sent. Args and stuff are packed up in to a
# Message and the Message is activated (by swapping it into the machine).

# Part of the housekeeping (see attributes) makes messages a double linked list (next_message and
# caller) , and maybe surprisingly this means that we can create all messages at compile-time
# and link them up and never have to touch that list again.
# All the args and receiver data changes, but the list of messages stays constant
#  (a pleasant stupor while we ignore closures and longer extended frames ).

module Parfait
  class Message < Object

    # :next_message => :Message, :receiver => :Object, :frame => :NamedList ,
    # :return_address => :Integer, :return_value => :Integer,
    # :caller => :Message , :name => :Word , :arguments => :NamedList

    attr  :type, :next_message
    attr  :receiver  , :frame
    attr  :return_address, :return_value
    attr  :caller , :method
    attr  :arguments_given
    attr  :arg1 , :arg2, :arg3, :arg4, :arg5, :arg6

    def self.type_length
      16
    end
    def self.memory_size
      32
    end
    def self.args_start_at
      Parfait.object_space.get_type_by_class_name(:Message).variable_index(:arguments_given)
    end

    def initialize(  )
      super()
      self.frame = NamedList.new()
      self.arguments_given = Parfait::Integer.new(0)
    end
    public :initialize

    def set_receiver(rec)
      self.receiver = rec
    end

    def set_caller(caller)
      caller = caller
    end

    def get_type_for(name)
      index = type.get_index(name)
      get_at(index)
    end
    def to_s
      "Message:#{method&.name}(#{arguments.get_length})"
    end
  end
end
