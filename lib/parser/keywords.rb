module Parser
  module Keywords
    include Parslet
    rule(:keyword_begin)  {  str('begin').as(:begin) >> space?}
    rule(:keyword_def)    {  str('def') >> space? }
    rule(:keyword_do)     {  str('do').as(:do) >> space?}
    rule(:keyword_else)   {  str('else').as(:else) >> space? }
    rule(:keyword_end)    {  str('end').as(:end) >> space? }  
    rule(:keyword_false)  {  str('false').as(:false) >> space?}
    rule(:keyword_if)     {  str('if').as(:if)   >> space? }
    rule(:keyword_rescue) {  str('rescue').as(:rescue) >> space?}
    rule(:keyword_true)   {  str('true').as(:true) >> space?}
    rule(:keyword_nil)    {  str('nil').as(:nil) >> space?}
    rule(:keyword_unless) {  str('unless').as(:unless) >> space?}
    rule(:keyword_until)  {  str('until').as(:until) >> space?}
    rule(:keyword_while)  {  str('while').as(:while) >> space?}
  end
end