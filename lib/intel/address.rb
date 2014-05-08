require 'intel/operand'

module Intel
  ##
  # Address is a memory address in one of the following example forms:
  #
  #     eax, ebx + ecx, eax + 5, 23545, edx + eax + 2312

  class Address < Operand
    attr_accessor :id, :index
    attr_reader :offset
    attr_writer :isAssemblerOffset # FIX

    def initialize isAssemblerOffset = nil, bits = nil, id = nil
      super(nil,bits)

      self.isAssemblerOffset = isAssemblerOffset
      self.id = id

      self.index = self.offset = nil
    end

    def bits
      super || self.machine.bits
    end

    def offset= obj
      if obj.is_a?(Register) then
        @offset = 0
        self.index = obj
      else
        @offset = obj
      end
    end

    def + o # TODO: this seems totally and completely wrong
      if o.is_a?(Register) then
        self.index = o
      else
        self.offset = o
      end
      self
    end

    def address?
      true
    end

    def offset?
      @isAssemblerOffset.nil? ? id.nil? : @isAssemblerOffset
    end

    def push_mod_rm_on spareRegister, stream
      if id.nil? then
        stream << (0b00000101 + (spareRegister.id << 3))
        return stream.push_D(offset)
      end

      modrm = case offset
              when 0 then
                0b00000000
              when 1..255 then
                0b01000000
              else
                0b10000000
              end

      if index.nil? then
        modrm += (spareRegister.id << 3)
      else
        stream << (0b00000100 + (spareRegister.id << 3))
        modrm += (index.id << 3)
      end

      stream << modrm + id

      return self if offset == 0
      return stream.push_B(offset) if offset < 256

      stream.push_D offset
    end

    def m
      self
    end
  end

end
