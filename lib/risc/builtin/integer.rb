#integer related kernel functions
module Risc
  module Builtin
    module Integer
      module ClassMethods
        include CompileHelper

        def div4(context)
          compiler = compiler_for(:Integer,:div4 ,{})
          compiler.compiler_builder(compiler.source).build do
            integer << message[:receiver]
            integer.reduce_int
            integer_reg << 2
            integer.op :>> , integer_reg
            add_new_int("div4", integer , integer_reg)
            message[:return_value] << integer_reg
          end
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end
        def >( context )
          comparison( :> )
        end
        def <( context )
          comparison( :< )
        end
        def <=( context )
          comparison( :<= )
        end
        def >=( context )
          comparison( :>= )
        end
        def comparison( operator  )
          compiler = compiler_for(:Integer, operator ,{other: :Integer})
          builder = compiler.compiler_builder(compiler.source)
          builder.build do
            integer << message[:receiver]
            integer_reg << message[:arguments]
            integer_reg << integer_reg[ 1]
            integer.reduce_int
            integer_reg.reduce_int
            swap_names(:integer , :integer_reg) if(operator.to_s.start_with?('<') )
            integer.op :- , integer_reg
            if_minus false_label
            if_zero( false_label ) if operator.to_s.length == 1
            object << Parfait.object_space.true_object
            branch merge_label
            add_code false_label
            object << Parfait.object_space.false_object
            add_code merge_label
            message[:return_value] << object
          end
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end

        def putint(context)
          compiler = compiler_for(:Integer,:putint ,{})
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end
        def operator_method( op_sym )
          compiler = compiler_for(:Integer, op_sym ,{other: :Integer})
          builder = compiler.compiler_builder(compiler.source)
          builder.build do
            integer << message[:receiver]
            integer_reg << message[:arguments]
            integer_reg << integer_reg[ 1]
            integer.reduce_int
            integer_reg.reduce_int
            integer.op op_sym , integer_reg
            add_new_int op_sym.to_s , integer , integer_reg
            message[:return_value] << integer_reg
          end
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end
        def div10( context )
          s = "div_10 "
          compiler = compiler_for(:Integer,:div10 ,{})
          builder = compiler.compiler_builder(compiler.source)
          #FIX: this could load receiver once, reduce and then transfer twice
          me = builder.add_known( :receiver )
          tmp = builder.add_known( :receiver )
          q = builder.add_known( :receiver )
          builder.reduce_int( s , me )
          builder.reduce_int( s , tmp )
          builder.reduce_int( s , q )
          const = compiler.use_reg :fixnum , value: 1
          builder.add_load_data( s , 1 , const )
          # int tmp = self >> 1
          builder.add_code Risc.op( s , :>> , tmp , const)
          # int q = self >> 2
          builder.add_load_data( s , 2 , const)
          builder.add_code Risc.op( s , :>> , q , const)
          # q = q + tmp
          builder.add_code Risc.op( s , :+ , q , tmp )
          # tmp = q >> 4
          builder.add_load_data( s , 4 , const)
          builder.add_transfer( s, q , tmp)
          builder.add_code Risc.op( s , :>> , tmp , const)
          # q = q + tmp
          builder.add_code Risc.op( s , :+ , q , tmp )
          # tmp = q >> 8
          builder.add_load_data( s , 8 , const)
          builder.add_transfer( s, q , tmp)
          builder.add_code Risc.op( s , :>> , tmp , const)
          # q = q + tmp
          builder.add_code Risc.op( s , :+ , q , tmp )
          # tmp = q >> 16
          builder.add_load_data( s , 16 , const)
          builder.add_transfer( s, q , tmp)
          builder.add_code Risc.op( s , :>> , tmp , const)
          # q = q + tmp
          builder.add_code Risc.op( s , :+ , q , tmp )
          # q = q >> 3
          builder.add_load_data( s , 3 , const)
          builder.add_code Risc.op( s , :>> , q , const)
          # tmp = q * 10
          builder.add_load_data( s , 10 , const)
          builder.add_transfer( s, q , tmp)
          builder.add_code Risc.op( s , :* , tmp , const)
          # tmp = self - tmp
          builder.add_code Risc.op( s , :- , me , tmp )
          builder.add_transfer( s , me , tmp)
          # tmp = tmp + 6
          builder.add_load_data( s , 6 , const)
          builder.add_code Risc.op( s , :+ , tmp , const )
          # tmp = tmp >> 4
          builder.add_load_data( s , 4 , const)
          builder.add_code Risc.op( s , :>> , tmp , const )
          # return q + tmp
          builder.add_code Risc.op( s , :+ , q , tmp )

          builder.add_new_int(s,q , tmp)
          builder.add_reg_to_slot( s , tmp , Risc.message_reg , :return_value)

          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end
      end
      extend ClassMethods
    end
  end
end
