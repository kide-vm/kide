module Vool
  class Compiler < AST::Processor

    def self.compile(input)
      ast = Parser::Ruby22.parse( input )
      self.new.process(ast)
    end

    # default to error, so non implemented stuff shows early
    def handler_missing(node)
      raise "Not implemented #{node.type} #{node}"
    end

    def on_class( statement )
      name , sup , body = *statement
      ClassStatement.new( get_name(name) , get_name(sup) , process_all(body) )
    end

    def on_def( statement )
      name , args , body = *statement
      arg_array = process_all( args )
      MethodStatement.new( name , arg_array , body )
    end

    def on_arg( arg )
      arg.first
    end

    #basic Values
    def on_self exp
      SelfStatement.new
    end

    def on_nil expression
      NilStatement.new
    end

    def on_int expression
      IntegerStatement.new(expression.children.first)
    end

    def on_float expression
      FloatStatement.new(expression.children.first)
    end

    def on_true expression
      TrueStatement.new
    end

    def on_false expression
      FalseStatement.new
    end

    def on_str expression
      StringStatement.new(expression.children.first)
    end
    alias  :on_string :on_str

    def on_dstr expression
      raise "Not implemented dynamic strings (with interpolation)"
    end
    alias  :on_xstr :on_dstr

    def on_sym expression
      SymbolStatement.new(expression.children.first)
    end
    alias  :on_string :on_str

    def on_dsym
      raise "Not implemented dynamix symbols (with interpolation)"
    end
    def on_kwbegin expression
      ScopeStatement.new process_all( expression.children )
    end

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
    def on_lvasgn expression
      puts "EXP #{expression}"
      name = expression.children[0]
      value = process(expression.children[1])
      LocalAssignment.new(name,value)
    end

    def on_return statement
      w = ReturnStatement.new()
      w.return_value = process(statement.children.first)
      w
    end

    def on_function  statement
      return_type , name , parameters, statements , receiver = *statement
      w = FunctionStatement.new()
      w.return_type = return_type
      w.name = name.children.first
      w.parameters = parameters.to_a.collect do |p|
        raise "error, argument must be a identifier, not #{p}" unless p.type == :parameter
        p.children
      end
      w.statements = process(statements)
      w.receiver = receiver
      w
    end

    def on_while_statement statement
      branch_type , condition , statements = *statement
      w = WhileStatement.new()
      w.branch_type = branch_type
      w.condition = process(condition)
      w.statements = process(statements)
      w
    end

    def on_if_statement statement
      branch_type , condition , if_true , if_false = *statement
      w = IfStatement.new()
      w.branch_type = branch_type
      w.condition = process(condition)
      w.if_true = process(if_true)
      w.if_false = process(if_false)
      w
    end

    def on_operator_value statement
      operator , left_e , right_e = *statement
      w = OperatorStatement.new()
      w.operator = operator
      w.left_expression = process(left_e)
      w.right_expression = process(right_e)
      w
    end

    def on_receiver expression
      process expression.children.first
    end

    def on_send statement
      puts "SEND #{statement}"
      kids = statement.children.dup
      receiver = kids.shift
      name = kids.shift
      arguments = kids
      w = SendStatement.new()
      w.receiver = process(receiver) || SelfStatement.new
      w.name = name
      w.arguments = process_all(arguments)
      w
    end

    def on_name statement
      NameStatement.new(statement.children.first)
    end

    def on_class_name expression
      ClassStatement.new(expression.children.first)
    end

    def on_assignment statement
      name , value = *statement
      w = Assignment.new()
      w.name = process name
      w.value = process(value)
      w
    end

    private

    def get_name( statement )
      return nil unless statement
      raise "Not const #{statement}" unless statement.type == :const
      name = statement.children[1]
      raise "Not symbol #{name}" unless name.is_a? Symbol
      name
    end

  end
end
