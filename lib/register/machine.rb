require 'parslet/convenience'
require_relative "collector"
module Register
  # The Register Machine is a object based virtual machine on which ruby will be implemented.
  #

  # The ast is transformed to virtual-machine objects, some of which represent code, some data.
  #
  # The next step transforms to the register machine layer, which is quite close to what actually
  #  executes. The step after transforms to Arm, which creates executables.
  #

  class Machine
    include Collector

    def initialize
      @parser  = Parser::Salama.new
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
      @space.classes.values.each do |c|
        c.instance_methods.each do |f|
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
      return true if o.is_a? Register::Label
      raise "adding non parfait #{o.class}" unless o.is_a? Parfait::Object or o.is_a? Symbol
      @objects[o.object_id] = o
      true
    end

    def boot
      boot_parfait!
      @init =  Branch.new( "__initial_branch__" , self.space.get_init.instructions )
      @booted = true
      self
    end

    def parse_and_compile bytes
      syntax  = @parser.parse_with_debug(bytes)
      parts = Parser::Transform.new.apply(syntax)
      #puts parts.inspect
      Soml.compile( parts )
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

Parfait::Method.class_eval do
  # for testing we need to reuse the main function (or do we?)
  # so remove the code that is there
  def clear_source
    self.source.send :initialize , self
  end

end

require_relative "boot"
