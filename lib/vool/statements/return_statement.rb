module Vool
  class ReturnStatement < Statement
    attr_reader :return_value

    def initialize(value)
      @return_value = value
    end

    def collect(arr)
      @return_value.collect(arr)
      super
    end

    # To return form a method in mom instructions we need to do three things:
    # - store the given return value, this is a SlotMove / SlotConstant
    # - activate return sequence (reinstantiate old message and jump to return address)
    def to_mom( method )
      move = @return_value.slot_class.new( [:message , :return_value] , @return_value)
      Mom::Statements.new [move , Mom::ReturnSequence.new]
    end

  end
end
