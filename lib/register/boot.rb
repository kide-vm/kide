module Register

  # Booting is a complicated, so it is extracted into this file, even it has only one entry point

  class Machine

    # The general idea is that compiling is creating an object graph. Functionally
    # one tends to think of methods, and that is complicated enough, sure.
    # But for an object system the graph includes classes and all instance variables
    #
    # And so we have a chicken and egg problem. At the end of the boot function we want to have a
    # working Space object
    # But that has instance variables (List and Dictionary) and off course a class.
    # Or more precisely in salama, a Layout, that points to a class.
    # So we need a Layout, but that has Layout and Class too. hmmm
    #
    # The way out is to build empty shell objects and stuff the neccessary data into them
    #  (not use the normal initialize way)
    #  (PPS: The "real" solution is to read a sof graph and not do this by hand
    #    That graph can be programatically built and written (with this to boot that process :-))

    # There are some helpers below, but the roadmap is something like:
    # - create all the layouts, with thier layouts, but no classes
    # - create a space by "hand" , using allocate, not new
    # - create the class objects and assign them to the layouts
    def boot_parfait!
      boot_layouts
      boot_space
      boot_classes

      @space.late_init

      #puts Sof.write(@space)
      boot_functions!
    end

    # layouts is where the snake bites its tail. Every chain end at a layout and then it
    # goes around (circular references). We create them from the list below and keep them
    # in an instance variable (that is a smell, because after booting it is not needed)
    def boot_layouts
      @layouts = {}
      layout_names.each do |name , ivars |
        @layouts[name] = layout_for( name , ivars)
      end
      layout_layout = @layouts[:Layout]
      @layouts.each do |name , layout |
        layout.set_layout(layout_layout)
      end
    end

    # once we have the layouts we can create the space by creating the instance variables
    # by hand (can't call new yet as that uses the space)
    def boot_space
      space_dict = object_with_layout Parfait::Dictionary
      space_dict.keys = object_with_layout Parfait::List
      space_dict.values = object_with_layout Parfait::List

      @space = object_with_layout Parfait::Space
      @space.classes = space_dict
      Parfait::Space.set_object_space @space
    end

    # when running code instantiates a class, a layout is created automatically
    # but even to get our space up, we have already instantiated all layouts
    # so we have to continue and allocate classes and fill the data by hand
    # and off cource we can't use space.create_class , but still they need to go there
    def boot_classes
      classes = space.classes
      layout_names.each do |name , vars|
        cl = object_with_layout Parfait::Class
        cl.object_layout = @layouts[name]
        @layouts[name].object_class = cl
        cl.instance_methods = object_with_layout Parfait::List
#        puts "instance_methods is #{cl.instance_methods.class}"
        cl.name = name
        classes[name] = cl
      end
      object_class = classes[:Object]
      # superclasses other than default object
      supers = { :BinaryCode => :Word , :Layout => :List , :Class => :Module ,
                 :Object => :Kernel , :Kernel => :Value, :Integer => :Value }
      layout_names.each do |classname , ivar|
        next if classname == :Value  # has no superclass
        clazz = classes[classname]
        super_name = supers[classname]
        if super_name
          clazz.set_super_class classes[super_name]
        else
          clazz.set_super_class object_class
        end
      end
    end

    # helper to create a Layout, name is the parfait name, ie :Layout
    def layout_for( name , ivars )
      l = Parfait::Layout.allocate.fake_init
      l.add_instance_variable :layout
      ivars.each {|n| l.add_instance_variable n }
      l
    end

    # create an object with layout (ie allocate it and assign layout)
    # meaning the lauouts have to be booted, @layouts filled
    # here we pass the actual (ruby) class
    def object_with_layout(cl)
      o = cl.allocate.fake_init
      name = cl.name.split("::").last.to_sym
      o.set_layout @layouts[name]
      o
    end

    # the function really just returns a constant (just avoiding the constant)
    # unfortuantely that constant condenses every detail about the system, class names
    # and all instance variable names. Really have to find a better way
    def layout_names
       {  :Word => [] ,
          :List => [] ,
          # Assumtion is that name is the last of message
          :Message => [:next_message , :receiver , :frame , :return_address , :return_value,
                        :caller , :name ],
          :MetaClass => [],
          :Integer => [],
          :Object => [],
          :Kernel => [], #fix, kernel is a class, but should be a module
          :BinaryCode => [],
          :Space => [:classes , :first_message ],
          :Frame => [:next_frame ],
          :Layout => [:object_class] ,
          # TODO fix layouts for inherited classes. Currently only :Class and the
          # instances are copied (shame on you)
          :Class => [:object_layout , :name , :instance_methods , :super_class , :meta_class],
          :Dictionary => [:keys , :values ] ,
          :Method => [:name , :code ,:arguments , :for_class, :locals  ] ,
          :Variable => [:type , :name , :value ] ,
          :Module => [:name , :instance_methods , :super_class , :meta_class ]
        }
    end

    # classes have booted, now create a minimal set of functions
    # minimal means only that which can not be coded in ruby
    # Methods are grabbed from respective modules by sending the method name. This should return the
    # implementation of the method (ie a method object), not actually try to implement it
    #                                                     (as that's impossible in ruby)
    def boot_functions!
      # very fiddly chicken 'n egg problem. Functions need to be in the right order, and in fact we
      # have to define some dummies, just for the other to compile
      # TODO go through the virtual parfait layer and adjust function names to what they really are
      obj = @space.get_class_by_name(:Object)
      [:main , :_get_instance_variable , :_set_instance_variable].each do |f|
        obj.add_instance_method Builtin::Object.send(f , nil)
      end
      obj = @space.get_class_by_name(:Kernel)
      # create __init__ main first, __init__ calls it
      [:exit,:__send , :__init__ ].each do |f|
        obj.add_instance_method Builtin::Kernel.send(f , nil)
      end

      @space.get_class_by_name(:Word).add_instance_method Builtin::Word.send(:putstring , nil)

      obj = @space.get_class_by_name(:Integer)
      [:putint,:fibo , :plus].each do |f|
        obj.add_instance_method Builtin::Integer.send(f , nil)
      end
    end
  end
end
