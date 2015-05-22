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

      values = [  "Value"  , "Integer" , "Kernel" ,  "Object"].collect {|cl| Virtual.new_word(cl) }
      value_classes = values.collect { |cl| @space.create_class(cl) }
      rest = [ "Word", "Space", "Layout", "Module" ,
                "Class" , "Dictionary", "List"]
      rest_layouts = { Virtual.new_word("Word") => [] ,
                       Virtual.new_word("Space") => ["classes","objects"],
                       Virtual.new_word("Layout") => ["object_class"] ,
                       Virtual.new_word("Module") => ["name","instance_methods", "super_class", "meta_class"],
                       Virtual.new_word("Class") => ["object_layout"],
                       Virtual.new_word("Dictionary") => ["keys" , "values"],
                       Virtual.new_word("List") => [] }
      rest_classes = rest_layouts.collect { |cl , lay| @space.create_class(cl) }
      rest_classes[1].set_super_class( value_classes[0] ) # #set superclass for object
      rest_classes[3].set_super_class( value_classes[0] ) # and integer
      rest_classes.each do |cl|                         # and the rest
        cl.set_super_class(value_classes[3])
      end
      # next create layouts by adding instance variable names to the layouts
      rest_classes.each do |cl|
        name = cl.name
        variables = rest_layouts[name]
        variables.each do |var_name|
          cl.object_layout.add_instance_variable Virtual.new_word(var_name)
        end
      end
      # now update the layout on all objects created so far,
      # go through objects in space
      @space.objects.each do | o |
        vm_name = o.class.name.split("::").last
        index = rest.index(vm_name)
        raise "Class not found #{o.class}" unless index
        o.set_layout rest_classes[index].object_layout
        puts "index #{index}"
      end
      # and go through the space instance variables which get created before the object list
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
      obj = @space.get_class_by_name Virtual.new_word "Word"
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
