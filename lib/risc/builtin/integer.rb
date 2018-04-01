#integer related kernel functions
module Risc
  module Builtin
    module Integer
      module ClassMethods
        include CompileHelper

        def mod4(context)
          source = "mod4"
          compiler = compiler_for(:Integer,:mod4 ,{})
          me = compiler.add_known( :receiver )
          compiler.reduce_int( source , me )
          two = compiler.use_reg :fixnum , 2
          compiler.add_load_data( source , 2 , two )
          compiler.add_code Risc.op( source , :>> , me , two)
          compiler.add_new_int(source,me , two)
          compiler.add_reg_to_slot( source , two , :message , :return_value)
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
          me , other = compiler.self_and_int_arg(op_name + "load receiver and arg")
          compiler.reduce_int( op_name + " fix me", me )
          compiler.reduce_int( op_name + " fix arg", other )
          compiler.add_code Risc.op( op_name + " operator", op_sym , me , other)
          compiler.add_new_int(op_name + " new int", me , other)
          compiler.add_reg_to_slot( op_name + "save ret" , other , :message , :return_value)
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end
        def div10( context )
          s = "div_10 "
          compiler = compiler_for(:Integer,:div10 ,{})
          #FIX: this could load receiver once, reduce and then transfer twice
          me = compiler.add_known( :receiver )
          tmp = compiler.add_known( :receiver )
          q = compiler.add_known( :receiver )
          compiler.reduce_int( s , me )
          compiler.reduce_int( s , tmp )
          compiler.reduce_int( s , q )
          const = compiler.use_reg :fixnum , 1
          compiler.add_load_data( s , 1 , const )
          # int tmp = self >> 1
          compiler.add_code Risc.op( s , :>> , tmp , const)
          # int q = self >> 2
          compiler.add_load_data( s , 2 , const)
          compiler.add_code Risc.op( s , :>> , q , const)
          # q = q + tmp
          compiler.add_code Risc.op( s , :+ , q , tmp )
          # tmp = q >> 4
          compiler.add_load_data( s , 4 , const)
          compiler.add_transfer( s, q , tmp)
          compiler.add_code Risc.op( s , :>> , tmp , const)
          # q = q + tmp
          compiler.add_code Risc.op( s , :+ , q , tmp )
          # tmp = q >> 8
          compiler.add_load_data( s , 8 , const)
          compiler.add_transfer( s, q , tmp)
          compiler.add_code Risc.op( s , :>> , tmp , const)
          # q = q + tmp
          compiler.add_code Risc.op( s , :+ , q , tmp )
          # tmp = q >> 16
          compiler.add_load_data( s , 16 , const)
          compiler.add_transfer( s, q , tmp)
          compiler.add_code Risc.op( s , :>> , tmp , const)
          # q = q + tmp
          compiler.add_code Risc.op( s , :+ , q , tmp )
          # q = q >> 3
          compiler.add_load_data( s , 3 , const)
          compiler.add_code Risc.op( s , :>> , q , const)
          # tmp = q * 10
          compiler.add_load_data( s , 10 , const)
          compiler.add_transfer( s, q , tmp)
          compiler.add_code Risc.op( s , :* , tmp , const)
          # tmp = self - tmp
          compiler.add_code Risc.op( s , :- , me , tmp )
          compiler.add_transfer( s , me , tmp)
          # tmp = tmp + 6
          compiler.add_load_data( s , 6 , const)
          compiler.add_code Risc.op( s , :+ , tmp , const )
          # tmp = tmp >> 4
          compiler.add_load_data( s , 4 , const)
          compiler.add_code Risc.op( s , :>> , tmp , const )
          # return q + tmp
          compiler.add_code Risc.op( s , :+ , q , tmp )

          compiler.add_new_int(s,q , tmp)
          compiler.add_reg_to_slot( s , tmp , :message , :return_value)

          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end
      end
      extend ClassMethods
    end
  end
end
