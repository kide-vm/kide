require 'parslet'
require 'vm/nodes'

module Parser
  class Transform < Parslet::Transform
    rule(:integer => simple(:value)) { Vm::IntegerExpression.new(value.to_i) }
    rule(:name   => simple(:name))  { Vm::NameExpression.new(name.to_s) }

    rule(:arg  => simple(:arg))    { arg  }
    rule(:args => sequence(:args)) { args }

    rule(:funcall => simple(:funcall),
         :args    => simple(:args))   { Vm::FuncallExpression.new(funcall.name, [args]) }

    rule(:funcall => simple(:funcall),
         :args    => sequence(:args)) { Vm::FuncallExpression.new(funcall.name, args) }

    rule(:cond     => simple(:cond),
         :if_true  => {:body => simple(:if_true)},
         :if_false => {:body => simple(:if_false)}) { Vm::ConditionalExpression.new(cond, if_true, if_false) }

    rule(:param  => simple(:param))    { param  }
    rule(:params => sequence(:params)) { params }

    rule(:func   => simple(:func),
         :params => simple(:name),
         :body   => simple(:body)) { Vm::FunctionExpression.new(func.name, [name], body) }

    rule(:func   => simple(:func),
         :params => sequence(:params),
         :body   => simple(:body)) { Vm::FunctionExpression.new(func.name, params, body) }
    
    #shortcut to get the ast tree for a given string
    # optional second arguement specifies a rule that will be parsed (mainly for testing)     
    def self.ast string , rule = :root
      syntax    = Parser.new.send(rule).parse(string)
      tree      = Transform.new.apply(syntax)
      tree
    end
  end
end
