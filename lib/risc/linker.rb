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

    def initialize(platform)
      if(platform.is_a?(Symbol))
        platform = platform.to_s.capitalize
        platform = Risc::Platform.for(platform)
      end
      raise "Platform must be platform, not #{platform.class}" unless platform.is_a?(Platform)
      @platform = platform
      @risc_init = nil
      @constants = []
    end

    attr_reader  :constants , :cpu_init
    attr_reader  :platform

    # machine keeps a list of all objects and their positions.
    # this is lazily created with a collector
    def object_positions
      Collector.collect_space(self) if Position.positions.length < 2 #one is the label
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
        next unless Position.is_object(objekt)
        before = at
        raise objekt.class unless( Position.set?(objekt)) #debug check
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
      methods = object_positions.keys.find_all{|obj| obj.is_a? Parfait::TypedMethod}
      prerun(methods)
      assemble(methods)
      log.debug "BinaryInit #{cpu_init.object_id.to_s(16)}"
    end

    def prerun(methods)
      methods.each do |method|
        method.cpu_instructions.each {|i| i.precheck }
      end
    end

    def assemble(methods)
      methods.each do |method|
        writer = BinaryWriter.new(method.binary)
        writer.assemble(method.cpu_instructions)
      end
    end

  end

  # module method to reset, and init
  def self.boot!
    Position.clear_positions
    Builtin.boot_functions
  end

end
