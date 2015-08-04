module Virtual
  module Compiler
#    function attr_reader  :name, :params, :body , :receiver
    def self.compile_function  expression, method
      args = expression.params.collect do |p|
        raise "error, argument must be a identifier, not #{p}" unless p.is_a? Ast::NameExpression
        p.name
      end
      if expression.receiver
        # compiler will always return slot. with known value or not
        r = Compiler.compile(expression.receiver, method )
        if( r.value.is_a? Parfait::Class )
          class_name = r.value.name
        else
          raise "unimplemented case in function #{r}"
        end
      else
        r = Self.new()
        class_name = method.for_class.name
      end
      new_method = MethodSource.create_method(class_name, expression.name , args )
      new_method.source.receiver = r
      new_method.for_class.add_instance_method new_method

      #frame = frame.new_frame
      return_type = nil
      expression.body.each do |ex|
        return_type = Compiler.compile(ex,new_method  )
        raise return_type.inspect if return_type.is_a? Instruction
      end
      new_method.source.return_type = return_type
      Return.new(return_type)
    end
  end
end
