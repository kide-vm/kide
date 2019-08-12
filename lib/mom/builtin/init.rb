module Mom
  module Builtin
    class Init < ::Mom::Instruction
      def to_risc(compiler)
        builder = compiler.builder(compiler.source)
        builder.build do
          factory! << Parfait.object_space.get_factory_for(:Message)
          message << factory[:next_object]
          next_message! << message[:next_message]
          factory[:next_object] << next_message
        end

        Mom::MessageSetup.new(Parfait.object_space.get_main).build_with( builder )

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
          add_code Risc.function_call( "__init__ issue call" ,  Parfait.object_space.get_main)
          add_code exit_label
        end
        compiler.reset_regs
        exit_sequence(builder)
        return compiler
      end
    end

  end
end
