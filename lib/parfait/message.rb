# this is not a "normal" ruby file, ie it is not required by salama
# instead it is parsed by salama to define part of the program that runs

class Message
  def send
    # Find the method for the given object (receiver) according to ruby dispatch rules:
      # - see if the receiver object has a (singleton) method by the name
      # - get receivers class and look for instance methods of the name
      # - go up inheritance tree
      # - start over with method_missing instead
      #    -> guaranteed to end at object.method_missing 
    method = @receiver.get_singeton_method @method_name
    unless method
      cl = @receiver.layout.object_class
      method = cl.get_instance_or_super_method @method_name
    end
    unless method
      message = Message.new( @receiver , :method_missing , [@method_name] + @args)
      message.send
    else
      method.call
    end
  end
end
