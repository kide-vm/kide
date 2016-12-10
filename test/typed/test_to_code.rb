require_relative "helper"

class ToCodeTest < MiniTest::Test
  include AST::Sexp

  def check clazz
    tree = Typed.ast_to_code @statement
    assert_equal tree.class , Typed::Tree.const_get( clazz )
  end

  def test_field_access
    @statement = s(:field_access, s(:receiver, s(:name, :m)), s(:field, s(:name, :index)))
    check "FieldAccess"
  end
  def test_field_def_value
    @statement = s(:field_def, :Integer, s(:name, :abba), s(:int, 5))
    check "FieldDef"
  end
  def test_class_field
    @statement = s(:class_field, :Integer, :fff, s(:int, 3))
    check "ClassField"
  end
  def test_simple_while
    @statement = s(:while_statement, :false, s(:conditional,s(:int, 1)), s(:statements))
    check "WhileStatement"
  end
  def test_assignment
    @statement = s(:assignment, s(:name, :i), s(:int, 0))
    check "Assignment"
  end
  def test_nil
    @statement = s(:nil)
    check "NilExpression"
  end
  def test_true
    @statement = s(:true)
    check "TrueExpression"
  end
  def test_false
    @statement = s(:false)
    check "FalseExpression"
  end
  def test_name
    @statement = s(:name,  :foo)
    check "NameExpression"
  end
  def test_class_name
    @statement =s(:class_name, :FooBar)
    check "ClassExpression"
  end
end
