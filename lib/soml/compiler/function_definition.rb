module Soml
  Compiler.class_eval do

    def on_FunctionStatement  statement
      #puts statement.inspect
#      return_type , name , parameters, kids , receiver = *statement
      name =  statement.name
      raise "Already in method #{@method}" if @method

      args = statement.parameters.collect do |p|
        Parfait::Variable.new( *p )
      end

      class_method = nil
      if(statement.receiver )
        if( statement.receiver.first == :self)  #class method
          class_method = @clazz
          @clazz = @clazz.meta
        else
          raise "Not covered #{statement.receiver}"
        end
      end

      @method = @clazz.get_instance_method( name )
      if(@method)
        #puts "Warning, redefining method #{name}" unless name == :main
        #TODO check args / type compatibility
        init_method
      else
        create_method_for(@clazz, name , args ).init_method
      end
      @method.source = statement
      #puts "compile method #{@method.name}"

      process(statement.statements)

      @clazz = class_method if class_method
      @method = nil
      # function definition is a statement, does not return any value
      return nil
    end
  end
end
