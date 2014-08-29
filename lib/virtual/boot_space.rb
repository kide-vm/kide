require_relative "boot_class"
require "builtin/object"

module Virtual
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
      @main = Virtual::CompiledMethod.new("main" , [] )
      #global objects (data)
      @objects = []
      boot_classes! # boot is a verb here
      @passes = [ Virtual::SendImplementation ]
    end
    attr_reader  :main , :classes , :objects

    def run_passes
      @passes.each do |pass|
        puts "Runnning pass #{pass}"
        all = main.blocks
        @classes.each_value do |c| 
          c.instance_methods.each {|f| all += f.blocks  }
        end
        all.each do |block|
          pass.new.run(block)
        end
      end
    end

    def self.space
      if defined? @@space
        @@space
      else
        @@space = BootSpace.new
      end
    end

    # Passes are initiated empty and added to by anyone who want (basically)
    # Even linking and assembly are passes and so there are quite a few system passes neccesary to result in a 
    # working binary. Other than that, this is intentionally quite flexible
    
    def add_pass_after( pass , after)
      index = @passes.index(after)
      raise "No such pass to add after: #{after}" unless index
      @passes.insert(index+1 , pass)
    end
    def add_pass_before( pass , after)
      index = @passes.index(after)
      raise "No such pass to add after: #{after}" unless index
      @passes.insert(index , pass)
    end
    # boot the classes, ie create a minimal set of classes with a minimal set of functions
    # minimal means only that which can not be coded in ruby
    # CompiledMethods are grabbed from respective modules by sending the method name. This should return the 
    # implementation of the method (ie a method object), not actually try to implement it (as that's impossible in ruby)
    def boot_classes!
      # very fiddly chicken 'n egg problem. Functions need to be in the right order, and in fact we have to define some 
      # dummies, just for the other to compile
      obj = get_or_create_class :Object
      [:index_of , :_get_instance_variable , :_set_instance_variable].each do |f|
        #puts "Boot Object::#{f}"
        obj.add_instance_method Builtin::Object.send(f , @context)
      end
      [:putstring,:putint,:fibo,:exit].each do |f|
        #puts "Boot Kernel::#{f}"
        obj.add_instance_method Builtin::Kernel.send(f , @context)
      end
      obj = get_or_create_class :String
      [:get , :set , :puts].each do |f|
        #puts "Boot String::#{f}"
        obj.add_instance_method Builtin::String.send(f , @context)
      end
      obj = get_or_create_class :Array
      [:get , :set , :push].each do |f|
        obj.add_instance_method Builtin::Array.send(f , @context)
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
