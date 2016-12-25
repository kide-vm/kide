#integer related kernel functions
module Register
  module Builtin
    module Integer
      module ClassMethods
        include AST::Sexp

        def mod4 context
          compiler = Typed::MethodCompiler.new.create_method(:Integer,:mod4 ).init_method
          return compiler.method
        end
        def putint context
          compiler = Typed::MethodCompiler.new.create_method(:Integer,:putint ).init_method
          return compiler.method
        end


        def div10 context
          s = "div_10"
          compiler = Typed::MethodCompiler.new.create_method(:Integer,:div10 ).init_method
          me = compiler.process( Typed::Tree::NameExpression.new( :self) )
          tmp = compiler.process( Typed::Tree::NameExpression.new( :self) )
          q = compiler.process( Typed::Tree::NameExpression.new( :self) )
          const = compiler.process( Typed::Tree::IntegerExpression.new(1) )
          # int tmp = self >> 1
          compiler.add_code Register.op( s , ">>" , tmp , const)
          # int q = self >> 2
          compiler.add_code Register.load_constant( s , 2 , const)
          compiler.add_code Register.op( s , ">>" , q , const)
          # q = q + tmp
          compiler.add_code Register.op( s , "+" , q , tmp )
          # tmp = q >> 4
          compiler.add_code Register.load_constant( s , 4 , const)
          compiler.add_code Register.transfer( s, q , tmp)
          compiler.add_code Register.op( s , ">>" , tmp , const)
          # q = q + tmp
          compiler.add_code Register.op( s , "+" , q , tmp )
          # tmp = q >> 8
          compiler.add_code Register.load_constant( s , 8 , const)
          compiler.add_code Register.transfer( s, q , tmp)
          compiler.add_code Register.op( s , ">>" , tmp , const)
          # q = q + tmp
          compiler.add_code Register.op( s , "+" , q , tmp )
          # tmp = q >> 16
          compiler.add_code Register.load_constant( s , 16 , const)
          compiler.add_code Register.transfer( s, q , tmp)
          compiler.add_code Register.op( s , ">>" , tmp , const)
          # q = q + tmp
          compiler.add_code Register.op( s , "+" , q , tmp )
          # q = q >> 3
          compiler.add_code Register.load_constant( s , 3 , const)
          compiler.add_code Register.op( s , ">>" , q , const)
          # tmp = q * 10
          compiler.add_code Register.load_constant( s , 10 , const)
          compiler.add_code Register.transfer( s, q , tmp)
          compiler.add_code Register.op( s , "*" , tmp , const)
          # tmp = self - tmp
          compiler.add_code Register.op( s , "-" , me , tmp )
          compiler.add_code Register.transfer( s , me , tmp)
          # tmp = tmp + 6
          compiler.add_code Register.load_constant( s , 6 , const)
          compiler.add_code Register.op( s , "+" , tmp , const )
          # tmp = tmp >> 4
          compiler.add_code Register.load_constant( s , 4 , const)
          compiler.add_code Register.op( s , ">>" , tmp , const )
          # return q + tmp
          compiler.add_code Register.op( s , "+" , q , tmp )
          compiler.add_code Register.reg_to_slot( s , q , :message , :return_value)
          return compiler.method
        end
      end
      extend ClassMethods
    end
  end
end
