module Vool

  class YieldStatement < Statement
    attr_reader :arguments

    def initialize(name , receiver , arguments)
      @arguments = arguments
      @receiver = receiver
      @name = name
      @arguments ||= []
    end

    def to_s
      "#{receiver}.#{name}(#{arguments.join(', ')})"
    end
    def each(&block)
      block.call(self)
      block.call(@receiver)
      @arguments.each do |arg|
        block.call(arg)
      end
    end

    # A Send breaks down to 2 steps:
    # - Setting up the next message, with receiver, arguments, and (importantly) return address
    # - a SimpleCall,
    def to_mom( compiler )
      @parfait_block = @block.to_mom(compiler) if @block
      @receiver = SelfExpression.new(compiler.receiver_type) if @receiver.is_a?(SelfExpression)
      if(@receiver.ct_type)
        simple_call(compiler)
      else
        raise "ERROR"
      end
    end

    # When used as right hand side, this tells what data to move to get the result into
    # a varaible. It is (off course) the return value of the message
    def slot_definition(compiler)
      Mom::SlotDefinition.new(:message ,[ :return_value])
    end

    def message_setup(in_method,called_method)
      setup  = Mom::MessageSetup.new( called_method )
      mom_receive = @receiver.slot_definition(compiler)
      arg_target = [:message , :next_message , :arguments]
      args = []
      @arguments.each_with_index do |arg , index| # +1 because of type
        args << Mom::SlotLoad.new( arg_target + [index + 1] , arg.slot_definition(compiler))
      end
      setup << Mom::ArgumentTransfer.new( mom_receive , args )
    end

    def simple_call(in_method)
      type = @receiver.ct_type
      called_method = type.resolve_method(@name)
      raise "No method #{@name} for #{type}" unless called_method
      message_setup(in_method,called_method) << Mom::SimpleCall.new(called_method)
    end

  end
end
