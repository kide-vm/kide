module Risc
  # load a constant into a register
  #
  # first is the actual constant, either immediate register or object reference (from the space)
  # second argument is the register the constant is loaded into

  class LoadConstant < Instruction
    def initialize( source , constant , register)
      super(source)
      @register = register
      @constant = constant
      raise "Not Constant #{constant}" if constant.is_a?(SlotMachine::Slot)
      raise "Not register #{register}" unless register.is_a?(RegisterValue)
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
        if( @constant.respond_to? :rxf_reference_name )
          constant.rxf_reference_name
        else
          constant.class.name.to_s
        end
      end
    end
  end
  def self.load_constant( source , constant )
    if(constant.is_a?(Parfait::Object))
      type = constant.get_type
      value = constant
    else
      type = constant.ct_type
      value = constant.value
    end
    register = RegisterValue.new( "id_#{value.object_id}".to_sym , type )
    LoadConstant.new( source , constant , register )
  end
end
