
# A message is what is sent when you invoke a method. Args and stuff are packed up in to a Message
# and the Message is sent to the receiver.

class Message

  def get_type_for(name)
    index = @layout.get_index(name)
    get_at(index)
  end

  def __send
    typ = get_type_for( :receiver )
    # TODO: this will obviously be recoded as case, once that is done :-)
    # depending on value type get method
    if( typ == Integer )
      method = Integer.get_method @method_name
    else
      if( typ != ObjectReference )
        raise "unimplemented case"
      else
        method = @receiver.get_singeton_method @method_name
        # Find the method for the given object (receiver) according to ruby dispatch rules:
          # - see if the receiver object has a (singleton) method by the name
          # - get receivers class and look for instance methods of the name
          # - go up inheritance tree
          # - start over with method_missing instead
          #    -> guaranteed to end at object.method_missing 
        unless method
          cl = @receiver.layout.object_class
          method = cl.get_instance_or_super_method @method_name
        end
      end
    end
    unless method
      message = Message.new( @receiver , :method_missing , [@method_name] + @args)
      message.send
    else
      method.call
    end
  end
end
