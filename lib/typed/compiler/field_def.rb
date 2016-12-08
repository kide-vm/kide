module Typed
  Compiler.class_eval do
    include AST::Sexp

    def on_FieldDef statement
      reset_regs # field_def is a statement, no return and all regs
      #puts statement.inspect
#      type , name , value = *statement
      name_s = no_space( statement.name.value )
      @method.ensure_local( name_s, statement.type ) unless( @method.has_arg(name_s))
      # if there is a value assigned, process it as am assignemnt statement (kind of call on_assign)
      process( Typed::Assignment.new(statement.name , statement.value )  ) if statement.value
      return nil
    end
  end
end
