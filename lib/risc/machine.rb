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
    include Util::Logging
    log_level :info

    def initialize
      @booted = false
      @risc_init = nil
      @constants = []
      @next_address = nil
    end
    attr_reader  :constants , :cpu_init
    attr_reader  :booted , :translated
    attr_reader  :platform

    # Translate code to whatever cpu is specified.
    # Currently only :arm and :interpret
    #
    # Translating means translating the initial jump
    # and then translating all methods
    def translate( platform )
      platform = platform.to_s.capitalize
      @platform = Platform.for(platform)
      @translated = true
      translate_methods( @platform.translator )
      @cpu_init = risc_init.to_cpu(@platform.translator)
    end

    # go through all methods and translate them to cpu, given the translator
    def translate_methods(translator)
      Parfait.object_space.get_all_methods.each do |method|
        log.debug "Translate method #{method.name}"
        method.translate_cpu(translator)
      end
    end

    # machine keeps a list of all objects and their positions.
    # this is lazily created with a collector
    def object_positions
      Collector.collect_space if Position.positions.empty?
      Position.positions
    end

    # lazy init risc_init
    def risc_init
      @risc_init ||= Branch.new( "__initial_branch__" , Parfait.object_space.get_init.risc_instructions )
    end
    # add a constant (which get created during compilation and need to be linked)
    def add_constant(const)
      raise "Must be Parfait #{const}" unless const.is_a?(Parfait::Object)
      @constants << const
    end

    # hand out a return address for use as constant the address is added
    def get_address
      10.times do # 10 for whole pages
        @next_address = Parfait::ReturnAddress.new(0,@next_address)
        add_constant( @next_address )
      end unless @next_address
      addr = @next_address
      @next_address = @next_address.next_integer
      addr
    end

    # To create binaries, objects (and labels) need to have a position
    # (so objects can be loaded and branches know where to jump)
    #
    # Position in the order
    # - initial jump
    # - all objects
    # - all code (BinaryCode objects)
    # As code length may change during assembly, this way at least the objects stay
    # in place and we don't have to deal with changing loading code
    def position_all
      raise "Not translated " unless @translated
      #need the initial jump at 0 and then functions
      Position.new(cpu_init).set(0)
      code_start = position_objects( @platform.padding )
      # and then everything code
      position_code(code_start)
    end

    # go through everything that is not code (BinaryCode) and set position
    # padded_length is what determines an objects (byte) length
    # return final position that is stored in code_start
    def position_objects(at)
      # want to have the objects first in the executable
      sorted = object_positions.keys.sort do |left,right|
        left.class.name <=> right.class.name
      end
      previous = nil
      sorted.each do |objekt|
        next if objekt.is_a?( Parfait::BinaryCode) or objekt.is_a?( Risc::Label )
        before = at
        unless( Position.set?(objekt))
          raise objekt.class
        end
        position = Position.get(objekt).set(at)
        previous.position_listener(objekt) if previous
        previous = position
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
    # start at code_start.
    def position_code(code_start)
      Parfait.object_space.types.values.each do |type|
        next unless type.methods
        type.methods.each_method do |method|
          #next unless method.name == :main or method.name == :__init__
          Position.log.debug "Method start #{code_start.to_s(16)} #{method.name}"
          code_pos = CodeListener.init(method.binary)
          InstructionListener.init(method.cpu_instructions, method.binary)
          code_pos.position_listener( LabelListener.new(method.cpu_instructions))
          code_pos.set(code_start)
          code_start = Position.get(method.binary.last_code).next_slot
        end
      end
    end

    # Create Binary code for all methods and the initial jump
    # BinaryWriter handles the writing from instructions into BinaryCode objects
    #
    # current (poor) design throws an exception when the assembly can't fit
    # constant loads into one instruction.
    #
    def create_binary
      object_positions.each do |method,position|
        next unless method.is_a? Parfait::TypedMethod
        writer = BinaryWriter.new(method.binary)
        writer.assemble(method.cpu_instructions)
      end
      log.debug "BinaryInit #{cpu_init.object_id.to_s(16)}"
    end

    def boot
      initialize
      Position.clear_positions
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
