
# The Space is the root object we work off, the only singleton in the parfait world
#
# Space stores the types, classes, factories and singleton objects (true/false/nil)
#
# The Space is booted at compile time, a process outside the scope of Parfait(in parfait_boot)
# Then it is used during compilation and later serialized into the resulting binary
#
#
module Parfait
  # Make the object space globally available
  def self.object_space
    @object_space
  end

  # TODO Must get rid of the setter (move the boot process ?)
  def self.set_object_space( space )
    @object_space = space
  end

  # The Space contains all objects for a program. In functional terms it is a program, but in oo
  # it is a collection of objects, some of which are data, some classes, some functions

  # The main entry is a function called (of all things) "main".
  # This _must be supplied by the compled code (similar to c)
  # There is a start and exit block that call main, which receives an List of strings

  # While data ususally would live in a .data section, we may also "inline" it into the code
  # in an oo system all data is represented as objects

  class Space < Object

    attr_reader  :classes , :types , :factories
    attr_reader  :true_object , :false_object , :nil_object
    def self.type_length
      7
    end
    def self.memory_size
      8
    end

    def initialize( classes , pages)
      @classes = classes
      @types = Dictionary.new
      classes.each do |name , cl|
        add_type(cl.instance_type)
      end
      @factories = Dictionary.new
      [:Integer , :ReturnAddress , :Message].each do |fact_name|
        for_type = classes[fact_name].instance_type
        page_size = pages[fact_name] || 1024
        factory = Factory.new( for_type , page_size )
        factory.get_more
        factories[ fact_name ] = factory
      end
      init_message_chain( factories[ :Message ].reserve  )
      init_message_chain( factories[ :Message ].next_object  )
      @true_object = Parfait::TrueClass.new
      @false_object = Parfait::FalseClass.new
      @nil_object = Parfait::NilClass.new
    end

    def init_message_chain( message )
      prev = nil
      while(message)
        message.initialize
        message._set_caller(prev) if prev
        prev = message
        message = message.next_message
      end
    end
    # return the factory for the given type
    # or more exactly the type that has a class_name "name"
    def get_factory_for(name)
      @factories[name]
    end

    # use the factory of given name to generate next_object
    # just a shortcut basically
    def get_next_for(name)
      @factories[name].get_next_object
    end

    # yield each type in the space
    def each_type
      @types.values.each do |type|
        yield(type)
      end
    end

    # add a type, meaning the instance given must be a valid type
    def add_type( type )
      hash = type.hash
      raise "upps #{hash} #{hash.class}" unless hash.is_a?(::Integer)
      was = types[hash]
      return was if was
      types[hash] = type
    end

    # get a type by the type hash (the hash is what uniquely identifies the type)
    def get_type_for( hash )
      @types[hash]
    end

    # all methods form all types
    def get_all_methods
      methods = []
      each_type do | type |
        type.each_method do |meth|
          methods << meth
        end
      end
      methods
    end

    # shortcut to get at known methods that are used in the compiler
    # arguments are class and method names
    # returns method or raises (!)
    def get_method!( clazz_name , method_name )
      clazz = get_class_by_name( clazz_name )
      raise "No such class #{clazz_name}" unless clazz
      method = clazz.instance_type.get_method(method_name)
      raise "No such Method #{method_name}, in #{clazz_name}" unless method
      method
    end

    # get the current instance_typ of the class with the given name
    def get_type_by_class_name(name)
      clazz = get_class_by_name(name)
      return nil unless clazz
      clazz.instance_type
    end

    # get a class by name (symbol)
    # return nili if no such class. Use bang version if create should be implicit
    def get_class_by_name( name )
      raise "get_class_by_name #{name}.#{name.class}" unless name.is_a?(Symbol)
      c = @classes[name]
      #puts "MISS, no class #{name} #{name.class}" unless c # " #{classes}"
      #puts "CLAZZ, #{name} #{c.get_type.get_length}" if c
      c
    end

    # get or create the class by the (symbol) name
    # notice that this method of creating classes implies Object superclass
    def get_class_by_name!(name , super_class = :Object)
      c = get_class_by_name(name)
      return c if c
      create_class( name ,super_class)
    end

    # this is the way to instantiate classes (not Parfait::Class.new)
    # so we get and keep exactly one per name
    def create_class( name , superclass = nil )
      raise "create_class #{name.class}" unless name.is_a? Symbol
      superclass = :Object unless superclass
      raise "create_class #{superclass.class}" unless superclass.is_a? Symbol
      type = get_type_by_class_name(superclass)
      c = Class.new(name , superclass , type )
      @classes[name] = c
    end

    def rxf_reference_name
      "space"
    end

  end
  # ObjectSpace
  # :each_object, :garbage_collect, :define_finalizer, :undefine_finalizer, :_id2ref, :count_objects
end
