module Virtual

  # Remove all functions that are not called
  # Not called is approximated by the fact that the method name doesn't show up
  # in any function reachable from main
  class Minimizer
    def run
      @gonners = []
      Parfait::Space.object_space.classes.values.each do |c|
        c.instance_methods.each do |f|
          @gonners << f
        end
      end
      keep Virtual.machine.space.get_init
      remove_remaining
    end

    def keep function
      index = @gonners.index function
      unless index
        puts "function was already removed #{function.name}"
        return
      end
      #puts "stayer #{function.name}"
      @gonners.delete function
      function.source.blocks.each do |block|
        block.codes.each do |code|
          if code.is_a? Virtual::MessageSend
            @gonners.dup.each do |stay|
              keep stay if(stay.name == code.name)
            end
          end
          keep code.method if code.is_a? Virtual::MethodCall
        end
      end
    end

    def remove_remaining
      @gonners.each do |method|
        next if(method.name == :plus)
        method.for_class.remove_instance_method method.name
      end
    end
  end
end
