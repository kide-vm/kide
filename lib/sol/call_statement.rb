module Sol

  class CallStatement < Statement
    attr_reader :name , :receiver , :arguments

    def initialize(name , receiver , arguments )
      @name , @receiver , @arguments = name , receiver , arguments
      @arguments ||= []
    end

    # When used as right hand side, this tells what data to move to get the result into
    # a varaible. It is (off course) the return value of the message
    def to_slot_definition(_)
      SlotMachine::SlotDefinition.for(:message ,[ :return_value])
    end

    def to_s(depth = 0)
      sen = "#{receiver}.#{name}(#{@arguments.collect{|a| a.to_s}.join(', ')})"
      at_depth(depth , sen)
    end

    def each(&block)
      block.call(self)
      block.call(@receiver)
      @arguments.each do |arg|
        block.call(arg)
      end
    end

  end
end
