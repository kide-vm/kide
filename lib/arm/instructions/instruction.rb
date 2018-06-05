require "util/list"
module Arm
  # Arm instruction base class
  # Mostly linked list functionality that all instructions have
  class Instruction
    include Constants
    include Attributed
    include Util::List

    def initialize( source , nekst = nil )
      @source = source
      @next = nekst
      return unless source
      raise "Source must be string or Instruction, not #{source.class}" unless source.is_a?(String) or source.is_a?(Mom::Instruction)
    end
    attr_reader :source

    def total_byte_length
      ret = 0
      self.each{|ins| ret += ins.byte_length}
      ret
    end

    def insert(instruction)
      super
      my_pos = Risc::Position.get(self)
      listener = Risc::InstructionListener.new( instruction , my_pos.get_code )
      my_pos.position_listener(listener)
    end
  end
end
