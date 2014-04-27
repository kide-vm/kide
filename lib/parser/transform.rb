require 'parslet'
require 'vm/nodes'

module Parser
  class Transform < Parslet::Transform
    rule(:integer => simple(:value)) { Vm::IntegerExpression.new(value.to_i) }
    rule(:name   => simple(:name))  { Vm::NameExpression.new(name.to_s) }

    rule(:argument  => simple(:argument))    { argument  }
    rule(:argument_list => sequence(:argument_list)) { argument_list }

    # need TWO transform rules, for one/many arguments (see the[] wrapping in the first)
    rule(:function_call => simple(:function_call),
          :argument_list    => simple(:argument))   do
            Vm::FuncallExpression.new(function_call.name, [argument]) 
          end
    rule( :function_call => simple(:function_call), 
          :argument_list    => sequence(:argument_list)) do
           Vm::FuncallExpression.new(function_call.name, argument_list) 
    end

    rule(:conditional     => simple(:conditional),
         :if_true  => {:block => simple(:if_true)},
         :if_false => {:block => simple(:if_false)}) { Vm::ConditionalExpression.new(conditional, if_true, if_false) }

    rule(:parmeter  => simple(:parmeter))    { parmeter  }
    rule(:parmeter_list => sequence(:parmeter_list)) { parmeter_list }

    # need TWO transform rules, for one/many arguments (see the[] wrapping in the first)
    rule(:function_definition   => simple(:function_definition),
         :parmeter_list => simple(:parmeter),
         :block   => simple(:block)) do
            Vm::FunctionExpression.new(function_definition.name, [parmeter], block) 
          end

    rule(:function_definition   => simple(:function_definition),
         :parmeter_list => sequence(:parmeter_list),
         :block   => simple(:block)) do
            Vm::FunctionExpression.new(function_definition.name, parmeter_list, block) 
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
