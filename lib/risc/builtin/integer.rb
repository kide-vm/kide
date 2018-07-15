#integer related kernel functions
module Risc
  module Builtin
    module Integer
      module ClassMethods
        include CompileHelper

        def div4(context)
          source = "div4"
          compiler = compiler_for(:Integer,:div4 ,{})
          builder = compiler.compiler_builder(compiler.source)
          me = builder.add_known( :receiver )
          builder.reduce_int( source , me )
          two = compiler.use_reg :fixnum , 2
          builder.add_load_data( source , 2 , two )
          builder.add_code Risc.op( source , :>> , me , two)
          builder.add_new_int(source,me , two)
          builder.add_reg_to_slot( source , two , Risc.message_reg , :return_value)
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
          me , other = builder.self_and_int_arg("#{operator} load receiver and arg")
          false_label = Risc.label(compiler.source , "false_label_#{builder.object_id.to_s(16)}")
          merge_label = Risc.label(compiler.source , "merge_label_#{builder.object_id.to_s(16)}")
          builder.reduce_int( "#{operator} fix me", me )
          builder.reduce_int( "#{operator} fix arg", other )
          if(operator.to_s.start_with?('<') )
            me , other = other , me
          end
          builder.add_code Risc.op( "#{operator} operator", :- , me , other)
          builder.add_code IsMinus.new( "#{operator} if", false_label)
          if(operator.to_s.length == 1)
            builder.add_code IsZero.new( "#{operator} if", false_label)
          end
          builder.add_load_constant("#{operator} new int", Parfait.object_space.true_object , other)
          builder.add_code Risc::Branch.new("jump over false", merge_label)
          builder.add_code false_label
          builder.add_load_constant("#{operator} new int", Parfait.object_space.false_object , other)
          builder.add_code merge_label
          builder.add_reg_to_slot( "#{operator} save ret" , other , Risc.message_reg , :return_value)
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
          me , other = builder.self_and_int_arg(op_sym.to_s + "load receiver and arg")
          builder.reduce_int( op_sym.to_s + " fix me", me )
          builder.reduce_int( op_sym.to_s + " fix arg", other )
          builder.add_code Risc.op( op_sym.to_s + " operator", op_sym , me , other)
          builder.add_new_int(op_sym.to_s + " new int", me , other)
          builder.add_reg_to_slot( op_sym.to_s + "save ret" , other , Risc.message_reg , :return_value)
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
          builder.add_reg_to_slot( s , tmp , Risc.message_reg , :return_value)

          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end
      end
      extend ClassMethods
    end
  end
end
