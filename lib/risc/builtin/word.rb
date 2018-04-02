module Risc
  module Builtin
    module Word
      module ClassMethods
        include CompileHelper

        def putstring( context)
          compiler = compiler_for(:Word , :putstring ,{})
          compiler.add_slot_to_reg( "putstring" , :message , :receiver , :new_message )
          index = Parfait::Word.get_length_index
          reg = RiscValue.new(:r2 , :Integer)
          compiler.add_slot_to_reg( "putstring" , :new_message , index , reg )
          Risc::Builtin::Object.emit_syscall( compiler , :putstring )
          compiler.add_mom( Mom::ReturnSequence.new)
          compiler.method
        end

        # self[index] basically. Index is the first arg > 0
        # return (and word sized int) is stored in return_value
        def get_internal_byte( context)
          compiler = compiler_for(:Word , :get_internal_byte , {at: :Integer})
          source = "get_internal_byte"
          me , index = compiler.self_and_int_arg(source)
          compiler.reduce_int( source + " fix arg", index )
          # reduce me to me[index]
          compiler.add_byte_to_reg( source , me , index , me)
          compiler.add_new_int(source, me , index)
          # and put it back into the return value
          compiler.add_reg_to_slot( source , index , :message , :return_value)
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end

        # self[index] = val basically. Index is the first arg ( >0),
        # value the second
        # return self
        def set_internal_byte( context )
          compiler = compiler_for(:Word, :set_internal_byte , {at: :Integer , :value => :Integer} )
          source = "set_internal_byte"
          me , index = compiler.self_and_int_arg(source)
          value = compiler.load_int_arg_at(source , 2 )
          compiler.reduce_int( source + " fix me", value )
          compiler.reduce_int( source + " fix arg", index )
          compiler.add_reg_to_byte( source , value , me , index)
          compiler.add_reg_to_slot( source , me , :message , :return_value)
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end

        # resolve the method name of self, on the given object
        # may seem wrong way around at first sight, but we know the type of string. And
        # thus resolving this method happens at compile time, whereas any method on an
        # unknown self (the object given) needs resolving and that is just what we are doing
        #  ( ie the snake bites it's tail)
        # This method is just a placeholder until boot is over and the real method is
        # parsed.
        def resolve_method( context)
          compiler = compiler_for(:Word, :resolve_method , {:value => :Type} )
          source = "resolve_method "
          me = compiler.add_known( :receiver )
          type_arg = compiler.use_reg( :Type )
          method = compiler.use_reg( :TypedMethod )
          method_name = compiler.use_reg( :Word )
          space = compiler.use_reg( :Space )
          methods_index = Risc.resolve_to_index(:type , :methods)
          next_index = Risc.resolve_to_index(:typed_method , :next_method)
          name_index = Risc.resolve_to_index(:typed_method , :name)
          binary_index = Risc.resolve_to_index(:typed_method , :binary)
          nil_index = Risc.resolve_to_index(:space , :nil_object)
          while_start = Risc.label( source , source + "while_start_#{object_id}")
          exit_label = Risc.label( source , source + "exit_label_#{object_id}")
          false_label = Risc.label( source , source + "fal_label_#{object_id}")

          compiler.add_slot_to_reg(source + "retrieve args" , :message , :arguments , type_arg )
          compiler.add_slot_to_reg(source + "retrieve arg 1", type_arg , 1 + 1, type_arg ) #1 for type
          compiler.add_slot_to_reg(source + "get methods from type", type_arg , methods_index, method )
          compiler.add_code while_start
          compiler.add_load_constant(source + "load space" , Parfait.object_space , space )
          compiler.add_slot_to_reg(source + "get nil object", space , nil_index, space )
          compiler.add_op(source + "if method is nil", :- , space , method )
          compiler.add_code Risc::IsZero.new(source + "jump if nil" , exit_label)

          compiler.add_slot_to_reg(source + "get name from method" , method , name_index, method_name )
          compiler.add_op(source + " compare name with me", :- , method_name , me )
          compiler.add_code Risc::IsNotZero.new(source + "jump if not same" , false_label)

          compiler.add_slot_to_reg(source + "get binary from method" , method , binary_index, method )
          compiler.add_reg_to_slot(source +  "save binary to return", method , :message , :return_value)
          compiler.add_mom( Mom::ReturnSequence.new)

          compiler.add_code false_label
          compiler.add_slot_to_reg(source + "get next method" , method , next_index, method )
          compiler.add_code Risc::Branch.new(source + "back to while", while_start)

          compiler.add_code exit_label
          Risc::Builtin::Object.emit_syscall( compiler , :exit )
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end
