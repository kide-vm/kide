module Parser
  module Keywords
    include Parslet
    
    rule(:keyword_begin)  {  str('begin').as(:begin) >> space?}
    rule(:keyword_class)  {  str('class') >> space? }
    rule(:keyword_def)    {  str('def') >> space? }
    rule(:keyword_do)     {  str('do').as(:do) >> space?}
    rule(:keyword_else)   {  str('else').as(:else) >> space? }
    rule(:keyword_end)    {  str('end').as(:end) >> space? }  
    rule(:keyword_false)  {  str('false').as(:false) >> space?}
    rule(:keyword_if)     {  str('if').as(:if)   >> space? }
    rule(:keyword_rescue) {  str('rescue').as(:rescue) >> space?}
    rule(:keyword_return) {  str('return').as(:return) >> space?}
    rule(:keyword_true)   {  str('true').as(:true) >> space?}
    rule(:keyword_module) {  str('module') >> space? }
    rule(:keyword_nil)    {  str('nil').as(:nil) >> space?}
    rule(:keyword_unless) {  str('unless').as(:unless) >> space?}
    rule(:keyword_until)  {  str('until').as(:until) >> space?}
    rule(:keyword_while)  {  str('while').as(:while) >> space?}
    
    # this rule is just to make sure identifiers can't be keywords. Kind of duplication here, but we need the 
    # space in above rules, so just make sure to add any here too.
    rule(:keyword){ str('begin') | str('def') | str('do') | str('else') | str('end') | 
                    str('false')| str('if')| str('rescue')| str('true')| str('nil') |
                    str('unless')| str('until')| str('while')}
  end
end