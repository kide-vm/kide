require_relative "collector"

module Risc
  # The Risc Machine is an abstraction of the register level. This is seperate from the
  # actual assembler level to allow for several cpu architectures.
  # The Instructions (see class Instruction) define what the machine can do (ie load/store/maths)

  # From code, the next step down is Vool, then Mom (in two steps)
  #
  # The next step transforms to the register machine layer, which is quite close to what actually
  #  executes. The step after transforms to Arm, which creates executables.
  #

  class Machine
    include Collector
    include Logging
    log_level :info

    def initialize
      @booted = false
      @constants = []
    end
    attr_reader  :constants , :risc_init , :cpu_init  , :booted

    # translate to arm, ie instantiate an arm translator and pass it to translate
    #
    # currently we have no machanism to translate to other cpu's (nor such translators)
    # but the mechanism is ready
    def translate_arm
      translate(Arm::Translator.new)
    end

    # translate the methods to whatever cpu the translator translates to
    def translate( translator )
      methods = Parfait.object_space.collect_methods
      translate_methods( methods , translator )
      @cpu_init = translator.translate( @risc_init )
    end

    def translate_methods(methods , translator)
      methods.each do |method|
        log.debug "Translate method #{method.name}"
        method.translate_cpu(translator)
      end
    end

    def boot
      initialize
      boot_parfait!
      @risc_init = Branch.new( "__initial_branch__" , Parfait.object_space.get_init.risc_instructions )
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

require_relative "boot"
