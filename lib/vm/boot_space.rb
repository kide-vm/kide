require_relative "context"
require_relative "boot_class"
require_relative "call_site"
require "arm/arm_machine"
require "core/kernel"
require "boot/object"

module Vm
  # The BootSpace is contains all objects for a program. In functional terms it is a program, but on oo
  # it is a collection of objects, some of which are data, some classes, some functions
  
  # The main entry is a function called (of all things) "main", This _must be supplied by the compling
  # There is a start and exit block that call main, which receives an array of strings

  # While data "ususally" would live in a .data section, we may also "inline" it into the code
  # in an oo system all data is represented as objects
  
  # throwing in a context for unspecified use (well one is to pass the programm/globals around)
   
  class BootSpace < Code
    
    # Initialize with a string for cpu. Naming conventions are: for Machine XXX there exists a module XXX
    #  with a XXXMachine in it that derives from Vm::RegisterMachine
    def initialize machine = nil
      super()
      machine = RbConfig::CONFIG["host_cpu"] unless machine
      machine = "intel" if machine == "x86_64"
      machine = machine.capitalize
      RegisterMachine.instance = eval("#{machine}::#{machine}Machine").new
      @classes = {}
      @context = Context.new(self)
      @context.current_class = get_or_create_class :Object
      #global objects (data)
      @objects = []
      @entry = Core::Kernel::main_start  Vm::Block.new("main_entry",nil)
      #main gets executed between entry and exit
      @main = Block.new("main",nil)
      @exit = Core::Kernel::main_exit Vm::Block.new("main_exit",nil)
      boot_classes
    end
    attr_reader :context , :main , :classes , :entry , :exit
    
    def boot_classes
      # very fiddly chicken 'n egg problem. Functions need to be in the right order, and in fact we have to define some 
      # dummies, just for the other to compile
      obj = get_or_create_class :Object
      [:index_of , :_get_instance_variable].each do |f|
        obj.add_function Boot::Object.send(f , @context)
      end
    end
    def add_object o
      return if @objects.include? o
      raise "must be derived from Code #{o.inspect}" unless o.is_a? Code
      @objects << o # TODO check type , no basic values allowed (must be wrapped)
    end
    
    def get_or_create_class name
      raise "uups #{name}.#{name.class}" unless name.is_a? Symbol
      c = @classes[name]
      unless c
        c = BootClass.new(name,@context)
        @classes[name] = c
      end
      c
    end

    # linking entry , main , exit , classes , objects
    def link_at( start , context)
      super
      @entry.link_at( start , context )
      start += @entry.length
      @main.link_at( start , context )
      start += @main.length
      @exit.link_at( start , context)
      start += @exit.length
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
      @main.assemble( io )
      @exit.assemble( io )
      @classes.values.each do |clazz|
        clazz.assemble(io)
      end
      @objects.each do |o|
        o.assemble(io)
      end
      io
    end
    
    def main= code
      @main = code
    end

  end
end
