module Vool
  class ReturnStatement < Statement

    attr_reader :return_value

    def initialize(value)
      @return_value = value
    end

    def each(&block)
      block.call(@return_value)
    end

    # Since the return is normalized to only allow simple values it is simple.
    # To return form a method in mom instructions we only need to do two things:
    # - store the given return value, this is a SlotMove
    # - activate return sequence (reinstantiate old message and jump to return address)
    def to_mom( compiler )
      ret = Mom::SlotLoad.new( self , [:message , :return_value] ,
                        @return_value.slot_definition(compiler) )
      ret << Mom::ReturnJump.new(self , compiler.return_label )
    end

    def to_s(depth = 0)
      at_depth(depth , "return #{@return_value.to_s}")
    end
  end
end
