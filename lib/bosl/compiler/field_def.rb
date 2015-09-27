module Bosl
  Compiler.class_eval do

    def on_field_def expression
#      puts expression.inspect
      type , name , value = *expression
      name = name
      index = method.ensure_local( name )

      if value
        value = process( value  )
      end

      Virtual::Return.new( value )
    end
  end
end
