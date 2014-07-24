module Ast
  # assignment, like operators are really function calls
  
  class CallSiteExpression < Expression
#    attr_reader  :name, :args , :receiver
    @@counter = 0
    def compile method , frame
      me = receiver.compile( method, frame )
      with = args.collect{|a| a.compile( method,frame)}
      frame.compile_send( method , name , me , with  )
    end

    def scratch
      into = context.function
      params = args.collect{ |a| a.compile(context) }
      puts "compiling receiver #{receiver} (call #{name})"
      if receiver.is_a? ModuleName
        clazz = context.object_space.get_or_create_class receiver.name
        value_receiver = clazz.meta_class
        function = value_receiver.resolve_function name
      elsif receiver.is_a?(StringExpression) or receiver.is_a?(IntegerExpression)
        #TODO obviously the class is wrong, but you gotta start somewhere
        clazz = context.object_space.get_or_create_class :Object
        function = clazz.resolve_function name
        value_receiver = receiver.compile(context)
      elsif receiver.is_a?(NameExpression) 
        if(receiver.name == :self)
          function = context.current_class.resolve_function(name)
          value_receiver = Virtual::Integer.new(Virtual::RegisterMachine.instance.receiver_register)
        else
          value_receiver = receiver.compile(context)
          # TODO HACK warning: should determine class dynamically
          function = context.current_class.resolve_function(name)
        end
      elsif receiver.is_a? VariableExpression
        value_receiver = receiver.compile(context)
        function = context.current_class.resolve_function(name)
      else
        #This , how does one say nowadays, smells. Smells of unused polymorphism actually
        raise "Not sure this is possible, but never good to leave elses open #{receiver} #{receiver.class}"
      end
      raise "No such method error #{inspect}" if (function.nil?)
      raise "No receiver error #{inspect}:#{receiver}" if (value_receiver.nil?)
      call = Virtual::CallSite.new( name ,  value_receiver , params  , function)
      current_function = context.function
      into.push([])  unless current_function.nil?
      call.load_args into
      call.do_call into
      
      after = into.new_block("#{name}#{@@counter+=1}")
      into.insert_at after
      into.pop([]) unless current_function.nil?
      function.return_type
    end
  end
  
end