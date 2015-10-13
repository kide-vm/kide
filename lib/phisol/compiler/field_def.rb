module Phisol
  Compiler.class_eval do

    def on_field_def statement
      #puts statement.inspect
      type , name , value = *statement

      index = @method.ensure_local( name , type )

      if value
        value = process( value  )
      end
      # field_def is a statement, no return 
      return nil
    end
  end
end
