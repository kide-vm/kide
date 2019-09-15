module Mom
  class Init < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      main = Parfait.object_space.get_method!(:Space, :main)

      builder.build do
        factory! << Parfait.object_space.get_factory_for(:Message)
        message << factory[:next_object]
        next_message! << message[:next_message]
        factory[:next_object] << next_message
      end
      builder.reset_names
      Mom::MessageSetup.new(main).build_with( builder )

      builder.build do
        message << message[:next_message]
        space? << Parfait.object_space
        message[:receiver] << space
      end

      exit_label = Risc.label(compiler.source , "#{compiler.receiver_type.object_class.name}.#{compiler.source.name}" )
      ret_tmp = compiler.use_reg(:Label).set_builder(builder)
      builder.build do
        ret_tmp << exit_label
        message[:return_address] << ret_tmp
        add_code Risc.function_call( "__init__ issue call" ,  main)
        add_code exit_label
      end
      compiler.reset_regs
      Macro.exit_sequence(builder)
      return compiler
    end
  end
end
