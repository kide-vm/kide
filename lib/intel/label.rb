module Intel
  ##
  # Label is a known point in the byte stream that we can jmp/loop back to.

  class Label < Operand
    attr_accessor :position

    def initialize machine , position = nil
      super( machine) 
      @position = position
    end

    def bits
      distance = machine.stream.size - position

      if distance < 256 then
        8
      elsif distance < 65536 then
        16
      else
        32
      end
    end
  end
  
  ##
  # FutureLabel is a label in memory that hasn't been defined yet and
  # will go back and fill in the appropriate memory bytes later

  class FutureLabel < Label
    attr_accessor :positions

    def initialize(machine)
      super( machine )
      self.positions = []
    end

    def plant
      self.position = machine.stream.size

      positions.each do |each|
        size = machine.stream[each + 1]
        address = []
        case size
        when 2 then
          address.push_B(position - each - 2)
        when 3 then
          address.push_W(position - each - 3)
        when 5 then
          address.push_D(position - each - 5)
        else
          raise "unhandled size #{size}"
        end

        address.each_with_index do |byte, index|
          idx = each + index + 1
          machine.stream[idx] = byte
        end
      end
    end

    def add aPosition
      positions << aPosition
    end
  end
end
