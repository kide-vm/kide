#integer related kernel functions
module Risc
  module Builtin
    module Integer
      module ClassMethods
        include CompileHelper

        def mod4(context)
          source = "mod4"
          compiler = compiler_for(:Integer,:mod4 ,{})
          builder = compiler.builder(true, compiler.method)
          me = builder.add_known( :receiver )
          builder.reduce_int( source , me )
          two = compiler.use_reg :fixnum , 2
          builder.add_load_data( source , 2 , two )
          builder.add_code Risc.op( source , :>> , me , two)
          builder.add_new_int(source,me , two)
          builder.add_reg_to_slot( source , two , :message , :return_value)
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end
        def putint(context)
          compiler = compiler_for(:Integer,:putint ,{})
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end
        def *( context )
          operator_method( "mult" , :*)
        end
        def +( context )
          operator_method( "plus" , :+)
        end
        def -( context )
          operator_method( "minus" , :-)
        end
        def operator_method(op_name , op_sym )
          compiler = compiler_for(:Integer, op_sym ,{other: :Integer})
          builder = compiler.builder(true, compiler.method)
          me , other = builder.self_and_int_arg(op_name + "load receiver and arg")
          builder.reduce_int( op_name + " fix me", me )
          builder.reduce_int( op_name + " fix arg", other )
          builder.add_code Risc.op( op_name + " operator", op_sym , me , other)
          builder.add_new_int(op_name + " new int", me , other)
          builder.add_reg_to_slot( op_name + "save ret" , other , :message , :return_value)
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end
        def div10( context )
          s = "div_10 "
          compiler = compiler_for(:Integer,:div10 ,{})
          builder = compiler.builder(true, compiler.method)
          #FIX: this could load receiver once, reduce and then transfer twice
          me = builder.add_known( :receiver )
          tmp = builder.add_known( :receiver )
          q = builder.add_known( :receiver )
          builder.reduce_int( s , me )
          builder.reduce_int( s , tmp )
          builder.reduce_int( s , q )
          const = compiler.use_reg :fixnum , 1
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
          builder.add_reg_to_slot( s , tmp , :message , :return_value)

          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end
      end
      extend ClassMethods
    end
  end
end
