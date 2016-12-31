
# A message is what is sent when you invoke a method. Args and stuff are packed up in to a Message
# and the Message is sent to the receiver.

# Part of the housekeeping (see attributes) makes messages a double linked list (next_message and
#  caller) , and maybe surprisingly this means that we can create all messages at runtime
# and link them up and never have to touch that list again.
# All the args and receiver data changes, but the list of messages stays constant.

module Parfait
  class Message < Object

    attr_reader :locals , :receiver  , :return_value , :name
    attr_accessor :next_message

    def initialize next_m
      @next_message = next_m
      @locals = NamedList.new()
      @arguments = NamedList.new()
      super()
    end

    def set_receiver(rec)
      @receiver = rec
    end

    def set_caller(caller)
      @caller = caller
    end

    def get_type_for(name)
      index = @type.get_index(name)
      get_at(index)
    end
  end
end
