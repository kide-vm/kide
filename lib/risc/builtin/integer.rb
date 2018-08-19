module Risc
  module Builtin
    # integer related kernel functions
    # all these functions (return the functione they implement) assume interger input
    #
    # This means they will have to be renamed at some point and wrapped
    module Integer
      module ClassMethods
        include CompileHelper

        # div by 4, ie shift two left
        # Mostly created for testing at this point, as it is short
        # return new int with result
        def div4(context)
          compiler = compiler_for(:Integer,:div4 ,{})
          compiler.builder(compiler.source).build do
            integer! << message[:receiver]
            integer.reduce_int
            integer_reg! << 2
            integer.op :>> , integer_reg
            add_new_int("div4", integer , integer_reg)
            message[:return_value] << integer_reg
          end
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end
        # implemented by the comparison
        def >( context )
          comparison( :> )
        end
        # implemented by the comparison
        def <( context )
          comparison( :< )
        end
        # implemented by the comparison
        def <=( context )
          comparison( :<= )
        end
        # implemented by the comparison
        def >=( context )
          comparison( :>= )
        end

        # all (four) comparison operation are quite similar and implemented here
        # - reduce the ints (assume int as input)
        # - subtract the fixnums
        # - check for minus ( < and > )
        # - also check for zero (<= and >=)
        # - load true or false object into return, depending on check
        # - return
        def comparison( operator  )
          compiler = compiler_for(:Integer, operator ,{other: :Integer})
          builder = compiler.builder(compiler.source)
          builder.build do
            integer! << message[:receiver]
            integer_reg! << message[:arguments]
            integer_reg << integer_reg[ 1]
            integer.reduce_int
            integer_reg.reduce_int
            swap_names(:integer , :integer_reg) if(operator.to_s.start_with?('<') )
            integer.op :- , integer_reg
            if_minus false_label
            if_zero( false_label ) if operator.to_s.length == 1
            object! << Parfait.object_space.true_object
            branch merge_label
            add_code false_label
            object << Parfait.object_space.false_object
            add_code merge_label
            message[:return_value] << object
          end
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end

        # not implemented, would need a itos and that needs "new" (wip)
        def putint(context)
          compiler = compiler_for(:Integer,:putint ,{})
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end

        # implemented all known binary operators that map straight to machine codes
        # this function (similar to comparison):
        # - unpacks the intergers to fixnum
        # - applies the operator (at a risc level)
        # - gets a new integer and stores the result
        # - returns the new int
        def operator_method( op_sym )
          compiler = compiler_for(:Integer, op_sym ,{other: :Integer})
          builder = compiler.builder(compiler.source)
          builder.build do
            integer! << message[:receiver]
            integer_reg! << message[:arguments]
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

        # as the name suggests, this devides the integer (self) by ten
        #
        # This version is lifted from some arm assembler tricks and is _much_
        # faster than the general div versions. I think it was about three
        # times less instructions. Useful for itos
        #
        # In fact it is possible to generate specific div function for any given
        # integer and some are even more faster (as eg div4).
        def div10( context )
          s = "div_10 "
          compiler = compiler_for(:Integer,:div10 ,{})
          builder = compiler.builder(compiler.source)
          builder.build do
            integer_self! << message[:receiver]
            integer_self.reduce_int
            integer_tmp! << integer_self
            integer_reg! << integer_self

            integer_const! << 1
            integer_tmp.op :>> , integer_const

            integer_const << 2
            integer_reg.op :>> , integer_const
            integer_reg.op :+ , integer_tmp

            integer_const << 4
            integer_tmp << integer_reg
            integer_reg.op :>> , integer_tmp

            integer_reg.op :+ , integer_tmp

            integer_const << 8
            integer_tmp << integer_reg
            integer_tmp.op :>> , integer_const

            integer_reg.op :+ , integer_tmp

            integer_const << 16
            integer_tmp << integer_reg
            integer_tmp.op :>> , integer_const

            integer_reg.op :+ , integer_tmp

            integer_const << 3
            integer_reg.op :>> , integer_const

            integer_const << 10
            integer_tmp << integer_reg
            integer_tmp.op :* , integer_const

            integer_self.op :- , integer_tmp
            integer_tmp << integer_self

            integer_const << 6
            integer_tmp.op :+ , integer_const

            integer_const << 4
            integer_tmp.op :>> , integer_const

            integer_reg.op :+ , integer_tmp

            add_new_int(s,integer_reg , integer_tmp)
            message[:return_value] << integer_tmp

          end

          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler
        end
      end
      extend ClassMethods
    end
  end
end
