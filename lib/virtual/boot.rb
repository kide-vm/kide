module Virtual

  class Machine

    # The general idea is that compiling is creating an object graph. Functionally
    # one tends to think of methods, and that is complicated enough, sure.
    # but for an object system the graph includes classes and all instance variables
    #
    # And so we have a chicken and egg problem. At the end of the function we want to have a
    # working Space object
    # But that has instance variables (List and Dictionary) and off course a class.
    # Or more precisely in salama, a Layout, that points to a class.
    # So we need a Layout, but that has Layout and Class too. hmmm
    #
    # The way out is to build empty shell objects and stuff the neccessary data into them
    #  (not use the normal initialize way)
    def boot_parfait!
      @space = Parfait::Space.new_object
      object_class = Parfait::Class.new_object "Parfait::Object"
      space_class = Parfait::Class.new_object "Parfait::Space" , object_class
      space_layout = Parfait::Layout.new_object space_class

      puts "Space #{space.get_layout}"
    end

    def boot_classes!
      puts "BOOT"
      values = [ "Integer" , "Object" , "Value" , "Kernel"]
      rest = ["Word" , "Class" , "Dictionary" , "Space" , "List", "Layout"]
      (values + rest).each { |cl| @space.create_class(cl) }
      value_class = @space.get_class_by_name "Value"
      @space.get_class_by_name("Integer").set_super_class( value_class )
      object_class = @space.get_class_by_name("Object")
      object_class.set_super_class( value_class )
      rest.each do |name|
          cl = @space.get_class_by_name( name )
          cl.set_super_class(object_class)
      end
      boot_layouts!
    end
    def boot_layouts!

    end

    # boot the classes, ie create a minimal set of classes with a minimal set of functions
    # minimal means only that which can not be coded in ruby
    # CompiledMethods are grabbed from respective modules by sending the method name. This should return the
    # implementation of the method (ie a method object), not actually try to implement it (as that's impossible in ruby)
    def boot_functions!
      @space =  Parfait::Space.new
      boot_classes!
      # very fiddly chicken 'n egg problem. Functions need to be in the right order, and in fact we
      # have to define some dummies, just for the other to compile
      # TODO: go through the virtual parfait layer and adjust function names to what they really are
      obj = @space.get_class_by_name "Object"
      [:index_of , :_get_instance_variable , :_set_instance_variable].each do |f|
        obj.add_instance_method Builtin::Object.send(f , nil)
      end
      obj = @space.get_class_by_name "Kernel"
      # create main first, __init__ calls it
      @main = Builtin::Kernel.send(:main , @context)
      obj.add_instance_method @main
      underscore_init = Builtin::Kernel.send(:__init__ ,nil) #store , so we don't have to resolve it below
      obj.add_instance_method underscore_init
      [:putstring,:exit,:__send].each do |f|
        obj.add_instance_method Builtin::Kernel.send(f , nil)
      end
      # and the @init block in turn _jumps_ to __init__
      # the point of which is that by the time main executes, all is "normal"
      @init = Block.new(:_init_ , nil )
      @init.add_code(Register::RegisterMain.new(underscore_init))
      obj = @space.get_class_by_name "Integer"
      [:putint,:fibo].each do |f|
        obj.add_instance_method Builtin::Integer.send(f , nil)
      end
      obj = @space.get_class_by_name "Word"
      [:get , :set , :puts].each do |f|
        obj.add_instance_method Builtin::Word.send(f , nil)
      end
      obj = space.get_class_by_name "List"
      [:get , :set , :push].each do |f|
        obj.add_instance_method Builtin::Array.send(f , nil)
      end
    end
  end
end
