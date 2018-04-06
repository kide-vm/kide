module Risc

  # RiscValue is like a variable name, a storage location. The location is a register off course.

  class RiscValue

    attr_reader :symbol , :type , :value

    attr_accessor :builder

    def initialize( r , type , value = nil)
      raise "wrong type for register init #{r}" unless r.is_a? Symbol
      raise "double r #{r}" if r.to_s[0,1] == "rr"
      raise "not reg #{r}" unless self.class.look_like_reg r
      @type = type
      @symbol = r
      @value = value
    end

    def to_s
      s = "#{symbol}:#{type}"
      s += ":#{value}" if value
      s
    end

    def reg_no
      @symbol.to_s[1 .. -1].to_i
    end

    def self.look_like_reg is_it
      return true if is_it.is_a? RiscValue
      return false unless is_it.is_a? Symbol
      if( [:lr , :pc].include? is_it )
        return true
      end
      if( (is_it.to_s.length <= 3) and (is_it.to_s[0] == "r"))
        # could tighten this by checking that the rest is a number
        return true
      end
      return false
    end

    def == other
      return false if other.nil?
      return false if other.class != RiscValue
      symbol == other.symbol
    end

    #helper method to calculate with register symbols
    def next_reg_use( type , value = nil )
      int = @symbol[1,3].to_i
      raise "No more registers #{self}" if int > 8
      sym = "r#{int + 1}".to_sym
      RiscValue.new( sym , type, value)
    end

    def sof_reference_name
      @symbol
    end

    def <<( load )
      puts "LOAD #{load}"
      case load
      when RValue
        raise "not yet"
      when Parfait::Object
        ins = Risc.load_constant("#{load.class} to #{self.type}" , load , self)
      when RiscValue
        ins = Risc.transfer("#{load.type} to #{self.type}" , load , self)
      else
        raise "not implemented"
      end
      builder.add_instruction(ins) if builder
      return ins
    end
  end

  # The register we use to store the current message object is :r0
  def self.message_reg
    RiscValue.new :r0 , :Message
  end

  # The register we use to store the new message object is :r3
  # The new message is the one being built, to be sent
  def self.new_message_reg
    RiscValue.new :r1 , :Message
  end

  # The first scratch register. There is a next_reg_use to get a next and next.
  # Current thinking is that scratch is schatch between instructions
  def self.tmp_reg( type , value = nil)
    RiscValue.new :r1 , type , value
  end

end
