module Arm
  # The arm machine has following instruction classes
  # - Memory
  # - Stack
  # - Logic
  # - Math
  # - Control/Compare
  # - Move
  # - Call  class Instruction
  class Instruction
    def initialize  options
      @attributes = options
    end
    attr_reader :attributes
    def opcode
      @attributes[:opcode]
    end
    def position
      raise "position accessed but not set at #{length} for #{self.inspect}" if @position == nil
      @position
    end
    def set_position pos
      # resetting of position used to be error, but since relink and dynamic instruction size it is ok. in measures
      if @position != nil and ((@position - pos).abs > 32)
        raise "position set again #{pos}!=#{@position} for #{self}" 
      end
      @position = pos
    end

    # this is giving read access to the attributes hash via .attibute syntax
    # so for an instruction pop you can write pop.opcode to get the :opcode attribute

    # TODDO: review (don't remember what the "set_" stuff was for)
    def method_missing name , *args , &block 
      return super unless (args.length <= 1) or block_given?
      set , attribute = name.to_s.split("set_")
      if set == ""
        @attributes[attribute.to_sym] = args[0] || 1
        return self 
      else
        return super
      end
      return @attributes[name.to_sym]
    end
  end
end

require_relative "constants"
require_relative "instructions/call_instruction"
require_relative "instructions/compare_instruction"
require_relative "instructions/logic_instruction"
require_relative "instructions/memory_instruction"
require_relative "instructions/move_instruction"
require_relative "instructions/stack_instruction"
