module Risc
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
        class Div4 < ::Mom::Instruction
          def to_risc(compiler)
            builder = compiler.builder(compiler.source)
            integer_tmp = builder.allocate_int
            builder.build do
              integer_self! << message[:receiver]
              integer_self.reduce_int
              integer_1! << 2
              integer_self.op :>> , integer_1
              integer_tmp[Parfait::Integer.integer_index] << integer_self
              message[:return_value] << integer_tmp
            end
            return compiler
          end
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
        class Comparison < ::Mom::Instruction
          attr_reader :operator
          def initialize(name , operator)
            @operator = operator
          end
          def to_risc(compiler)
            builder = compiler.builder(compiler.source)
            builder.build do
              integer! << message[:receiver]
              integer.reduce_int
              integer_reg! << message[:arguments]
              integer_reg << integer_reg[Parfait::NamedList.type_length + 0] #"other" is at index 0
              integer_reg.reduce_int
              swap_names(:integer , :integer_reg) if(@operator.to_s.start_with?('<') )
              integer.op :- , integer_reg
              if_minus false_label
              if_zero( false_label ) if @operator.to_s.length == 1
              object! << Parfait.object_space.true_object
              branch merge_label
              add_code false_label
              object << Parfait.object_space.false_object
              add_code merge_label
              message[:return_value] << object
            end
            return compiler
          end
        end

        # implemented all known binary operators that map straight to machine codes
        # this function (similar to comparison):
        # - unpacks the intergers to fixnum
        # - applies the operator (at a risc level)
        # - gets a new integer and stores the result
        # - returns the new int
        def operator_method( op_sym )
          compiler = compiler_for(:Integer, op_sym ,{other: :Integer })
          builder = compiler.builder(compiler.source)
          integer_tmp = builder.allocate_int
          builder.build do
            integer! << message[:receiver]
            integer.reduce_int
            integer_reg! << message[:arguments]
            integer_reg << integer_reg[Parfait::NamedList.type_length + 0] #"other" is at index 0
            integer_reg.reduce_int
            integer.op op_sym , integer_reg
            integer_tmp[Parfait::Integer.integer_index] << integer
            message[:return_value] << integer_tmp
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
          compiler = compiler_for(:Integer,:div10 ,{})
          compiler.add_code Div10.new("div10")
          return compiler
        end
        class Div10 < ::Mom::Instruction
          def to_risc(compiler)
            s = "div_10 "
            builder = compiler.builder(compiler.source)
            integer_tmp = builder.allocate_int
            builder.build do
              integer_self! << message[:receiver]
              integer_self.reduce_int
              integer_1! << integer_self
              integer_reg! << integer_self

              integer_const! << 1
              integer_1.op :>> , integer_const

              integer_const << 2
              integer_reg.op :>> , integer_const
              integer_reg.op :+ , integer_1

              integer_const << 4
              integer_1 << integer_reg
              integer_reg.op :>> , integer_1

              integer_reg.op :+ , integer_1

              integer_const << 8
              integer_1 << integer_reg
              integer_1.op :>> , integer_const

              integer_reg.op :+ , integer_1

              integer_const << 16
              integer_1 << integer_reg
              integer_1.op :>> , integer_const

              integer_reg.op :+ , integer_1

              integer_const << 3
              integer_reg.op :>> , integer_const

              integer_const << 10
              integer_1 << integer_reg
              integer_1.op :* , integer_const

              integer_self.op :- , integer_1
              integer_1 << integer_self

              integer_const << 6
              integer_1.op :+ , integer_const

              integer_const << 4
              integer_1.op :>> , integer_const

              integer_reg.op :+ , integer_1

              integer_tmp[Parfait::Integer.integer_index] << integer_reg
              message[:return_value] << integer_tmp

            end
            return compiler
          end
        end
      end
      extend ClassMethods
    end
  end
end
