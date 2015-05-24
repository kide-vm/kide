module Builtin
  module Kernel
    module ClassMethods
      # main entry point, ie __init__ calls this
      # defined here as empty, to be redefined
      def main context
        function = Virtual::CompiledMethodInfo.create_method("Kernel","main" , [])
        function.info.return_type = Virtual::Integer
        return function
      end
      # this is the really really first place the machine starts.
      # it isn't really a function, ie it is jumped to (not called), exits and may not return
      # so it is responsible for initial setup (and relocation)
      def __init__ context
        function = Virtual::CompiledMethodInfo.create_method("Kernel","__init__" , [])
        function.info.return_type = Virtual::Integer
        clazz = Virtual::Machine.instance.class_mappings["Kernel"]
        method = clazz.resolve_method Virtual::new_word "main"
        me = Virtual::Self.new(Virtual::Reference)
        code = Virtual::Set.new(Virtual::Self.new(me.type), me)
        function.info.add_code(code)
        function.info.add_code Virtual::MethodCall.new(method)
        return function
      end
      def putstring context
        function = Virtual::CompiledMethodInfo.create_method("Kernel" , "putstring" , [] )
        return function
        ret = Virtual::RegisterMachine.instance.write_stdout(function)
        function.set_return ret
        function
      end
      def exit context
        function = Virtual::CompiledMethodInfo.create_method("Kernel","exit" , [])
        function.info.return_type = Virtual::Integer
        return function
        ret = Virtual::RegisterMachine.instance.exit(function)
        function.set_return ret
        function
      end
      def __send context
        function = Virtual::CompiledMethodInfo.create_method("Kernel" ,"__send" , [] )
        function.info.return_type = Virtual::Integer
        return function
      end
    end
    extend ClassMethods
  end
end
