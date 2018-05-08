require_relative "collector"
require_relative "binary_writer"

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
    include Logging
    log_level :info

    def initialize
      @booted = false
      @risc_init = nil
      @constants = []
    end
    attr_reader  :constants , :cpu_init , :binary_init
    attr_reader  :booted , :translated

    # translate to arm, ie instantiate an arm translator and pass it to translate
    #
    # currently we have no machanism to translate to other cpu's (nor such translators)
    # but the mechanism is ready
    def translate_arm
      @translated = true
      translate(Arm::Translator.new)
    end

    # translate code to whatever cpu the translator translates to
    # this means translating the initial jump (cpu_init into binary_init)
    # and then translating all methods
    def translate( translator )
      methods = Parfait.object_space.get_all_methods
      translate_methods( methods , translator )
      @cpu_init = risc_init.to_cpu(translator)
      @binary_init = Parfait::BinaryCode.new(1)
    end

    # go through all methods and translate them to cpu, given the translator
    def translate_methods(methods , translator)
      methods.each do |method|
        log.debug "Translate method #{method.name}"
        method.translate_cpu(translator)
      end
    end

    # machine keeps a list of all objects. this is lazily created with a collector
    def objects
      @objects ||= Collector.collect_space
    end

    # lazy init risc_init
    def risc_init
      @risc_init ||= Branch.new( "__initial_branch__" , Parfait.object_space.get_init.risc_instructions )
    end
    # add a constant (which get created during compilatio and need to be linked)
    def add_constant(const)
      raise "Must be Parfait #{const}" unless const.is_a?(Parfait::Object)
      @constants << const
    end
    # To create binaries, objects (and labels) need to have a position
    # (so objects can be loaded and branches know where to jump)
    #
    # Position in the order
    # - initial jump
    # - all object
    # - all code
    # As code length amy change during assembly, this way at least the objects stay
    # in place and we don't have to deal with chaning loading code
    def position_all
      translate_arm unless @translated
      #need the initial jump at 0 and then functions
      Position.set(binary_init,0)
      Position.set(cpu_init , 12 , binary_init)
      @code_start = position_objects( binary_init.padded_length )
      # and then everything code
      position_code
    end

    # go through everything that is not code (BinaryCode) and set position
    # padded_length is what determines an objects (byte) length
    # return final position that is stored in code_start
    def position_objects(at)
      # want to have the objects first in the executable
      objects.each do | id , objekt|
        next if objekt.is_a?( Parfait::BinaryCode) or objekt.is_a?( Risc::Label )
        before = at
        Position.set(objekt,at)
        at += objekt.padded_length
        log.debug "Object #{objekt.class}:#{before.to_s(16)} len: #{(at - before).to_s(16)}"
      end
      at
    end

    # Position all BinaryCode.
    #
    # So that all code from one method is layed out linearly (for debugging)
    # we go through methods, and then through all codes from the method
    #
    # start at @code_start. The method is called until
    # assembly stops throwing errors
    def position_code
      at = @code_start
      objects.each do |id , method|
        next unless method.is_a? Parfait::TypedMethod
        before = at
        Position.set( method.binary , at , method)
        Position.set( method.cpu_instructions, 3 , method.binary)
        # before = at
        # nekst = method.binary
        # while(nekst)
        #   Position.set(nekst , at , method)
        #   at += nekst.padded_length
        #   nekst = nekst.next
        # end
        log.debug "Method #{method.name}:#{before.to_s(16)} len: #{(at - before).to_s(16)}"
        log.debug "Instructions #{method.cpu_instructions.object_id.to_s(16)}:#{(before+12).to_s(16)}"
      end
      at
    end

    # Create Binary code for all methods and the initial jump
    # BinaryWriter handles the writing from instructions into BinaryCode objects
    #
    # current (poor) design throws an exception when the assembly can't fit
    # constant loads into one instruction.
    #
    def create_binary
      objects.each do |id , method|
        next unless method.is_a? Parfait::TypedMethod
        writer = BinaryWriter.new(method.binary)
        writer.assemble(method.cpu_instructions)
      end
      log.debug "BinaryInit #{cpu_init.first.object_id.to_s(16)}"
      BinaryWriter.new(binary_init).assemble(cpu_init)
    end

    def boot
      initialize
      Position.positions.clear
      @objects = nil
      @translated = false
      boot_parfait!
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
