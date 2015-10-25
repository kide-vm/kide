module Register

  # the register machine has at least 8 registers, named r0-r5 , :lr and :pc (for historical reasons)
  # we can load and store their contents and
  # access (get/set) memory at a constant offset from a register
  # while the vm works with objects, the register machine has registers,
  #             but we keep the names for better understanding, r4/5 are temporary/scratch
  # there is no direct memory access, only through registers
  # constants can/must be loaded into registers before use

  # Instructions form a graph.
  # Linear instructions form a linked list
  # Branches fan out, Labels collect
  # Labels are the only valid branch targets
  class Instruction
    include Positioned

    def initialize source , nekst = nil
        @source = source
        @next = nekst
    end
    attr_reader :source

    # set the next instruction (also aliased as <<)
    # throw an error if that is set, use insert for that use case
    # return the instruction, so chaining works as one wants (not backwards)
    def set_next nekst
      raise "Next already set #{@next}" if @next
      @next = nekst
      nekst
    end
    alias :<< :set_next

    # during translation we replace one by one
    def replace_next nekst
      old = @next
      @next = nekst
      @next.append old.next if old
    end

    # get the next instruction (without arg given )
    # when given an interger, advance along the line that many time and return.
    def next( amount = 1)
      (amount == 1) ? @next : @next.next(amount-1)
    end
    # set the give instruction as the next, while moving any existing
    # instruction along to the given ones's next.
    # ie insert into the linked list that the instructions form
    def insert instruction
      instruction.set_next @next
      @next = instruction
    end

    # return last set instruction. ie follow the linked list until it stops
    def last
      code = self
      code = code.next while( code.next )
      return code
    end

    # set next for the last (see last)
    # so append the given code to the linked list at the end
    def append code
      last.set_next code
    end

    def length labels = []
      ret = 1
      ret += self.next.length( labels ) if self.next
      ret
    end

    def to_ac labels = []
      ret  = [self.class]
      ret += self.next.to_ac(labels) if self.next
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
      self.position = position
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

  end

end

require_relative "instructions/set_slot"
require_relative "instructions/get_slot"
require_relative "instructions/load_constant"
require_relative "instructions/syscall"
require_relative "instructions/function_call"
require_relative "instructions/function_return"
require_relative "instructions/save_return"
require_relative "instructions/register_transfer"
require_relative "instructions/label"
require_relative "instructions/branch"
require_relative "instructions/operator_instruction"
