module Vool
  class ReturnStatement < Statement
    include Normalizer

    attr_reader :return_value

    def initialize(value)
      @return_value = value
    end

    def normalize
      val , rest = *normalize_name(@return_value)
      me = ReturnStatement.new(val)
      return me unless rest
      rest << me
      rest
    end

    def each(&block)
      block.call(@return_value)
    end

    # Since the return is normalized to only allow simple values it is simple.
    # To return form a method in mom instructions we only need to do two things:
    # - store the given return value, this is a SlotMove
    # - activate return sequence (reinstantiate old message and jump to return address)
    def to_mom( method )
      ret = Mom::SlotLoad.new( [:message , :return_value] , @return_value.slot_definition(method) )
      ret << Mom::ReturnSequence.new
    end

    def to_s(depth = 0)
      at_depth(depth , "return #{@return_value.to_s}")
    end
  end
end
