module Virtual
  # The Virtual Machine is a object based virtual machine in which ruby is implemented.
  #
  # It is minimal and realistic and low level
  # - minimal means that if one thing can be implemented by another, it is left out. This is quite
  #    the opposite from ruby, which has several loops, many redundant if forms and the like.
  # - realistic means it is easy to implement on a 32 bit machine (arm) and possibly 64 bit.
  #     Memory access,some registers of same size are the underlying hardware. (not ie byte machine)
  # - low level means it's basic instructions are realively easily implemented in a register machine.
  #      Low level means low level in oo terms though, so basic instruction to implement oo
  #  #
  # The ast is transformed to virtual-machine objects, some of which represent code, some data.
  #
  # The next step transforms to the register machine layer, which is quite close to what actually
  #  executes. The step after transforms to Arm, which creates executables.
  #
  # More concretely, a virtual machine is a sort of oo turing machine, it has a current instruction,
  # executes the instructions, fetches the next one and so on.
  # Off course the instructions are not soo simple, but in oo terms quite so.
  #
  # The machine is virtual in the sense that it is completely modeled in software,
  # it's complete state explicitly available (not implicitly by walking stacks or something)

  # The machine has a no register, but objects that represent it's state. There are four
  # - message : the currently executing message (See Parfait::Message)
  # - receiver : or self.  This is actually an instance of Message, but "hoisted" out
  # -  frame : A pssible frame for temporary data. Also part of the message and "hoisted" out
  # - next_message: A message object that the current activation wants to send.
  #
  # Messages form a linked list (not a stack) and the Space is responsible for storing
  # and handing out empty messages
  #
  # The "machine" is not part of the run-time (Parfait)

  class Machine

    FIRST_PASS = "Virtual::SendImplementation"
    def initialize
      @parser  = Parser::Salama.new
      @passes = [  FIRST_PASS ]
      @objects = []
      @booted = false
    end
    attr_reader  :passes , :space , :class_mappings , :init , :objects

    # run all passes before the pass given
    # also collect the  block to run the passes on and
    # runs housekeeping Minimizer and Collector
    # Has to be called before run_after
    def run_before stop_at
      Minimizer.new.run
      Collector.new.run
      @blocks = [@init]
      @space.classes.values.each do |c|
        c.instance_methods.each do |f|
          nb = f.info.blocks
          @blocks += nb
        end
      end
      @passes.each do |pass_class|
        puts "running #{pass_class}"
        run_blocks_for pass_class
        return if stop_at == pass_class
      end
    end

    # run all passes after the pass given
    # run_before MUST be called first.
    # the two are meant as a poor mans breakoint
    def run_after start_at
      run = false
      @passes.each do |pass_class|
        if run
          puts "running #{pass_class}"
          run_blocks_for pass_class
        else
          run = true if start_at == pass_class
        end
      end
    end

    # as before, run all passes that are registered
    # (but now finer control with before/after versions)
    def run_passes
      run_before FIRST_PASS
      run_after FIRST_PASS
    end

    # Objects are data and get assembled after functions
    def add_object o
      return false if @objects.include?(o)
      @objects.push o
      true
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
      me = Virtual.machine
      # boot is a verb here. this is a somewhat tricky process which is in it's own file, boot.rb
      raise "already booted" if @booted
      me.boot
      me
    end

    def boot
      boot_parfait!
      @init = Block.new("init",nil)
      @init.add_code  Register::RegisterMain.new( self.space.get_init )
      @booted = true
    end

    # for testing, make sure no old artefacts hang around
    #maybe should be moved to test dir
    def self.reboot
      raise "redo"
    end
    def compile_main bytes
      syntax  = @parser.parse_with_debug(bytes)
      parts = Parser::Transform.new.apply(syntax)
      Compiler.compile( parts , @space.get_main )
    end

    private
    def run_blocks_for pass_class
      pass = eval pass_class
      raise "no such pass-class as #{pass_class}" unless pass
      @blocks.each do |block|
        raise "nil block " unless block
        pass.new.run(block)
      end
    end

  end

  # Module function to retrieve singleton
  def self.machine
    unless defined?(@machine)
      @machine = Machine.new
    end
    @machine
  end

end

require_relative "boot"
