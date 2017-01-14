module Vm

  def self.ast_to_code statement
    compiler = ToCode.new
    compiler.process statement
  end

  class ToCode < AST::Processor

    def handler_missing node
      raise "No handler  on_#{node.type}(node)"
    end

    def on_parameters statement
      params = {}
      statement.children.each do |param , type , name|
        type , name = *param
        params[name] = type
      end
      params
    end

    def on_while_statement statement
      branch_type , condition , statements = *statement
      w = Tree::WhileStatement.new()
      w.branch_type = branch_type
      w.condition = process(condition)
      w.statements = process(statements)
      w
    end

    def on_if_statement statement
      branch_type , condition , if_true , if_false = *statement
      w = Tree::IfStatement.new()
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
      w = Tree::ReturnStatement.new()
      w.return_value = process(statement.children.first)
      w
    end

    def on_operator_value statement
      operator , left_e , right_e = *statement
      w = Tree::OperatorExpression.new()
      w.operator = operator
      w.left_expression = process(left_e)
      w.right_expression = process(right_e)
      w
    end

    def on_field_access statement
      receiver_ast , field_ast = *statement
      w = Tree::FieldAccess.new()
      w.receiver = process(receiver_ast)
      w.field = process(field_ast)
      w
    end

    def on_receiver expression
      process expression.children.first
    end

    def on_call statement
      name_s , arguments , receiver = *statement
      w = Tree::CallSite.new()
      w.name = name_s.children.first
      w.arguments = process_all(arguments)
      w.receiver = process(receiver)
      w
    end

    def on_int expression
      Tree::IntegerExpression.new(expression.children.first)
    end

    def on_true _expression
      Tree::TrueExpression.new
    end

    def on_false _expression
      Tree::FalseExpression.new
    end

    def on_nil _expression
      Tree::NilExpression.new
    end

    def on_name statement
      Tree::NameExpression.new(statement.children.first)
    end
    def on_string expression
      Tree::StringExpression.new(expression.children.first)
    end

    def on_class_name expression
      Tree::ClassExpression.new(expression.children.first)
    end

    def on_assignment statement
      name , value = *statement
      w = Vm::Tree::Assignment.new()
      w.name = process name
      w.value = process(value)
      w
    end

  end
end
