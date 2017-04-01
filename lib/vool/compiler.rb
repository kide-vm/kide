module Vool
  class Compiler < ::Rubyx::Passes::TotalProcessor

    def self.compile(input)
      ast = Parser::Ruby22.parse( input )
      self.new.process(ast)
    end

    def on_class( statement )
      name , sup , body = *statement
      ClassStatement.new( get_name(name) , get_name(sup) , body )
    end

    def on_def( statement )
      name , args , body = *statement
      arg_array = process_all( args )
      MethodStatement.new( name , arg_array , body )
    end

    def on_arg( arg )
      arg.first
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

    def on_field_def statement
      type , name , value = *statement
      w = FieldDef.new()
      w.type = type
      w.name = process(name)
      w.value = process(value) if value
      w
    end

    def on_class_field statement
      type , name = *statement
      w = ClassField.new()
      w.type = type
      w.name = name
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

    def process_first code
      raise "Too many children #{code.inspect}" if code.children.length != 1
      process code.children.first
    end
    alias  :on_conditional :process_first
    alias  :on_condition :process_first
    alias  :on_field :process_first

    def on_statements statement
      w = Statements.new()
      return w unless statement.children
      return w unless statement.children.first
      w.statements = process_all(statement.children)
      w
    end
    alias :on_true_statements :on_statements
    alias :on_false_statements :on_statements

    def on_return statement
      w = ReturnStatement.new()
      w.return_value = process(statement.children.first)
      w
    end

    def on_operator_value statement
      operator , left_e , right_e = *statement
      w = OperatorExpression.new()
      w.operator = operator
      w.left_expression = process(left_e)
      w.right_expression = process(right_e)
      w
    end

    def on_field_access statement
      receiver_ast , field_ast = *statement
      w = FieldAccess.new()
      w.receiver = process(receiver_ast)
      w.field = process(field_ast)
      w
    end

    def on_receiver expression
      process expression.children.first
    end

    def on_call statement
      name_s , arguments , receiver = *statement
      w = CallSite.new()
      w.name = name_s.children.first
      w.arguments = process_all(arguments)
      w.receiver = process(receiver)
      w
    end

    def on_int expression
      IntegerExpression.new(expression.children.first)
    end

    def on_true expression
      TrueExpression.new
    end

    def on_false expression
      FalseExpression.new
    end

    def on_nil expression
      NilExpression.new
    end

    def on_name statement
      NameExpression.new(statement.children.first)
    end
    def on_string expression
      StringExpression.new(expression.children.first)
    end

    def on_class_name expression
      ClassExpression.new(expression.children.first)
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
