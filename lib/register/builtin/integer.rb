#integer related kernel functions
module Register
  module Builtin
    module Integer
      module ClassMethods
        include AST::Sexp

        # The conversion to base10 is quite a bit more complicated than i thought.
        # The bulk of it is in div10
        # We set up variables, do the devision and write the result to the string
        # then check if were done and recurse if neccessary
        # As we write before we recurse (save a push) we write the number backwards
        # arguments: string address , integer
        # def utoa context
        #   compiler = Soml::Compiler.new.create_method(:Integer ,:utoa ,  [ :Integer ] ).init_method
        #   function.source.receiver = :Integer
        #   return utoa_function
        #   # str_addr = utoa_function.receiver
        #   # number = utoa_function.args.first
        #   # remainder = utoa_function.new_local
        #   # RegisterMachine.instance.div10( utoa_function , number  , remainder )
        #   # # make char out of digit (by using ascii encoding) 48 == "0"
        #   # utoa_function.instance_eval do
        #   #   add(  remainder , remainder , 48)
        #   #   strb( remainder, str_addr )
        #   #   sub(  str_addr,  str_addr ,  1 )
        #   #   cmp(  number ,  0 )
        #   #   callne( utoa_function  )
        #   # end
        #   # return utoa_function
        # end

        def mod context
          compiler = Soml::Compiler.new.create_method(:Integer,:mod , {:Integer => :by} ).init_method
          return compiler.method
        end
        def putint context
          compiler = Soml::Compiler.new.create_method(:Integer,:putint ).init_method
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end
