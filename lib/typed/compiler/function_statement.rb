module Typed
  module FunctionStatement

    def on_FunctionStatement  statement
      #      return_type , name , parameters, kids , receiver = *statement
      raise "Already in method #{@method}" if @method

      args = statement.parameters

      class_method = handle_receiver( statement ) #nil for instance method

      @method = @type.get_instance_method( statement.name )
      if(@method)
        #puts "Warning, redefining method #{name}" unless name == :main
        #TODO check args / type compatibility
        init_method
      else
        create_method_for(@type, statement.name , args ).init_method
      end
      @method.source = statement

      process(statement.statements)

      @type = class_method if class_method
      @method = nil
      # function definition is a statement, does not return any value
      return nil
    end

    private

    def handle_receiver( statement )
      return nil unless statement.receiver
      raise "Not covered #{statement.receiver}" unless ( statement.receiver.first == :self)
      class_method = @type
      @type = @type.object_class.meta.get_type
      class_method
    end
  end
end
