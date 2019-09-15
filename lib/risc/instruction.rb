require "util/list"

module Risc

  # the register machine has at least 8 registers, named r0-r5 , :lr and :pc
  # (for historical reasons , r for register, pc for ProgramCounter ie next instruction address
  # and lr means LinkRegister, ie the location where to return to when in a function)
  #
  # We can load and store their contents, move data between them and
  #   access (get/set) memory at a constant offset from a register
  # While Mom works with objects, the register machine has registers,
  #             but we keep the names for better understanding, r2-5 are temporary/scratch
  # There is no direct memory access, only through registers
  # Constants can/must be loaded into registers before use

  # At compile time, Instructions form a linked list (:next attribute is the link)
  # At run time Instructions are traversesed as a graph
  #
  # Branches fan out, Labels collect
  # Labels are the only valid branch targets
  #
  class Instruction
    include Util::List

    def initialize( source , nekst = nil )
      @source = source
      @next = nekst
      return unless source
      raise "Source must be string or Instruction, not #{source.class}" unless source.is_a?(String) or
                source.is_a?(Mom::Instruction) or source.is_a?(Parfait::Callable)
    end
    attr_reader :source

    def to_arr
      ret  = []
      self.each {|ins| ret << ins}
      ret
    end

    # just part of the protocol, noop in this case
    def precheck
    end

    def to_cpu( translator )
      translator.translate( self )
    end

    def class_source( derived)
      "#{self.class.name.split("::").last}: #{derived} #{source_mini}"
    end
    def source_mini
      return "(no source)" unless source
      return "(from: #{source[0..50]})" if source.is_a?(String)
      "(from: #{source.class.name.split("::").last})"
    end
  end

end

require_relative "instructions/setter"
require_relative "instructions/getter"
require_relative "instructions/reg_to_slot"
require_relative "instructions/slot_to_reg"
require_relative "instructions/reg_to_byte"
require_relative "instructions/byte_to_reg"
require_relative "instructions/load_constant"
require_relative "instructions/load_data"
require_relative "instructions/syscall"
require_relative "instructions/function_call"
require_relative "instructions/function_return"
require_relative "instructions/transfer"
require_relative "instructions/label"
require_relative "instructions/branch"
require_relative "instructions/dynamic_jump"
require_relative "instructions/operator_instruction"
