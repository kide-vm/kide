module Soml
  Compiler.class_eval do
    include AST::Sexp

    def on_field_def statement
      reset_regs # field_def is a statement, no return and all regs
      #puts statement.inspect
      type , name , value = *statement
      name_s = no_space( name.first )
      @method.ensure_local( name_s, type ) unless( @method.has_arg(name_s))
      # if there is a value assigned, process it as am assignemnt statement (kind of call on_assign)
      process( s(:assignment , name , value )  ) if value
      return nil
    end
  end
end
