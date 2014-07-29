require "boot/boot_class"
#require "vm/call_site"
require "kernel/all"
require "boot/object"
require "boot/string"

module Boot
  # The BootSpace contains all objects for a program. In functional terms it is a program, but in oo
  # it is a collection of objects, some of which are data, some classes, some functions

  # The main entry is a function called (of all things) "main", This _must be supplied by the compling
  # There is a start and exit block that call main, which receives an array of strings

  # While data ususally would live in a .data section, we may also "inline" it into the code
  # in an oo system all data is represented as objects
   
  class BootSpace
    
    # Initialize with a string for cpu. Naming conventions are: for Machine XXX there exists a module XXX
    #  with a XXXMachine in it that derives from Virtual::RegisterMachine
    def initialize machine = nil
      super()
      @classes = {}
      @main = Virtual::MethodDefinition.new("main" , [] )
      #global objects (data)
      @objects = []
      boot_classes
      @passes = [  ]
    end
    attr_reader :context , :main , :classes , :entry , :exit

    def run_passes
      @passes.each do |pass|
        all = main.blocks
        @classes.each_value do |c| 
          c.functions.each {|f| all += f.blocks  }
        end
        all.each do |block|
          pass.run(block)
        end
      end
    end

    # boot the classes, ie create a minimal set of classes with a minimal set of functions
    # minimal means only that which can not be coded in ruby
    # MethodDefinitions are grabbed from respective modules by sending the method name. This should return the 
    # implementation of the method (ie a method object), not actually try to implement it (as that's impossible in ruby)
    def boot_classes
      # very fiddly chicken 'n egg problem. Functions need to be in the right order, and in fact we have to define some 
      # dummies, just for the other to compile
      obj = get_or_create_class :Object
      [:index_of , :_get_instance_variable , :_set_instance_variable].each do |f|
        #puts "Boot Object::#{f}"
        obj.add_method_definition Boot::Object.send(f , @context)
      end
      [:putstring,:putint,:fibo,:exit].each do |f|
        #puts "Boot Kernel::#{f}"
        obj.add_method_definition Salama::Kernel.send(f , @context)
      end
      obj = get_or_create_class :String
      [:get , :set].each do |f|
        #puts "Boot String::#{f}"
        obj.add_method_definition Boot::String.send(f , @context)
      end
    end

    # Objects are data and get assembled after functions
    def add_object o
      return if @objects.include? o
#      raise "must be derived from Code #{o.inspect}" unless o.is_a? Virtual::Code
      @objects << o # TODO check type , no basic values allowed (must be wrapped)
    end

    # this is the way to instantiate classes (not BootClass.new)
    # so we get and keep exactly one per name
    def get_or_create_class name
      raise "uups #{name}.#{name.class}" unless name.is_a? Symbol
      c = @classes[name]
      unless c
        c = BootClass.new(name)
        @classes[name] = c
      end
      c
    end
  end
end
