module Register

  # Booting is complicated, so it is extracted into this file, even it has only one entry point

  # a ruby object as a placeholder for the parfait Space during boot
  class BootSpace
    attr_reader :classes
    def initialize
      @classes = {}
    end

    def get_class_by_name(name)
      cl = @classes[name]
      raise "No class for #{name}" unless cl
      cl
    end
  end

  # another ruby object to shadow the parfait, just during booting.
  # all it needs is the type, which we make the Parfait type
  class BootClass
    attr_reader :instance_type

    def initialize( type)
      @instance_type = type
    end
  end

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
    # - create a BootSpace that has BootClasses , used only during booting
    # - create the Class objects and assign them to the types
    # - flesh out the types , create the real space
    # - and finally load the methods
    def boot_parfait!
      types = boot_types
      boot_boot_space( types )
      classes = boot_classes( types )
      fix_types( types , classes )

      space = Parfait::Space.new( classes )
      Parfait.set_object_space( space )

      #puts Sof.write(space)
      boot_functions( space )
    end

    # types is where the snake bites its tail. Every chain ends at a type and then it
    # goes around (circular references). We create them from the list below, just as empty
    # shells, that we pass back, for the BootSpace to be created
    def boot_types
      types = {}
      type_names.each do |name , ivars |
        types[name] = Parfait::Type.allocate
      end
      type_type = types[:Type]
      types.each do |name , type |
        type.set_type(type_type)
      end
      types
    end

    # The BootSpace is an object that holds fake classes, that hold _real_ types
    # Once we plug it in we can use .new
    # then we need to create the parfait classes and fix the types before creating a Space
    def boot_boot_space(types)
      boot_space = BootSpace.new
      types.each do |name , type|
        clazz = BootClass.new(type)
        boot_space.classes[name] = clazz
      end
      Parfait.set_object_space( boot_space )
    end

    # Types are hollow shells before this, so we need to set the object_class
    # and initialize the list variables (which we now can with .new)
    def fix_types(types , classes)
      type_names.each do |name , ivars |
        type = types[name]
        clazz = classes[name]
        type.set_object_class( clazz )
        type.init_lists({:type => :Type }.merge(ivars))
      end
    end

    # when running code instantiates a class, a type is created automatically
    # but even to get our space up, we have already instantiated all types
    # so we have to continue and allocate classes and fill the data by hand
    # and off cource we can't use space.create_class , but still they need to go there
    def boot_classes(types)
      classes = Parfait::Dictionary.new
      type_names.each do |name , vars|
        super_c = super_class_names[name] || :Object
        classes[name] = Parfait::Class.new(name , super_c , types[name] )
      end
      classes
    end

    # superclasses other than default object
    def  super_class_names
       { :Object => :Kernel , :Kernel => :Value , :Integer => :Value , :BinaryCode => :Word }
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
          :Integer => {},
          :Object => {},
          :Kernel => {}, #fix, kernel is a class, but should be a module
          :BinaryCode => {:char_length => :Integer} ,
          :Space => {:classes => :Dictionary , :types => :Dictionary , :first_message => :Message},
          :NamedList => {},
          :Type => {:names => :List , :types => :List  ,
                    :object_class => :Class, :methods => :List } ,
          :Class => {:instance_methods => :List, :instance_type => :Type, :name => :Word,
                      :super_class_name => :Word , :instance_names => :List },
          :Dictionary => {:keys => :List , :values => :List  } ,
          :TypedMethod => {:name => :Word, :source => :Object, :instructions => :Object, :binary => :Object,
                      :arguments => :Type , :for_type => :Type, :locals => :Type } ,
        }
    end

    # classes have booted, now create a minimal set of functions
    # minimal means only that which can not be coded in ruby
    # Methods are grabbed from respective modules by sending the method name. This should return the
    # implementation of the method (ie a method object), not actually try to implement it
    #                                                     (as that's impossible in ruby)
    def boot_functions( space )
      # very fiddly chicken 'n egg problem. Functions need to be in the right order, and in fact we
      # have to define some dummies, just for the others to compile
      # TODO go through the virtual parfait layer and adjust function names to what they really are
      space_class = space.get_class_by_name(:Space)
      space_class.instance_type.add_method Builtin::Space.send(:main, nil)

      obj = space.get_class_by_name(:Object)
      [ :get_internal_word , :set_internal_word ].each do |f|
        obj.instance_type.add_method Builtin::Object.send(f , nil)
      end
      obj = space.get_class_by_name(:Kernel)
      # create __init__ main first, __init__ calls it
      [:exit , :__init__ ].each do |f|
        obj.instance_type.add_method Builtin::Kernel.send(f , nil)
      end

      obj = space.get_class_by_name(:Word)
      [:putstring , :get_internal_byte , :set_internal_byte ].each do |f|
        obj.instance_type.add_method Builtin::Word.send(f , nil)
      end

      obj = space.get_class_by_name(:Integer)
      [ :putint, :mod4, :div10].each do |f|   #mod4 is just a forward declaration
        obj.instance_type.add_method Builtin::Integer.send(f , nil)
      end
    end
  end
end
