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

          while_start = Risc.label( source , source + "while_start_#{object_id}")
          exit_label = Risc.label( source , source + "exit_label_#{object_id}")
          false_label = Risc.label( source , source + "fal_label_#{object_id}")

          compiler.build do
            word << message[ :receiver ]

            type << message[:arguments]
            type << type[2]
            type << type[:type]
            typed_method << type[:methods]
            add while_start
            space << Parfait.object_space
            space << space[:nil_object]

            add Risc.op(source + "if method is nil", :- , space , typed_method )
            add Risc::IsZero.new(source + "jump if nil" , exit_label)

            name << typed_method[:name]
            add Risc.op(source + " compare name with me", :- , name , word )
            add Risc::IsNotZero.new(source + "jump if not same" , false_label)

            typed_method << typed_method[:binary]
            message[:return_value] << typed_method

            add Mom::ReturnSequence.new.to_risc(compiler)

            add false_label
            typed_method << typed_method[:next_method]
            add Risc::Branch.new(source + "back to while", while_start)

            add exit_label
          end
          Risc::Builtin::Object.emit_syscall( compiler , :exit )
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end
