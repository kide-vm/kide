module Builtin
  module Kernel
    module ClassMethods
      # main entry point, ie __init__ calls this
      # defined here as empty, to be redefined
      def main context
        function = Virtual::CompiledMethod.new(:main , [] , Virtual::Integer)
        return function
      end
      # this is the really really first place the machine starts.
      # it isn't really a function, ie it is jumped to (not called), exits and may not return
      # so it is responsible for initial setup (and relocation)
      def __init__ context
        function = Virtual::CompiledMethod.new(:__init__ , [] , Virtual::Integer)
        clazz = Virtual::BootSpace.space.get_or_create_class :Kernel
        method = clazz.resolve_method :main
        me = Virtual::Self.new(Virtual::Reference)
        code = Virtual::Set.new(Virtual::NewSelf.new(me.type), me)
        function.add_code(code)
        function.add_code Virtual::FunctionCall.new(method)
        return function
      end
      def putstring context 
        function = Virtual::CompiledMethod.new(:putstring , [] )
        return function
        ret = Virtual::RegisterMachine.instance.write_stdout(function)
        function.set_return ret
        function
      end
      def exit context
        function = Virtual::CompiledMethod.new(:exit , [] , Virtual::Integer)
        return function
        ret = Virtual::RegisterMachine.instance.exit(function)
        function.set_return ret
        function
      end
    end
    extend ClassMethods
  end
end
