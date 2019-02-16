module Boot
  # Booting is complicated, so it is extracted into this file, even it has only one entry point

  # a ruby object as a placeholder for the parfait Space during boot
  class Space
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
  class Class
    attr_reader :instance_type

    def initialize( type)
      @instance_type = type
    end
  end
end

module Parfait

  # The general idea is that compiling is creating an object graph. Functionally
  # one tends to think of methods, and that is complicated enough, sure.
  # But for an object system the graph includes classes and all instance variables
  #
  # And so we have a chicken and egg problem. At the end of the boot function we want to have a
  # working Space object
  # But that has instance variables (List and Dictionary) and off course a class.
  # Or more precisely in rubyx, a Type, that points to a class.
  # So we need a Type, but that has Type and Class too. hmmm
  #
  # The way out is to build empty shell objects and stuff the neccessary data into them
  #  (not use the normal initialize way)
  #  (PPS: The "real" solution is to read a rx-file graph and not do this by hand
  #    That graph can be programatically built and written (with this to boot that process :-))

  # There are some helpers below, but the roadmap is something like:
  # - create all the Type instances, with their basic types, but no classes
  # - create a BootSpace that has BootClasses , used only during booting
  # - create the Class objects and assign them to the types
  # - flesh out the types , create the real space
  # - and finally load the methods
  def self.boot!(options)
    Parfait.set_object_space( nil )
    types = boot_types
    boot_boot_space( types )
    classes = boot_classes( types )
    fix_types( types , classes )
    page = options[:factory] || 1024
    Factory.page_size = page
    space = Space.new( classes )
    Parfait.set_object_space( space )
  end

  # types is where the snake bites its tail. Every chain ends at a type and then it
  # goes around (circular references). We create them from the list below, just as empty
  # shells, that we pass back, for the BootSpace to be created
  def self.boot_types
    types = {}
    type_names.each do |name , ivars |
      types[name] = Type.allocate
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
  def self.boot_boot_space(types)
    boot_space = Boot::Space.new
    types.each do |name , type|
      clazz = Boot::Class.new(type)
      boot_space.classes[name] = clazz
    end
    Parfait.set_object_space( boot_space )
  end

  # when running code instantiates a class, a type is created automatically
  # but even to get our space up, we have already instantiated all types
  # so we have to continue and allocate classes and fill the data by hand
  # and off cource we can't use space.create_class , but still they need to go there
  def self.boot_classes(types)
    classes = Dictionary.new
    classes.type = types[:Dictionary]
    type_names.each do |name , vars|
      super_c = super_class_names[name] || :Object
      clazz = Class.new(name , super_c , types[name] )
      classes[name] = clazz
    end
    classes
  end

  # Types are hollow shells before this, so we need to set the object_class
  # and initialize the list variables (which we now can with .new)
  def self.fix_types(types , classes)
    type_names.each do |name , ivars |
      type = types[name]
      clazz = classes[name]
      type.set_object_class( clazz )
      type.init_lists({type: :Type }.merge(ivars))
    end
  end

  # superclasses other than default object
  def self.super_class_names
     { Data4: :DataObject ,
       Data8: :DataObject ,
       Data16: :DataObject ,
       Data32: :DataObject ,
       BinaryCode: :Data16 ,
       Integer: :Data4 ,
       Word: :Data8 ,
       List: :Data16 ,
       CallableMethod: :Callable,
       Block: :Callable,
       ReturnAddress: :Integer}
  end

  # the function really just returns a constant (just avoiding the constant)
  # unfortuantely that constant condenses every detail about the system, class names
  # and all instance variable names. Really have to find a better way
  def self.type_names
     {BinaryCode: {next_code: :BinaryCode} ,
      Block: {binary: :BinaryCode, next_callable: :Block,
              arguments_type: :Type , self_type: :Type, frame_type: :Type,
              name: :Word , blocks: :Block } ,

      CacheEntry: {cached_type: :Type , cached_method: :CallableMethod  } ,
      Callable:   {binary: :BinaryCode,next_callable: :Callable ,
                   arguments_type: :Type , self_type: :Type, frame_type: :Type,
                   name: :Word , blocks: :Block  } ,
      CallableMethod: {binary: :BinaryCode, next_callable: :CallableMethod ,
                       arguments_type: :Type , self_type: :Type, frame_type: :Type ,
                       name: :Word , blocks: :Block} ,
      Class: {instance_methods: :List, instance_type: :Type,
              name: :Word, super_class_name: :Word , meta_class: :MetaClass},
      DataObject: {},
      Data4: {},
      Data8: {},
      Data16: {},
      Dictionary: {i_keys: :List , i_values: :List  } ,
      Integer: {next_integer: :Integer},
      FalseClass: {},
      List: {indexed_length: :Integer , next_list: :List} ,
      Message: { next_message: :Message,   receiver: :Object, frame: :NamedList ,
                 return_address: :Integer, return_value: :Object,
                 caller: :Message , method: :TypedMethod ,     arguments: :NamedList },
      MetaClass: {instance_methods: :List, instance_type: :Type, clazz: :Class },
      NamedList: {},
      NilClass: {},
      Object: {},
      Factory: { for_type: :Type , next_object: :Object ,
              reserve: :Object , attribute_name: :Word },
      ReturnAddress: {next_integer: :ReturnAddress},
      Space: {classes: :Dictionary , types: :Dictionary , factories: :Dictionary,
              true_object: :TrueClass, false_object: :FalseClass , nil_object: :NilClass},
      TrueClass: {},
      Type: {names: :List , types: :List  ,
             object_class: :Class, methods: :CallableMethod } ,
      VoolMethod: { name: :Word , args_type: :Type , frame_type: :Type } ,
      Word: {char_length: :Integer , next_word: :Word} ,
      }
  end
end
