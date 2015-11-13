module Register
  # load a constant into a register
  #
  # first is the actual constant, either immediate register or object reference (from the space)
  # second argument is the register the constant is loaded into

  class LoadConstant < Instruction
    def initialize source , constant , register
      super(source)
      @register = register
      @constant = constant
    end
    attr_accessor :register , :constant

    def to_s
      "LoadConstant: #{register} <- #{constant_str}"
    end

    def self.load source , constant , register
      LoadConstant.new source , constant , register
    end
    private
    def constant_str
        case @constant
        when String , Symbol , Fixnum , Integer
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
end
