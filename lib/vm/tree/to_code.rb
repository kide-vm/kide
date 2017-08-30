module Vm

  def self.ast_to_code statement
    compiler = ToCode.new
    compiler.process statement
  end

  # ToCode converts an ast (from the ast gem) into the vm code expressions
  # Code is the base class of the tree that is transformed to and
  # Expression and Statement the next two subclasses.
  # While it is an ast, it is NOT a ruby parser generated ast. Instead the ast is generated
  # with s-expressions (also from the ast gem), mostly in tests, but also a little in
  # the generation of functions (Builtin)
  #
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
      whil = Tree::WhileStatement.new()
      whil.branch_type = branch_type
      whil.condition = process(condition)
      whil.statements = process(statements)
      whil
    end

    def on_if_statement statement
      branch_type , condition , if_true , if_false = *statement
      iff = Tree::IfStatement.new()
      iff.branch_type = branch_type
      iff.condition = process(condition)
      iff.if_true = process(if_true)
      iff.if_false = process(if_false)
      iff
    end

    def process_first code
      raise "Too many children #{code.inspect}" if code.children.length != 1
      process code.children.first
    end
    alias  :on_conditional :process_first
    alias  :on_condition :process_first
    alias  :on_field :process_first

    def on_statements( statement )
      list = Statements.new()
      kids = statement.children
      return list unless kids
      return list unless kids.first
      list.statements = process_all(kids)
      list
    end

    alias :on_true_statements :on_statements
    alias :on_false_statements :on_statements

    def on_return statement
      ret = Tree::ReturnStatement.new()
      ret.return_value = process(statement.children.first)
      ret
    end

    def on_operator_value statement
      operator , left_e , right_e = *statement
      op = Tree::OperatorExpression.new()
      op.operator = operator
      op.left_expression = process(left_e)
      op.right_expression = process(right_e)
      op
    end

    def on_field_access statement
      receiver_ast , field_ast = *statement
      field = Tree::FieldAccess.new()
      field.receiver = process(receiver_ast)
      field.field = process(field_ast)
      field
    end

    def on_receiver expression
      process expression.children.first
    end

    def on_call statement
      name , arguments , receiver = *statement
      call = Tree::CallSite.new()
      call.name = name
      call.arguments = process_all(arguments)
      call.receiver = process(receiver)
      call
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

    def on_arg statement
      Tree::ArgumentName.new(statement.children.first)
    end
    def on_local statement
      Tree::LocalName.new(statement.children.first)
    end
    def on_ivar statement
      Tree::InstanceName.new(statement.children.first)
    end
    def on_known statement
      Tree::KnownName.new(statement.children.first)
    end

    def on_string expressions
      Tree::StringExpression.new(expressions.children.first)
    end

    def on_class_name expression
      Tree::ClassExpression.new(expression.children.first)
    end

    def on_i_assignment statement
      assignment_for( statement, Vm::Tree::IvarAssignment)
    end

    def on_a_assignment statement
      assignment_for( statement, Vm::Tree::ArgAssignment)
    end

    def on_l_assignment( statement )
      assignment_for( statement, Vm::Tree::LocalAssignment)
    end

    def assignment_for( statement , clazz)
      name , value = *statement
      p_name = process name
      p_value = process(value)
      clazz.new(p_name , p_value)
    end

  end
end
