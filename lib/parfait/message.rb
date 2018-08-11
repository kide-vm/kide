
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

    attr   :type, :next_message
    attr   :receiver  , :frame
    attr   :return_address, :return_value
    attr   :caller , :method , :arguments

    def self.type_length
      9
    end
    def self.memory_size
      16
    end

    def initialize( next_m )
      super()
      self.next_message = next_m
      self.frame = NamedList.new()
      self.arguments = NamedList.new()
    end

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
