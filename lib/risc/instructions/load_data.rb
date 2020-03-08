module Risc
  # load raw data into a register
  #
  # This is not really used by the compiler, or to be more precise: not used during the
  # compilation of ruby code. Ruby code works on Objects only
  #
  # But for Builtin methods, methods that are created programatically and form the runtime,
  # it can be handy to load an integer directly without the object overhead.
  #
  class LoadData < Instruction
    def initialize( source , constant , register)
      super(source)
      @register = register
      @constant = constant
      raise "Not Integer #{constant}" unless constant.is_a?(Integer)
      raise "Not register #{register}" unless RegisterValue.look_like_reg(register)
    end
    attr_accessor :register , :constant

    def to_s
      class_source "#{register} <- #{constant}"
    end

  end
  def self.load_data( source , value , register = nil )
    raise "can only load integers, not #{value}" unless value.is_a?(Integer)
    type =  Parfait.object_space.get_type_by_class_name(:Integer)
    register = RegisterValue.new( "fix_#{value}".to_sym , type ) unless register
    LoadData.new( source , value , register)
  end
end
