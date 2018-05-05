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

    def set_position( position , count )
      Risc::Position.set_position(self,position)
      position += byte_length
      if self.next
        count += 1 #assumes 4 byte instructions, as does the whole setup
        if( 0 == count % 12) # 12 is the amount of instructions that fit into a BinaryCode
          count = 0
          position += 12 # 12=3*4 , 3 for marker,type,next words to jump over
        end
        self.next.set_position( position , count )
      else
        position
      end
    end

  end
end
