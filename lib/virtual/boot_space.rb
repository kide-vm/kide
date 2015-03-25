require_relative "boot_class"
require "builtin/object"

module Virtual
  # The BootSpace contains all objects for a program. In functional terms it is a program, but in oo
  # it is a collection of objects, some of which are data, some classes, some functions

  # The main entry is a function called (of all things) "main", This _must be supplied by the compling
  # There is a start and exit block that call main, which receives an array of strings

  # While data ususally would live in a .data section, we may also "inline" it into the code
  # in an oo system all data is represented as objects
   
  class BootSpace < Virtual::ObjectConstant
    
    def initialize
      super()
      @classes = Parfait::Hash.new
      #global objects (data)
      @objects = []
      @symbols = []
      frames = 100.times.collect{ ::Frame.new }      
      @messages = 100.times.collect{ ::Message.new } + frames
      @next_message = @messages.first
      @next_frame = frames.first
      @passes = [ "Virtual::SendImplementation" ]
    end
    attr_reader  :init , :main , :classes , :objects , :symbols,:messages, :next_message , :next_frame

    def run_passes
      @passes.each do |pass_class|
        all = [@init] + main.blocks
        @classes.values.each do |c| 
          c.instance_methods.each {|f| all += f.blocks  }
        end
        #puts "running #{pass_class}"
        all.each do |block|
          pass = eval pass_class
          raise "no such pass-class as #{pass_class}" unless pass 
          pass.new.run(block)
        end
      end
    end

    def self.space
      if defined? @@space
        @@space
      else
        @@space = BootSpace.new
        @@space
      end
    end

    # Passes are initiated empty and added to by anyone who wants (basically)
    # This is intentionally quite flexible, though one sometimes has to watch the order of them
    # most ordering is achieved by ordering the requires and using add_pass
    # but more precise control is possible with the _after and _before versions

    def add_pass pass
      @passes << pass
    end
    def add_pass_after( pass , after)
      index = @passes.index(after)
      raise "No such pass (#{pass}) to add after: #{after}" unless index
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
        obj.add_instance_method Builtin::Object.send(f , @context)
      end
      obj = get_or_create_class :Kernel
      # create main first, __init__ calls it
      @main = Builtin::Kernel.send(:main , @context)
      obj.add_instance_method @main
      underscore_init = Builtin::Kernel.send(:__init__ , @context) #store , so we don't have to resolve it below
      obj.add_instance_method underscore_init
      [:putstring,:exit,:__send].each do |f|
        obj.add_instance_method Builtin::Kernel.send(f , @context)
      end
      # and the @init block in turn _jumps_ to __init__
      # the point of which is that by the time main executes, all is "normal"
      @init = Virtual::Block.new(:_init_ , nil )
      @init.add_code(Register::RegisterMain.new(underscore_init))
      obj = get_or_create_class :Integer
      [:putint,:fibo].each do |f|
        obj.add_instance_method Builtin::Integer.send(f , @context)
      end
      obj = get_or_create_class :String
      [:get , :set , :puts].each do |f|
        obj.add_instance_method Builtin::String.send(f , @context)
      end
      obj = get_or_create_class :Array
      [:get , :set , :push].each do |f|
        obj.add_instance_method Builtin::Array.send(f , @context)
      end
    end

    @@SPACE = { :names => [:classes,:objects,:symbols,:messages, :next_message , :next_frame] , 
                :types => [Virtual::Reference,Virtual::Reference,Virtual::Reference,Virtual::Reference,Virtual::Reference]}
    def layout
      @@SPACE
    end

    # Objects are data and get assembled after functions
    def add_object o
      return if @objects.include?(o)
      @objects << o
      if o.is_a? Symbol
        @symbols << o
      end
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
    def mem_length
      padded_words( 5 )
    end
  end
end
