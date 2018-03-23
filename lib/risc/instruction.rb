require "common/list"

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
    include Common::List

    def initialize source , nekst = nil
      @source = source
      @next = nekst
      return unless source
      raise "Source must be string or Instruction, not #{source.class}" unless source.is_a?(String) or source.is_a?(Mom::Instruction)
    end
    attr_reader :source

    #TODO check if this is used. Maybe build an each for instructions
    def to_arr labels = []
      ret  = [self.class]
      ret += self.next.to_arr(labels) if self.next
      ret
    end

    # derived classes must provide a byte_length
    def byte_length
      raise "Abstract called on #{self}"
    end

    def assemble_all io , labels = []
      self.assemble(io)
      self.next.assemble_all(io, labels) if self.next
    end

    def assemble io
      raise "Abstract called on #{self}"
    end

    def total_byte_length labels = []
      ret = self.byte_length
      ret += self.next.total_byte_length(labels) if self.next
      #puts "#{self.class.name} return #{ret}"
      ret
    end

    def set_position position , labels = []
      Positioned.set_position(self,position)
      position += byte_length
      if self.next
        self.next.set_position(position , labels)
      else
        position
      end
    end

    def each_label labels =[] , &block
      self.next.each_label(labels , &block) if self.next
    end

    def class_source( derived)
      "#{self.class.name.split("::").last}: #{derived} #{source_mini}"
    end
    def source_mini
      return "(no source)" unless source
      return "(from: #{source[0..25]})" if source.is_a?(String)
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
require_relative "instructions/syscall"
require_relative "instructions/function_call"
require_relative "instructions/function_return"
require_relative "instructions/transfer"
require_relative "instructions/label"
require_relative "instructions/branch"
require_relative "instructions/operator_instruction"
