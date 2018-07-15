
# A Space is a collection of pages. It stores objects, the data for the objects,
# not references. See Page for more detail.

# Pages are stored by the object size they represent in a hash.

# Space and Page work together in making *new* objects available.
# "New" is slightly misleading in that normal operation only ever
# recycles objects.

module Parfait
  # Make the object space globally available
  def self.object_space
    @@object_space
  end

  # TODO Must get rid of the setter (move the boot process ?)
  def self.set_object_space( space )
    @@object_space = space
  end

  # The Space contains all objects for a program. In functional terms it is a program, but in oo
  # it is a collection of objects, some of which are data, some classes, some functions

  # The main entry is a function called (of all things) "main".
  # This _must be supplied by the compled code (similar to c)
  # There is a start and exit block that call main, which receives an List of strings

  # While data ususally would live in a .data section, we may also "inline" it into the code
  # in an oo system all data is represented as objects

  class Space < Object

    def initialize( classes )
      @classes = classes
      @types = Dictionary.new
      @classes.each do |name , cl|
        add_type(cl.instance_type)
      end
      101.times { @integers = Integer.new(0,@integers) }
      300.times { @addresses = ReturnAddress.new(0,@addresses) }
      message = Message.new(nil)
      50.times do
        @messages = Message.new message
        message.set_caller @messages
        message = @messages
      end
      @next_message = @messages
      @next_integer = @integers
      @next_address = @addresses
      @true_object = Parfait::TrueClass.new
      @false_object = Parfait::FalseClass.new
      @nil_object = Parfait::NilClass.new
    end

    attr_reader  :classes , :types , :next_message , :next_integer , :next_address
    attr_reader  :messages, :integers , :addresses
    attr_reader  :true_object , :false_object , :nil_object

    # hand out one of the preallocated ints for use as constant
    # the same code is hardcoded as risc instructions for "normal" use, to
    # avoid the method call at runtime. But at compile time we want to keep
    # the number of integers known (fixed).
    def get_integer
      int = @next_integer
      @next_integer = @next_integer.next_integer
      int
    end

    # hand out a return address for use as constant the address is added
    def get_address
      addr = @next_address
      @next_address = @next_address.next_integer
      addr
    end

    def each_type
      @types.values.each do |type|
        yield(type)
      end
    end

    def add_type( type )
      hash = type.hash
      raise "upps #{hash} #{hash.class}" unless hash.is_a?(Fixnum)
      was = @types[hash]
      return was if was
      @types[hash] = type
    end

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

    def get_main
      space = get_class_by_name :Space
      space.instance_type.get_method :main
    end

    def get_init
      object = get_class_by_name :Object
      object.instance_type.get_method :__init__
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
      #puts "MISS, no class #{name} #{name.class}" unless c # " #{@classes}"
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
