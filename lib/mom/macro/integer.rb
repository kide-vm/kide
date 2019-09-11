require_relative "div4"
require_relative "div10"
require_relative "operator"
require_relative "comparison"

module Mom
  module Builtin
    # integer related kernel functions
    # all these functions (return the function they implement) assume interger input
    # Also the returned integer object has to be passed in to avoid having to allocate it.
    #
    # This means the methods will have to be renamed at some point and wrapped
    module Integer
      module ClassMethods
        include CompileHelper

        # div by 4, ie shift right by 2
        # Mostly created for testing at this point, as it is short
        # return new int with result
        def div4(context)
          compiler = compiler_for(:Integer,:div4 ,{})
          compiler.add_code Div4.new("div4")
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
          compiler = compiler_for(:Integer, operator ,{other: :Integer })
          compiler.add_code Comparison.new("comparison" , operator)
          return compiler
        end

        # implemented all known binary operators that map straight to machine codes
        # this function (similar to comparison):
        # - unpacks the intergers to fixnum
        # - applies the operator (at a risc level)
        # - gets a new integer and stores the result
        # - returns the new int
        def operator_method( op_sym )
          compiler = compiler_for(:Integer, op_sym ,{other: :Integer })
          compiler.add_code Operator.new( "op:#{op_sym}" , op_sym)
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
          compiler = compiler_for(:Integer,:div10 ,{})
          compiler.add_code Div10.new("div10")
          return compiler
        end
      end
      extend ClassMethods
    end
  end
end
