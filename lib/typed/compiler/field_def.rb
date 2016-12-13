module Typed
  module FieldDef
    include AST::Sexp

    def on_FieldDef statement
      #      type , name , value = *statement

      reset_regs # field_def is a statement, no return and all regs
      name_s = no_space( statement.name.value )
      @method.add_local( name_s, statement.type ) unless( @method.has_arg(name_s))
      # if there is a value assigned, process it as am assignemnt statement (kind of call on_assign)
      process( Tree::Assignment.new(statement.name , statement.value )  ) if statement.value
      return nil
    end
  end
end
