module SlotMachine
  # Init "method" is the first thing that happens in the machine
  # There is an inital jump to it, but that's it, no setup, no nothing
  #
  # The method is in quotes, because it is not really a method, it does not return!!
  # This is common to all double underscore "methods", but __init also does not
  # rely on the message. In fact it's job is to set up the first message
  # and to call the main (possibly later _init_ , single undescrore)
  #
  class Init < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      main = Parfait.object_space.get_method!(:Space, :main)
      # Set up the first message, but advance one, so main has somewhere to return to
      builder.build do
        factory! << Parfait.object_space.get_factory_for(:Message)
        message << factory[:next_object]
        next_message! << message[:next_message]
        factory[:next_object] << next_message
      end
      builder.reset_names
      # Set up the call to main, with space as receiver
      SlotMachine::MessageSetup.new(main).build_with( builder )
      builder.build do
        message << message[:next_message]
        space? << Parfait.object_space
        message[:receiver] << space
      end
      # set up return address and jump to main
      exit_label = Risc.label(compiler.source , "#{compiler.receiver_type.object_class.name}.#{compiler.source.name}" )
      ret_tmp = compiler.use_reg(:Label).set_builder(builder)
      builder.build do
        ret_tmp << exit_label
        message[:return_address] << ret_tmp
        add_code Risc.function_call( "__init__ issue call" ,  main)
        add_code exit_label
      end
      compiler.reset_regs
      Macro.exit_sequence(builder)  # exit will use mains return_value as exit_code
      return compiler
    end
  end
end
