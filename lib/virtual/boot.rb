module Virtual

  # Booting is a complicated, so it is extracted into this file, even it has only one entry point

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
      # map from the vm - class_name to the Parfait class (which carries parfait name)
      class_mappings = {}        #will later become instance variable

      values = [  "Value"  , "Integer" , "Kernel" ,  "Object"].collect {|cl| Virtual.new_word(cl) }
      value_classes = values.collect { |cl| @space.create_class(cl,nil) }
      layouts = { "Word" => [] ,
                  "List" => [] ,
                  "Message" => [],
                  "Space" => ["classes","objects","frames","messages","next_message","next_frame"],
                  "Frame" => ["locals" , "tmps" ],
                  "Layout" => ["object_class"] ,
                  "Class" => ["object_layout"],
                  "Dictionary" => ["keys" , "values"] ,
                  "Method" => ["name" , "arg_names" , "locals" , "tmps"] ,
                  "Module" => ["name" , "instance_methods", "super_class", "meta_class"]
                }
      layouts.each do |name , layout|
        class_mappings[name] = @space.create_class(Virtual.new_word(name) , nil)
      end
      value_classes[1].set_super_class( value_classes[0] ) # #set superclass (value) for integer
      value_classes[2].set_super_class( value_classes[0] ) # and kernel (TODO is module)
      value_classes[3].set_super_class( value_classes[2] ) # and object (TODO hacked to kernel)
      class_mappings.each do |name , clazz|                # and the rest
        clazz.set_super_class(value_classes[3])            # superclasses are object
      end
      # next create layouts by adding instance variable names to the layouts
      class_mappings.each do |name , clazz|
        variables = layouts[name]
        variables.each do |var_name|
          clazz.object_layout.add_instance_variable Virtual.new_word(var_name)
        end
      end
      # now store the classes so we can hand them out later during object creation
      # this can not be done earlier, as parfait objects are all the time created and would
      #   lookup half created class info
      # but it must be done before going through the objects (next step)
      @class_mappings = class_mappings
      class_mappings["Integer"] = value_classes[1]  #need for further booting
      class_mappings["Kernel"] = value_classes[2]  #need for further booting
      class_mappings["Object"] = value_classes[3]  #need for further booting

      # now update the layout on all objects created so far,
      # go through objects in space
      @space.objects.each do | o |
        o.init_layout
      end
      # and go through the space instance variables which get created before the object list
      @space.init_layout
      @space.classes.init_layout
      @space.objects.init_layout
      @space.late_init
      boot_functions!
    end

    # classes have booted, now create a minimal set of functions
    # minimal means only that which can not be coded in ruby
    # Methods are grabbed from respective modules by sending the method name. This should return the
    # implementation of the method (ie a method object), not actually try to implement it
    #                                                     (as that's impossible in ruby)
    def boot_functions!
      # very fiddly chicken 'n egg problem. Functions need to be in the right order, and in fact we
      # have to define some dummies, just for the other to compile
      # TODO: go through the virtual parfait layer and adjust function names to what they really are
      obj = @class_mappings["Object"]
      [:index_of , :_get_instance_variable , :_set_instance_variable].each do |f|
        obj.add_instance_method Builtin::Object.send(f , nil)
      end
      obj = @class_mappings["Kernel"]
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
      obj = @class_mappings["Integer"]
      [:putint,:fibo].each do |f|
        obj.add_instance_method Builtin::Integer.send(f , nil)
      end
    end
  end
end
