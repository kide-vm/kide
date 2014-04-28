module Parser
  module Keywords
    include Parslet
    rule(:keyword_if)   { str('if')   >> space? }
    rule(:keyword_else) { str('else') >> space? }
    rule(:keyword_def)  { str('def') >> space? }
    rule(:keyword_end)  { str('end') >> space? }  
  end
end