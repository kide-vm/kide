module Phisol
  Compiler.class_eval do

    def on_field_def expression
      #puts expression.inspect
      type , name , value = *expression

      index = @method.ensure_local( name , type )

      if value
        value = process( value  )
      end

      Virtual::Return.new( type , value )
    end
  end
end
