module SlotMachine

  # Base class for SlotMachine instructions
  # At the base class level instructions are a linked list.
  #
  # SlotMachine::Instructions are created by the Sol level as an intermediate step
  # towards the next level down, the Risc level.
  # SlotMachine and Risc are both abstract machines (ie have instructions), so both
  # share the linked list functionality (In Util::List)
  #
  # To convert a SlotMachine instruction to it's Risc equivalent to_risc is called
  #
  class Instruction
    include Util::List

    def initialize( source , nekst = nil )
      @source = source
      @next = nekst
      return unless source
      unless source.is_a?(String) or
             source.is_a?(Sol::Statement)
          raise "Source must be string or Instruction, not #{source.class}"
      end
    end
    attr_reader :source

    # to_risc, like the name says, converts the instruction to it's Risc equivalent.
    # The Risc machine is basically a simple register machine (kind of arm).
    # In other words SlotMachine is the higher abstraction and so slot instructions convert
    # to many (1-10) risc instructions
    #
    # The argument that is passed is a MethodCompiler, which has the method and some
    # state about registers used. (also provides helpers to generate risc instructions)
    def to_risc(compiler)
      raise self.class.name + "_todo"
    end
  end

end

require_relative "instruction/label"
require_relative "instruction/check"
require_relative "instruction/basic_values"
require_relative "instruction/simple_call"
require_relative "instruction/dynamic_call"
require_relative "instruction/block_yield"
require_relative "instruction/resolve_method"
require_relative "instruction/truth_check"
require_relative "instruction/not_same_check"
require_relative "instruction/same_check"
require_relative "instruction/jump"
require_relative "instruction/return_jump"
require_relative "instruction/slot_load"
require_relative "instruction/return_sequence"
require_relative "instruction/message_setup"
require_relative "instruction/argument_transfer"
