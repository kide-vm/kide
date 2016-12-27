module Register

  # Booting is complicated, so it is extracted into this file, even it has only one entry point

  class Machine

    # The general idea is that compiling is creating an object graph. Functionally
    # one tends to think of methods, and that is complicated enough, sure.
    # But for an object system the graph includes classes and all instance variables
    #
    # And so we have a chicken and egg problem. At the end of the boot function we want to have a
    # working Space object
    # But that has instance variables (List and Dictionary) and off course a class.
    # Or more precisely in salama, a Type, that points to a class.
    # So we need a Type, but that has Type and Class too. hmmm
    #
    # The way out is to build empty shell objects and stuff the neccessary data into them
    #  (not use the normal initialize way)
    #  (PPS: The "real" solution is to read a sof graph and not do this by hand
    #    That graph can be programatically built and written (with this to boot that process :-))

    # There are some helpers below, but the roadmap is something like:
    # - create all the Type instances, with their basic types, but no classes
    # - create a space by "hand" , using allocate, not new
    # - create the Class objects and assign them to the types
    def boot_parfait!
      boot_types
      boot_space
      boot_classes

      @space.late_init

      #puts Sof.write(@space)
      boot_functions!
    end

    # types is where the snake bites its tail. Every chain end at a type and then it
    # goes around (circular references). We create them from the list below and keep them
    # in an instance variable (that is a smell, because after booting it is not needed)
    def boot_types
      @types = {}
      type_names.each do |name , ivars |
        @types[name] = type_for( name , ivars)
      end
      type_type = @types[:Type]
      @types.each do |name , type |
        type.set_type(type_type)
      end
    end

    # once we have the types we can create the space by creating the instance variables
    # by hand (can't call new yet as that uses the space)
    def boot_space
      @space = object_with_type Parfait::Space
      @space.classes = make_dictionary
      @space.types = make_dictionary
      Parfait::Space.set_object_space @space
    end

    def make_dictionary
      dict = object_with_type Parfait::Dictionary
      dict.keys = object_with_type Parfait::List
      dict.values = object_with_type Parfait::List
      dict
    end

    # when running code instantiates a class, a type is created automatically
    # but even to get our space up, we have already instantiated all types
    # so we have to continue and allocate classes and fill the data by hand
    # and off cource we can't use space.create_class , but still they need to go there
    def boot_classes
      classes = space.classes
      type_names.each do |name , vars|
        cl = object_with_type Parfait::Class
        cl.instance_type = @types[name]
        @types[name].object_class = cl
        @types[name].instance_methods = object_with_type Parfait::List
        cl.instance_methods = object_with_type Parfait::List
        #puts "instance_methods is #{cl.instance_methods.class}"
        cl.name = name
        classes[name] = cl
      end
      # superclasses other than default object
      supers = {  :Object => :Kernel , :Kernel => :Value,
                  :Integer => :Value , :BinaryCode => :Word }
      type_names.each do |classname , ivar|
        next if classname == :Value  # has no superclass
        clazz = classes[classname]
        super_name = supers[classname] || :Object
        clazz.set_super_class_name super_name
      end
    end

    # helper to create a Type, name is the parfait name, ie :Type
    def type_for( name , ivars )
      l = Parfait::Type.allocate.compile_time_init
      l.send(:private_add_instance_variable , :type , name)
      ivars.each {|n,t| l.send(:private_add_instance_variable, n , t) }
      l
    end

    # create an object with type (ie allocate it and assign type)
    # meaning the lauouts have to be booted, @types filled
    # here we pass the actual (ruby) class
    def object_with_type(cl)
      o = cl.allocate.compile_time_init
      name = cl.name.split("::").last.to_sym
      o.set_type @types[name]
      o
    end

    # the function really just returns a constant (just avoiding the constant)
    # unfortuantely that constant condenses every detail about the system, class names
    # and all instance variable names. Really have to find a better way
    def type_names
       {  :Word => {:char_length => :Integer} ,
          :List => {:indexed_length => :Integer} ,
          :Message => { :next_message => :Message, :receiver => :Object, :locals => :NamedList ,
                        :return_address => :Integer, :return_value => :Integer,
                        :caller => :Message , :name => :Word , :arguments => :NamedList },
          :MetaClass => {:object => :Object},
          :Integer => {},
          :Object => {},
          :Kernel => {}, #fix, kernel is a class, but should be a module
          :BinaryCode => {:char_length => :Integer} ,
          :Space => {:classes => :Dictionary , :types => :Dictionary , :first_message => :Message},
          :NamedList => {:next_list => :NamedList},
          :Type => {:object_class => :Class, :instance_methods => :List , :indexed_length => :Integer} ,
          :Class => {:instance_methods => :List, :instance_type => :Type, :name => :Word,
                      :super_class_name => :Word , :instance_names => :List },
          :Dictionary => {:keys => :List , :values => :List  } ,
          :TypedMethod => {:name => :Word, :source => :Object, :instructions => :Object, :binary => :Object,
                      :arguments => :Type , :for_type => :Type, :locals => :Type } ,
          :Value => {},
        }
    end

    # classes have booted, now create a minimal set of functions
    # minimal means only that which can not be coded in ruby
    # Methods are grabbed from respective modules by sending the method name. This should return the
    # implementation of the method (ie a method object), not actually try to implement it
    #                                                     (as that's impossible in ruby)
    def boot_functions!
      # very fiddly chicken 'n egg problem. Functions need to be in the right order, and in fact we
      # have to define some dummies, just for the others to compile
      # TODO go through the virtual parfait layer and adjust function names to what they really are
      space = @space.get_class_by_name(:Space)
      space.instance_type.add_instance_method Builtin::Space.send(:main, nil)

      obj = @space.get_class_by_name(:Object)
      [ :get_internal_word , :set_internal_word ].each do |f|
        obj.instance_type.add_instance_method Builtin::Object.send(f , nil)
      end
      obj = @space.get_class_by_name(:Kernel)
      # create __init__ main first, __init__ calls it
      [:exit , :__init__ ].each do |f|
        obj.instance_type.add_instance_method Builtin::Kernel.send(f , nil)
      end

      obj = @space.get_class_by_name(:Word)
      [:putstring , :get_internal_byte , :set_internal_byte ].each do |f|
        obj.instance_type.add_instance_method Builtin::Word.send(f , nil)
      end

      obj = @space.get_class_by_name(:Integer)
      [ :putint, :mod4, :div10].each do |f|   #mod4 is just a forward declaration
        obj.instance_type.add_instance_method Builtin::Integer.send(f , nil)
      end
    end
  end
end
