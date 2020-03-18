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

    # return an array of names of registers that is used by the instruction
    def register_names
      [register.symbol]
    end

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

  def self.load_constant( source , constant , register = nil)
    value = constant
    unless register
      case constant
      when Parfait::Object
        type = constant.get_type
      when Label
        type = constant.address.get_type
      else
        type = constant.ct_type
        value = constant.value
      end
      value_class = value.class.name.to_s.split("::").last.downcase
      register = RegisterValue.new( "id_#{value_class}_#{value.object_id}".to_sym , type )
    end
    LoadConstant.new( source , constant , register )
  end
end
