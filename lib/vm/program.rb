require_relative "function"
require_relative "function_call"
require "arm/arm_machine"

module Vm
  # A Program represents an executable that we want to build
  # it has a list of functions and (global) objects
  
  # The main entry is a function called (of all things) "main", This _must be supplied by the compling
  # There is a start and exit block that call main, which receives an array of strings

  # While data "ususally" would live in a .data section, we may also "inline" it into the code
  # in an oo system all data is represented as objects

  # in terms of variables and their visibility, things are simple. They are either local or global
  
  # throwing in a context for unspecified use (well one is to pass the programm/globals around)
   
  class Program < Block
    
    # Initialize with a string for cpu. Naming conventions are: for Machine XXX there exists a module XXX
    #  with a XXXMachine in it that derives from Vm::Machine
    def initialize machine
      super("start")
      Machine.instance = eval("#{machine}::#{machine}Machine").new
      @context = Context.new(self)
      #global objects (data)
      @objects = []
      # global functions
      @functions = []
      @entry = Core::Kernel::main_start
      #main gets executed between entry and exit
      @main = Block.new("main")
      @exit = Core::Kernel::main_exit
    end
    attr_reader :context , :main , :functions
    
    def add_object o
      return if @objects.include? o
      @objects << o # TODO check type , no basic values allowed (must be wrapped)
    end
    
    def get_function name
      @functions.detect{ |f| (f.name == name) && (f.class == Function) }
    end

    # preferred way of creating new functions (also forward declarations, will flag unresolved later)
    def get_or_create_function name 
      fun = get_function name
      unless fun
        fun = Function.new(name)
        block = Core::Kernel.send(name)
        fun.set_body block
        @functions << fun
      end
      fun
    end
    
    # linking entry , main , exit
    #         functions , objects
    def link_at( start , context)
      @position = start
      @entry.link_at( start , context )
      start += @entry.length
      @main.link_at( start , context )
      start += @main.length
      @exit.link_at( start , context)
      start += @exit.length
      @functions.each do |function|
        function.link_at(start , context)
        start += function.length
      end
      @objects.each do |o|
        o.link_at(start , context)
        start += o.length
      end
    end

    # assemble in the same order as linked
    def assemble( io )
      link_at( @position , {}) #second link in case of forward declarations
      @entry.assemble( io )
      @main.assemble( io )
      @exit.assemble( io )
      @functions.each do |function|
        function.assemble(io)
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
