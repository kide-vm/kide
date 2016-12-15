require_relative "collector"

module Register
  # The Register Machine is an abstraction of the register level. This is seperate from the
  # actual assembler level to allow for several cpu architectures.
  # The Instructions (see class Instruction) define what the machine can do (ie load/store/maths)

  # The ast is transformed to virtual-machine objects, some of which represent code, some data.
  #
  # The next step transforms to the register machine layer, which is quite close to what actually
  #  executes. The step after transforms to Arm, which creates executables.
  #

  class Machine
    include Collector

    def initialize
      @objects = {}
      @booted = false
      @constants = []
    end
    attr_reader    :constants
    attr_reader :space , :class_mappings , :init , :objects , :booted

    # idea being that later method missing could catch translate_xxx and translate to target xxx
    # now we just instantiate ArmTranslater and pass instructions
    def translate_arm
      translator = Arm::Translator.new
      methods = []
      self.space.types.each do |hash , t|
        t.instance_methods.each do |f|
          methods << f
        end
      end
      methods.each do |method|
        instruction = method.instructions
        while instruction.next
          nekst = instruction.next
          t = translator.translate(nekst) # returning nil means no replace
          if t
            nekst = t.last
            instruction.replace_next(t)
          end
          instruction = nekst
        end
      end
      label = @init.next
      @init = translator.translate( @init)
      @init.append label
    end


    # Objects are data and get assembled after functions
    def add_object o
      return false if @objects[o.object_id]
      return true if o.is_a? Fixnum
      unless o.is_a? Parfait::Object or o.is_a? Symbol or o.is_a? Register::Label
        raise "adding non parfait #{o.class}"
      end
      @objects[o.object_id] = o
      true
    end

    def boot
      initialize
      boot_parfait!
      @init =  Branch.new( "__initial_branch__" , self.space.get_init.instructions )
      @booted = true
      self
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

Parfait::TypedMethod.class_eval do
  # for testing we need to reuse the main function (or do we?)
  # so remove the code that is there
  def clear_source
    self.source.send :initialize , self
  end

end

require_relative "boot"
