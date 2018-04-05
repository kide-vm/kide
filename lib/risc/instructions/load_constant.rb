module Risc
  # load a constant into a register
  #
  # first is the actual constant, either immediate register or object reference (from the space)
  # second argument is the register the constant is loaded into

  class LoadConstant < Instruction
    def initialize source , constant , register
      super(source)
      @register = register
      @constant = constant
      raise "Not Constant #{constant}" if constant.is_a?(Mom::SlotDefinition)
      raise "Not register #{register}" unless RiscValue.look_like_reg(register)
    end
    attr_accessor :register , :constant

    def to_s
      class_source "#{register} <- #{constant_str}"
    end

    private
    def constant_str
      case @constant
      when String , Symbol
        @constant.to_s
      else
        if( @constant.respond_to? :sof_reference_name )
          constant.sof_reference_name
        else
          constant.class.name.to_s
        end
      end
    end
  end
  def self.load_constant( source , constant , register )
    LoadConstant.new source , constant , register
  end
end
