#integer related kernel functions
module Risc
  module Builtin
    module Integer
      module ClassMethods
        include AST::Sexp
        include CompileHelper

        def mod4 context
          compiler = compiler_for(:Integer,:mod4 ,{})
          return compiler.method
        end
        def putint context
          compiler = compiler_for(:Integer,:putint ,{})
          return compiler.method
        end


        def div10 context
          s = "div_10"
          compiler = compiler_for(:Integer,:div10 ,{})
          me = compiler.add_known( :receiver )
          tmp = compiler.add_known( :receiver )
          q = compiler.add_known( :receiver )
          const = compiler.use_reg :Integer , 1
          compiler.add_load_constant( s, 1 , const )
          # int tmp = self >> 1
          compiler.add_code Risc.op( s , ">>" , tmp , const)
          # int q = self >> 2
          compiler.add_load_constant( s , 2 , const)
          compiler.add_code Risc.op( s , ">>" , q , const)
          # q = q + tmp
          compiler.add_code Risc.op( s , "+" , q , tmp )
          # tmp = q >> 4
          compiler.add_load_constant( s , 4 , const)
          compiler.add_transfer( s, q , tmp)
          compiler.add_code Risc.op( s , ">>" , tmp , const)
          # q = q + tmp
          compiler.add_code Risc.op( s , "+" , q , tmp )
          # tmp = q >> 8
          compiler.add_load_constant( s , 8 , const)
          compiler.add_transfer( s, q , tmp)
          compiler.add_code Risc.op( s , ">>" , tmp , const)
          # q = q + tmp
          compiler.add_code Risc.op( s , "+" , q , tmp )
          # tmp = q >> 16
          compiler.add_load_constant( s , 16 , const)
          compiler.add_transfer( s, q , tmp)
          compiler.add_code Risc.op( s , ">>" , tmp , const)
          # q = q + tmp
          compiler.add_code Risc.op( s , "+" , q , tmp )
          # q = q >> 3
          compiler.add_load_constant( s , 3 , const)
          compiler.add_code Risc.op( s , ">>" , q , const)
          # tmp = q * 10
          compiler.add_load_constant( s , 10 , const)
          compiler.add_transfer( s, q , tmp)
          compiler.add_code Risc.op( s , "*" , tmp , const)
          # tmp = self - tmp
          compiler.add_code Risc.op( s , "-" , me , tmp )
          compiler.add_transfer( s , me , tmp)
          # tmp = tmp + 6
          compiler.add_load_constant( s , 6 , const)
          compiler.add_code Risc.op( s , "+" , tmp , const )
          # tmp = tmp >> 4
          compiler.add_load_constant( s , 4 , const)
          compiler.add_code Risc.op( s , ">>" , tmp , const )
          # return q + tmp
          compiler.add_code Risc.op( s , "+" , q , tmp )
          compiler.add_reg_to_slot( s , q , :message , :return_value)
          return compiler.method
        end
      end
      extend ClassMethods
    end
  end
end
