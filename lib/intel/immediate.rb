require 'intel/operand'

module Intel
  ##
  # Immediate is an Integer wrapper so that we know the machine we're
  # dealing with when we apply commands

  class Immediate < Operand
    attr_accessor :value

    def initialize( bits = nil )
      super(nil , bits)
    end
    
    def immediate?
      true
    end
  end

end
