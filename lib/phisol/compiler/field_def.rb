module Phisol
  Compiler.class_eval do
    include AST::Sexp

    def on_field_def statement
      reset_regs # field_def is a statement, no return and all regs
      #puts statement.inspect
      type , name , value = *statement
      @method.ensure_local( name, type ) unless( @method.has_arg(name))
      # if there is a value assigned, process it as am assignemnt statement (kind of call on_assign)
      process( s(:assignment , s(:name , name) , value )  ) if value
      return nil
    end
  end
end
