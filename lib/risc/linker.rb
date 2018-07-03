require_relative "collector"
require_relative "binary_writer"

module Risc

  # From code, the next step down is Vool, then Mom (in two steps)
  #
  # The next step transforms to the register machine layer, which is quite close to what actually
  #  executes. The step after transforms to Arm, which creates executables.
  #

  class Linker
    include Util::Logging
    log_level :info

    def initialize(platform , assemblers , constants)
      if(platform.is_a?(Symbol))
        platform = platform.to_s.capitalize
        platform = Risc::Platform.for(platform)
      end
      raise "Platform must be platform, not #{platform.class}" unless platform.is_a?(Platform)
      @platform = platform
      @assemblers = assemblers
      @constants = constants
      @cpu_init = cpu_init_init
    end

    attr_reader  :constants , :cpu_init
    attr_reader  :platform , :assemblers

    # machine keeps a list of all objects and their positions.
    # this is lazily created with a collector
    def object_positions
      Collector.collect_space(self) if Position.positions.length < 2 #one is the label
      Position.positions
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
      #need the initial jump at 0 and then functions
      Position.new(@cpu_init).set(0)
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
        next unless Position.is_object(objekt)
        before = at
        raise objekt.class unless( Position.set?(objekt)) #debug check
        position = Position.get(objekt).set(at)
        previous.position_listener(objekt) if previous
        previous = position
        at += objekt.padded_length
        log.debug "Object #{objekt.class}:0x#{before.to_s(16)} len: #{(at - before).to_s(16)}"
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
      assemblers.each do |asm|
        #next unless method.name == :main or method.name == :__init__
        Position.log.debug "Method start #{code_start.to_s(16)} #{asm.method.name}"
        code_pos = CodeListener.init(asm.method.binary, platform)
        instructions = asm.instructions
        InstructionListener.init( instructions, asm.method.binary)
        code_pos.position_listener( LabelListener.new(instructions))
        code_pos.set(code_start)
        code_start = Position.get(asm.method.binary.last_code).next_slot
      end
    end

    # Create Binary code for all methods and the initial jump
    # BinaryWriter handles the writing from instructions into BinaryCode objects
    #
    def create_binary
      prerun
      assemble
      log.debug "BinaryInit #{@cpu_init.object_id.to_s(16)}"
    end

    def prerun
      assemblers.each do |asm|
        asm.instructions.each {|i| i.precheck }
      end
    end

    def assemble
      assemblers.each do |asm|
        writer = BinaryWriter.new(asm.method.binary)
        writer.assemble(asm.instructions)
      end
    end

    private
    # cpu_init come from translating the risc_init
    # risc_init is a branch to the __init__ method
    #
    def cpu_init_init
      init = assemblers.find {|asm| asm.method.name == :__init__}
      risc_init = Branch.new( "__initial_branch__" , init.method.binary )
      @platform.translator.translate(risc_init)
    end

  end

  # module method to reset, and init
  def self.boot!
    Position.clear_positions
    Builtin.boot_functions
  end

end
