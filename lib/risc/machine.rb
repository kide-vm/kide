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

    # machine keeps a list of all objects. this is lazily created with a collector
    def objects
      @objects ||= Collector.collect_space
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
      Position.new(cpu_init , 0)
      code_start = position_objects( @platform.padding )
      # and then everything code
      position_code(code_start)
    end

    # go through everything that is not code (BinaryCode) and set position
    # padded_length is what determines an objects (byte) length
    # return final position that is stored in code_start
    def position_objects(at)
      # want to have the objects first in the executable
      sorted = objects.values.sort{|left,right| left.class.name <=> right.class.name}
      previous = nil
      sorted.each do | objekt|
        next if objekt.is_a?( Parfait::BinaryCode) or objekt.is_a?( Risc::Label )
        before = at
        position = Position.new(objekt , at)
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
      prev_code = nil
      Parfait.object_space.types.values.each do |type|
        next unless type.methods
        type.methods.each_method do |method|
          last_code = CodeListener.init(method.binary , code_start)
          first_position = InstructionListener.init(method.cpu_instructions, method.binary)
          first_position.set_position( code_start + Parfait::BinaryCode.byte_offset)
          last_code.position_listener( prev_code.object) if prev_code
          prev_code = last_code
          code_start = last_code.next_slot
        end
      end
      #Position.set( first_method.cpu_instructions, code_start + Parfait::BinaryCode.byte_offset , first_method.binary)
      #log.debug "Method #{first_method.name}:#{before.to_s(16)} len: #{(code_start - before).to_s(16)}"
      #log.debug "Instructions #{first_method.cpu_instructions.object_id.to_s(16)}:#{(before+Parfait::BinaryCode.byte_offset).to_s(16)}"
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
