module Bosl
  module Compiler
#    function attr_reader  :name, :params, :body , :receiver
    def self.compile_function  expression, method
      return_type , name , parameters, kids = *expression
      name =  name.to_a.first
      args = parameters.to_a.collect do |p|
        raise "error, argument must be a identifier, not #{p}" unless p.type == :field
        p[2]
      end

      if expression[:receiver]
        # compiler will always return slot. with known value or not
        r = Compiler.compile(expression.receiver, method )
        if( r.value.is_a? Parfait::Class )
          class_name = r.value.name
        else
          raise "unimplemented case in function #{r}"
        end
      else
        r = Virtual::Self.new()
        class_name = method.for_class.name
      end
      new_method = Virtual::MethodSource.create_method(class_name, name , args )
      new_method.source.receiver = r
      new_method.for_class.add_instance_method new_method

      #frame = frame.new_frame
      kids.to_a.each do |ex|
        return_type = Compiler.compile(ex,new_method  )
        raise return_type.inspect if return_type.is_a? Virtual::Instruction
      end
      new_method.source.return_type = return_type
      Virtual::Return.new(return_type)
    end
  end
end
