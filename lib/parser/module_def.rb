module Parser
  module ModuleDef
    include Parslet
    rule(:module_def) do
      keyword_module >> name >> eol >>
      ( (keyword_end.absent? >> root).repeat(1)).as(:module_expressions) >> keyword_end >> newline
    end
  end
end
