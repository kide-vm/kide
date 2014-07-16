require "vm/context"
require "boot/boot_class"
require "vm/call_site"
require "arm/arm_machine"
require "kernel/all"
require "boot/object"
require "boot/string"

module Boot
  # The BootSpace is contains all objects for a program. In functional terms it is a program, but on oo
  # it is a collection of objects, some of which are data, some classes, some functions
  
  # The main entry is a function called (of all things) "main", This _must be supplied by the compling
  # There is a start and exit block that call main, which receives an array of strings

  # While data "ususally" would live in a .data section, we may also "inline" it into the code
  # in an oo system all data is represented as objects
  
  # throwing in a context for unspecified use (well one is to pass the programm/globals around)
   
  class BootSpace < Virtual::Code
    
    # Initialize with a string for cpu. Naming conventions are: for Machine XXX there exists a module XXX
    #  with a XXXMachine in it that derives from Virtual::RegisterMachine
    def initialize machine = nil
      super()
      machine = RbConfig::CONFIG["host_cpu"] unless machine
      machine = "intel" if machine == "x86_64"
      machine = machine.capitalize
      Virtual::RegisterMachine.instance = eval("#{machine}::#{machine}Machine").new
      @classes = {}
      @context = Virtual::Context.new(self)
      @context.current_class = get_or_create_class :Object
      @main = Virtual::Function.new("main")
      @context.function = @main
      #global objects (data)
      @objects = []
      @entry = Virtual::RegisterMachine.instance.main_start @context
      #main gets executed between entry and exit
      @exit = Virtual::RegisterMachine.instance.main_exit @context
      boot_classes
      @passes = [ Virtual::MoveMoveReduction.new ,  Virtual::LogicMoveReduction.new, Virtual::NoopReduction.new, Virtual::SaveLocals.new ]
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
    # Functions are grabbed from respective modules by sending the sunction name. This should return the 
    # implementation of the function (ie a function object), not actually try to implement it (as that's impossible in ruby)
    def boot_classes
      # very fiddly chicken 'n egg problem. Functions need to be in the right order, and in fact we have to define some 
      # dummies, just for the other to compile
      obj = get_or_create_class :Object
      [:index_of , :_get_instance_variable , :_set_instance_variable].each do |f|
        #puts "Boot Object::#{f}"
        obj.add_function Boot::Object.send(f , @context)
      end
      [:utoa, :putstring,:putint,:fibo,:exit].each do |f|
        #puts "Boot Kernel::#{f}"
        obj.add_function Kide::Kernel.send(f , @context)
      end
      obj = get_or_create_class :String
      [:get , :set].each do |f|
        #puts "Boot String::#{f}"
        obj.add_function Boot::String.send(f , @context)
      end
    end

    # Objects are data and get assembled after functions
    def add_object o
      return if @objects.include? o
      raise "must be derived from Code #{o.inspect}" unless o.is_a? Virtual::Code
      @objects << o # TODO check type , no basic values allowed (must be wrapped)
    end

    # this is the way to instantiate classes (not BootBlass.new)
    # so we get and keep exactly one per name
    def get_or_create_class name
      raise "uups #{name}.#{name.class}" unless name.is_a? Symbol
      c = @classes[name]
      unless c
        c = BootClass.new(name,@context)
        @classes[name] = c
      end
      c
    end

    # linking entry , exit , main , classes , objects
    def link_at( start , context)
      super
      @entry.link_at( start , context )
      start += @entry.length
      @exit.link_at( start , context)
      start += @exit.length
      @main.link_at( start , context )
      start += @main.length
      @classes.values.each do |clazz|
        clazz.link_at(start , context)
        start += clazz.length
      end
      @objects.each do |o|
        o.link_at(start , context)
        start += o.length
      end
    end

    # assemble in the same order as linked
    def assemble( io )
      link_at( @position , nil) #second link in case of forward declarations
      @entry.assemble( io )
      @exit.assemble( io )
      @main.assemble( io )
      @classes.values.each do |clazz|
        clazz.assemble(io)
      end
      @objects.each do |o|
        o.assemble(io)
      end
      io
    end
  end
end
