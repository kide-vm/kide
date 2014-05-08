module Intel

  ##
  # Register is a general X86 register, such as eax, ebx, ecx, edx,
  # etc...

  class Register < Operand
    attr_accessor :id

    def initialize machine = nil, id = nil , bits = nil
      super(machine, bits)
      self.id = id
    end

    def get address # TODO: test
      self.mov address
      self.mov {self}
    end

    def push_mod_rm_on spareRegister, stream
      stream << (0b11000000 + id + (spareRegister.id << 3))
    end

    def m
      self + 0
    end

    def - offset
      self + -offset
    end

    def + offset
      address         = Address.new
      address.machine = machine
      address.id      = id
      address.offset  = offset
      address
    end
  end

  # MemoryRegister is a regular Register, but the parser needs to know
  # if it is a primary or secondary register. This form is a private
  # secondary register. Use Register instead of this guy.

  class MemoryRegister < Register
    
    def initialize bits
      super(nil,nil,bits)
    end
  end

end
