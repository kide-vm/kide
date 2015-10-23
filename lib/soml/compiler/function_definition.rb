module Soml
  Compiler.class_eval do

    def on_function  statement
      #puts statement.inspect
      return_type , name , parameters, kids , receiver = *statement
      name =  name.to_a.first
      args = parameters.to_a.collect do |p|
        raise "error, argument must be a identifier, not #{p}" unless p.type == :parameter
        Parfait::Variable.new( *p)
      end

      if receiver
        # compiler will always return slot. with known value or not
        r = receiver.first
        if( r.is_a? Parfait::Class )
          class_name = r.value.name
        else
          if( r != :self)
            raise "unimplemented case in function #{r}"
          else
            r = Register::Self.new()
            class_name = method.for_class.name
          end
        end
      else
        r = @clazz
        class_name = @clazz.name
      end
      raise "Already in method #{@method}" if @method
      @method = @clazz.get_instance_method( name )
      if(@method)
        #puts "Warning, redefining method #{name}" unless name == :main
        #TODO check args / type compatibility
        @method.source.init @method
      else
        @method = Register::MethodSource.create_method(class_name, return_type, name , args )
        @method.for_class.add_instance_method @method
      end
      @method.source.receiver = r
      #puts "compile method #{@method.name}"

      kids.to_a.each do |ex|
        ret = process(ex)
      end
      @method = nil
      # function definition is a statement, does not return any value
      return nil
    end
  end
end
