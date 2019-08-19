module Ruby
  class ProcessError < Exception
    attr_reader :node

    def initialize(msg , node)
      super(msg)
      @node = node
    end
    def message
      super + node_tos
    end
    def node_tos
      return "" unless @node
      @node.to_s[0 ... 200]
    end
  end

  # This RubyCompiler compiles incoming ruby (string) into a typed
  # version of the ast, with the help of the parser gem.
  # The parser outputs an abstract ast (nodes)
  # that get transformed into concrete, specific classes.
  #
  # As a second step, it extracts classes, methods, ivars and locals.
  #
  # The next step is then to go to the vool level, which is
  # simpler, and then finally to compile
  # to the next level down, MOM (Minimal Object Machine)
  class RubyCompiler < AST::Processor
    include AST::Sexp

    def self.compile(input)
      begin
        ast = Parser::CurrentRuby.parse( input )
      rescue => e
        puts "Error parsing #{input}"
      end
      begin
        self.new.process(ast)
      rescue => e
        puts "Error processing #{ast}"
        raise e
      end
    end

    # raise a ProcessError. This means ruby-x doesn't know how to handle it.
    # Parser itself throws SyntaxError
    def not_implemented(node)
      raise ProcessError.new("Not implemented #{node.type}", node)
    end

    # default to error, so non implemented stuff shows early
    def handler_missing(node)
      not_implemented(node)
    end

    def on_class( statement )
      name , sup , body = *statement
      ClassStatement.new( get_name(name) , get_name(sup) , process(body) )
    end

    def on_def( statement )
      name , args , body = *statement
      arg_array = process_all( args )
      MethodStatement.new( name , arg_array , process(body) )
    end

    def on_defs( statement )
      me , name , args , body = *statement
      raise "only class method implemented, not #{me.type}" unless me.type == :self
      arg_array = process_all( args )
      ClassMethodStatement.new( name , arg_array , process(body) )
    end

    def on_arg( arg )
      arg.first
    end

    def on_block(block_node)
      sendd = process(block_node.children[0])
      args = process(block_node.children[1])
      body = process(block_node.children[2])
      RubyBlockStatement.new(sendd , args , body)
    end

    def on_yield(node)
      args = process_all(node.children)
      YieldStatement.new(args)
    end

    def on_args(args)
      args.children.collect{|a| process(a)}
    end

    #basic Values
    def on_self exp
      SelfExpression.new
    end

    def on_nil expression
      NilConstant.new
    end

    def on_int expression
      IntegerConstant.new(expression.children.first)
    end

    def on_float expression
      FloatConstant.new(expression.children.first)
    end

    def on_true expression
      TrueConstant.new
    end

    def on_false expression
      FalseConstant.new
    end

    def on_str expression
      StringConstant.new(expression.children.first)
    end
    alias  :on_string :on_str

    def on_dstr( expression )
      not_implemented(expression)
    end
    alias  :on_xstr :on_dstr

    def on_sym expression
      SymbolConstant.new(expression.children.first)
    end
    alias  :on_string :on_str

    def on_dsym(expression)
      not_implemented(expression)
    end
    def on_kwbegin statement
      ScopeStatement.new process_all( statement.children )
    end
    alias  :on_begin :on_kwbegin

    # Array + Hashes
    def on_array expression
      ArrayStatement.new expression.children.collect{ |elem| process(elem) }
    end

    def on_hash expression
      hash = HashStatement.new
      expression.children.each do |elem|
        raise "Hash error, hash contains non pair: #{elem.type}" if elem.type != :pair
        hash.add( process(elem.children[0]) , process(elem.children[1]) )
      end
      hash
    end

    #Variables
    def on_lvar expression
      LocalVariable.new(expression.children.first)
    end

    def on_ivar expression
      InstanceVariable.new(instance_name(expression.children.first))
    end

    def on_cvar expression
      ClassVariable.new(expression.children.first.to_s[2 .. -1].to_sym)
    end

    def on_const expression
      scope = expression.children.first
      if scope
        not_implemented(expression) unless scope.type == :cbase
      end
      ModuleName.new(expression.children[1])
    end

    # Assignements
    def on_lvasgn expression
      name = expression.children[0]
      value = process(expression.children[1])
      LocalAssignment.new(name,value)
    end

    def on_ivasgn expression
      name = expression.children[0]
      value = process(expression.children[1])
      IvarAssignment.new(instance_name(name),value)
    end

    def on_op_asgn(expression)
      ass , op , exp = *expression
      name = ass.children[0]
      a_type = ass.type.to_s[0,3]
      rewrite = s( a_type + "sgn" ,
                  name ,
                  s(:send , s( a_type + "r" , name ) , op , exp ) )
      process(rewrite)
    end

    def on_return statement
      return_value = process(statement.children.first)
      ReturnStatement.new( return_value )
    end

    def on_while statement
      condition , statements = *statement
      WhileStatement.new( process(condition) , process(statements))
    end

    def on_if statement
      condition , if_true , if_false = *statement
      if_true = process(if_true)
      if_false = process(if_false)
      IfStatement.new( process(condition) , if_true , if_false )
    end

    def on_send( statement )
      kids = statement.children.dup
      receiver = process(kids.shift) || SelfExpression.new
      name = kids.shift
      arguments = process_all(kids)
      SendStatement.new( name , receiver , arguments )
    end

    def on_and expression
      name = expression.type
      left = process(expression.children[0])
      right = process( expression.children[1] )
      LogicalStatement.new( name , left , right)
    end
    alias :on_or :on_and

    # this is a call to super without args (z = zero arity)
    def on_zsuper exp
      SendStatement.new( nil , SuperExpression.new , nil)
    end

    # this is a call to super with args and
    # same name as current method, which is set later
    def on_super( statement )
      arguments = process_all(statement.children)
      SendStatement.new( nil , SuperExpression.new , arguments)
    end

    def on_assignment statement
      name , value = *statement
      w = Assignment.new()
      w.name = process name
      w.value = process(value)
      w
    end

    def handler_missing(node)
      not_implemented(node)
    end

    private

    def instance_name sym
      sym.to_s[1 .. -1].to_sym
    end

    def get_name( statement )
      return nil unless statement
      raise "Not const #{statement}" unless statement.type == :const
      name = statement.children[1]
      raise "Not symbol #{name}" unless name.is_a? Symbol
      name
    end

  end
end
