module Parser
  module Keywords
    include Parslet
    rule(:keyword_if)   { str('if')   >> space? }
    rule(:keyword_else) { str('else') >> space? }
    rule(:keyword_def)  { str('def') >> space? }
    rule(:keyword_end)  { str('end') >> space? }  
    rule(:keyword_true) {   str('true').as(:true) >> space?}
    rule(:keyword_false){   str('false').as(:false) >> space?}
    rule(:keyword_nil)  {   str('null').as(:nil) >> space?}
    rule(:keyword_while)  {   str('while').as(:while) >> space?}
    rule(:keyword_do)  {   str('do').as(:do) >> space?}
    rule(:keyword_begin)  {   str('begin').as(:begin) >> space?}
  end
end