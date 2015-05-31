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
      init= Parfait::Space.object_space.get_class_by_name(:Kernel).get_instance_method :__init__
      remove init
      dump_remaining
    end

    def remove function
      index = @gonners.index function
      unless index
        puts "function was already removed #{ function.name}"
        return
      end
      @gonners.delete function
      function.info.blocks.each do |block|
        block.codes.each do |code|
          if code.is_a? Virtual::MessageSend
            str_name = code.name.to_s
            @gonners.each do |stay|
              remove stay if(stay.name == str_name)
            end
          end
          remove code.method if code.is_a? Virtual::MethodCall
        end
      end
    end

    def dump_remaining
      @gonners.each do |method|
        method.for_class.remove_instance_method method
      end
    end
  end
end
