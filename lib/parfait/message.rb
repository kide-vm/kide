
# A message is what is created when a message is sent. Args and stuff are packed up in to a
# Message and the Message is activated (by swapping it into the machine).

# Part of the housekeeping (see attributes) makes messages a double linked list (next_message and
#  caller) , and maybe surprisingly this means that we can create all messages at runtime
# and link them up and never have to touch that list again.
# All the args and receiver data changes, but the list of messages stays constant.

module Parfait
  class Message < Object

    # :next_message => :Message, :receiver => :Object, :frame => :NamedList ,
    # :return_address => :Integer, :return_value => :Integer,
    # :caller => :Message , :name => :Word , :arguments => :NamedList

    attr_accessor :next_message
    attr_reader   :receiver  , :frame
    attr_reader   :return_address, :return_value
    attr_reader   :caller , :name , :arguments

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
