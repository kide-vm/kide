module Phisol
  Compiler.class_eval do

    def on_field_def statement
      #puts statement.inspect
      type , name , value = *statement

      index = @method.ensure_local( name , type )

      if value
        value = process( value  )
      end

      Virtual::Return.new( type , value )
    end
  end
end
