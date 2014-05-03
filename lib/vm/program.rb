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
      @functions = []
      @objects = []
      @entry = Vm::Kernel::start
      @exit = Vm::Kernel::exit
    end
    attr_reader :context
    
    def add_object o
      @objects << o # TODO check type , no basic values allowed (must be wrapped)
    end
    
    def get_function name
      @functions.detect{ |f| f.name == name }
    end

    # preferred way of creating new functions (also forward declarations, will flag unresolved later)
    def get_or_create_function name 
      fun = get_function name
      unless fun
        fun = Function.new(name)
        @functions << fun
      end
      fun
    end
    
    def compile
      super
      string_table
    end
    
    def wrap_as_main value
      
    end
    def verify
      @functions.each do |funct|
        funct.verify
      end
    end
    
    private 
    # the main function
    def create_main
    end
  end
end
