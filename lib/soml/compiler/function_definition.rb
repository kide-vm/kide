module Soml
  Compiler.class_eval do

    def on_function  statement
      #puts statement.inspect
      return_type , name , parameters, kids , receiver = *statement
      name =  name.to_a.first
      raise "Already in method #{@method}" if @method

      args = parameters.to_a.collect do |p|
        raise "error, argument must be a identifier, not #{p}" unless p.type == :parameter
        Parfait::Variable.new( *p)
      end

      class_method = nil
      if(receiver )
        if( receiver.first == :self)  #class method
          class_method = @clazz
          @clazz = @clazz.meta
        else
          raise "Not covered #{receiver}"
        end
      end
      r = @clazz
      class_name = @clazz.name

      @method = @clazz.get_instance_method( name )
      if(@method)
        #puts "Warning, redefining method #{name}" unless name == :main
        #TODO check args / type compatibility
        init_method
      else
        create_method_for(@clazz, name , args ).init_method
        @clazz.add_instance_method @method
      end
      @method.source = statement
      #puts "compile method #{@method.name}"

      kids.to_a.each do |ex|
        process(ex)
      end
      @clazz = class_method if class_method
      @method = nil
      # function definition is a statement, does not return any value
      return nil
    end
  end
end
