module Virtual
  # The Virtual Machine is a value based virtual machine in which ruby is implemented. While it is value based,
  # it resembles oo in basic ways of object encapsulation and method invokation, it is a "closed" / static sytem
  # in that all types are know and there is no dynamic dispatch (so we don't bite our tail here).
  #
  # It is minimal and realistic and low level
  # - minimal means that if one thing can be implemented by another, it is left out. This is quite the opposite from
  #          ruby, which has several loops, many redundant if forms and the like.
  # - realistic means it is easy to implement on a 32 bit machine (arm) and possibly 64 bit. Memory access, a stack,
  #    some registers of same size are the underlying hardware. (not ie byte machine)
  # - low level means it's basic instructions are realively easily implemented in a register machine. ie send is not
  #   a an instruction but a function.
  #
  # So the memory model of the machine allows for indexed access into an "object" . A fixed number of objects exist
  # (ie garbage collection is reclaming, not destroying and recreating) although there may be a way to increase that number.
  #
  # The ast is transformed to virtaul-machine objects, some of which represent code, some data.
  #
  # The next step transforms to the register machine layer, which is what actually executes.
  #

  # More concretely, a virtual machine is a sort of oo turing machine, it has a current instruction, executes the
  # instructions, fetches the next one and so on.
  # Off course the instructions are not soo simple, but in oo terms quite so.
  #
  # The machine is virtual in the sense that it is completely modeled in software,
  # it's complete state explicitly available (not implicitly by walking stacks or something)

  # The machine has a no register, but local variables, a scope at each point in time.
  # Scope changes with calls and blocks, but is saved at each level. In terms of lower level implementation this means
  # that the the model is such that what is a variable in ruby, never ends up being just on the pysical stack.
  #
  class Machine

    def initialize
      @parser  = Parser::Salama.new
      the_end = Halt.new
      @passes = [ "Virtual::SendImplementation" ]
      @space =  Parfait::Space.new
#      @message = Message.new(the_end , the_end , :Object)
    end
    attr_reader :message , :passes , :space

    def run_passes
      @passes.each do |pass_class|
        blocks = [@init] + main.blocks
        @classes.values.each do |c|
          c.instance_methods.each {|f| blocks += f.blocks  }
        end
        #puts "running #{pass_class}"
        all.each do |block|
          pass = eval pass_class
          raise "no such pass-class as #{pass_class}" unless pass
          pass.new.run(block)
        end
      end
    end

    # Passes may be added to by anyone who wants
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

    def self.boot
      instance = self.instance
      instance.boot_classes! # boot is a verb here
      instance.boot
      instance
    end
    def self.instance
      @instance ||= Machine.new
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
        obj.add_instance_method Builtin::Object.send(f , nil)
      end
      obj = get_or_create_class :Kernel
      # create main first, __init__ calls it
      @main = Builtin::Kernel.send(:main , @context)
      obj.add_instance_method @main
      underscore_init = Builtin::Kernel.send(:__init__ ,nil) #store , so we don't have to resolve it below
      obj.add_instance_method underscore_init
      [:putstring,:exit,:__send].each do |f|
        obj.add_instance_method Builtin::Kernel.send(f , nil)
      end
      # and the @init block in turn _jumps_ to __init__
      # the point of which is that by the time main executes, all is "normal"
      @init = Virtual::Block.new(:_init_ , nil )
      @init.add_code(Register::RegisterMain.new(underscore_init))
      obj = get_or_create_class :Integer
      [:putint,:fibo].each do |f|
        obj.add_instance_method Builtin::Integer.send(f , nil)
      end
      obj = get_or_create_class :String
      [:get , :set , :puts].each do |f|
        obj.add_instance_method Builtin::String.send(f , nil)
      end
      obj = get_or_create_class :Array
      [:get , :set , :push].each do |f|
        obj.add_instance_method Builtin::Array.send(f , nil)
      end
    end

    def boot
      # read all the files needed for a minimal system at compile
      classes = ["object"]
      classes.each do |clazz|
      bytes = File.read(File.join( File.dirname( __FILE__ ) , ".." , "parfait" , "#{clazz}.rb") )
      bytes = 0 #shuts up my atom linter
#        expression = compile_main(bytes)
      end
    end

    def compile_main bytes
      syntax  = @parser.parse_with_debug(bytes)
      parts = Parser::Transform.new.apply(syntax)
      main = Virtual::CompiledMethod.main
      Compiler.compile( parts , main )
    end
  end

end
