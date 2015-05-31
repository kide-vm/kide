module Virtual
  # The Virtual Machine is a value based virtual machine in which ruby is implemented.
  # While it is value based, it resembles oo in basic ways of object encapsulation and method
  # invocation, it is a "closed" / static sytem in that all types are know and there is no
  # dynamic dispatch (so we don't bite our tail here).
  #
  # It is minimal and realistic and low level
  # - minimal means that if one thing can be implemented by another, it is left out. This is quite
  #    the opposite from ruby, which has several loops, many redundant if forms and the like.
  # - realistic means it is easy to implement on a 32 bit machine (arm) and possibly 64 bit.
  #     Memory access,some registers of same size are the underlying hardware. (not ie byte machine)
  # - low level means it's basic instructions are realively easily implemented in a register machine.
  #      ie send is not a an instruction but a function.
  #
  # So the memory model of the machine allows for indexed access into an "object" .
  # A fixed number of objects exist (ie garbage collection is reclaming, not destroying and
  #  recreating) although there may be a way to increase that number.
  #
  # The ast is transformed to virtaul-machine objects, some of which represent code, some data.
  #
  # The next step transforms to the register machine layer, which is what actually executes.
  #

  # More concretely, a virtual machine is a sort of oo turing machine, it has a current instruction,
  # executes the instructions, fetches the next one and so on.
  # Off course the instructions are not soo simple, but in oo terms quite so.
  #
  # The machine is virtual in the sense that it is completely modeled in software,
  # it's complete state explicitly available (not implicitly by walking stacks or something)

  # The machine has a no register, but local variables, a scope at each point in time.
  # Scope changes with calls and blocks, but is saved at each level. In terms of lower level
  #  implementation this means that the the model is such that what is a variable in ruby,
  #  never ends up being just on the pysical stack.
  #
  class Machine

    def initialize
      @parser  = Parser::Salama.new
      @passes = [ "Virtual::SendImplementation" ]
      @objects = []
    end
    attr_reader  :passes , :space , :class_mappings , :init , :objects

    def run_passes
      Minimizer.new.run
      Collector.new.run
      @passes.each do |pass_class|
        blocks = [@init]
        @space.classes.values.each do |c|
          c.instance_methods.each do |f|
            nb = f.info.blocks
            raise "nil blocks " unless nb
            blocks += nb
          end
        end
        #puts "running #{pass_class}"
        blocks.each do |block|
          pass = eval pass_class
          raise "no such pass-class as #{pass_class}" unless pass
          pass.new.run(block)
        end
      end
    end

    # double check that all objects dependents are really in the space too (debugging)
    def double_check
      @objects.each do |o|
        check o
      end
    end
    # Objects are data and get assembled after functions
    def add_object o
      return false if @objects.include?(o)
      @objects.push o
      true
    end

    # private
    def check object , recurse = true
      raise "No good #{object.class}" unless @objects.include? object
      puts "#{object.class}"
      puts "#{object}" if object.class == Parfait::Word
      check object.get_layout
      return unless recurse
      object.get_layout.each do |name|
        check name , false
        inst = object.instance_variable_get "@#{name}".to_sym
        check inst , false
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
      # boot is a verb here. this is a somewhat tricky process which is in it's own file, boot.rb
      instance.boot_parfait!
      instance
    end
    def self.instance
      @instance ||= Machine.new
    end

    # for testing, make sure no old artefacts hang around
    #maybe should be moved to test dir
    def self.reboot
      @instance = nil
      self.boot
    end
    def compile_main bytes
      syntax  = @parser.parse_with_debug(bytes)
      parts = Parser::Transform.new.apply(syntax)
      Compiler.compile( parts , @space.get_main )
    end
  end
end

require_relative "boot"
