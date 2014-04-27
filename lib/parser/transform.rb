require 'parslet'
require 'vm/nodes'

module Parser
  class Transform < Parslet::Transform
    rule(:integer => simple(:value)) { Vm::IntegerExpression.new(value.to_i) }
    rule(:name   => simple(:name))  { Vm::NameExpression.new(name.to_s) }

    rule(:argument  => simple(:argument))    { argument  }
    rule(:argument_list => sequence(:argument_list)) { argument_list }

    rule(:function_call => simple(:function_call), :argument_list    => sequence(:argument_list)) do
           Vm::FuncallExpression.new(function_call.name, argument_list) 
    end

    rule(:cond     => simple(:cond),
         :if_true  => {:block => simple(:if_true)},
         :if_false => {:block => simple(:if_false)}) { Vm::ConditionalExpression.new(cond, if_true, if_false) }

    rule(:param  => simple(:param))    { param  }
    rule(:params => sequence(:params)) { params }

    rule(:function_definition   => simple(:function_definition),
         :params => sequence(:params),
         :block   => simple(:block)) do
            Vm::FunctionExpression.new(function_definition.name, params, block) 
          end
    
    #shortcut to get the ast tree for a given string
    # optional second arguement specifies a rule that will be parsed (mainly for testing)     
    def self.ast string , rule = :root
      syntax    = Parser.new.send(rule).parse(string)
      tree      = Transform.new.apply(syntax)
      tree
    end
  end
end
