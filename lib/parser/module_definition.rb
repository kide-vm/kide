module Parser
  module ModuleDef
    include Parslet
    rule(:module_definition) do
      keyword_module >> module_name >> eol >>
      ( (keyword_end.absent? >> root_body).repeat()).as(:module_expressions) >> keyword_end >> newline
    end

    rule(:class_definition) do
      keyword_class >> module_name >> eol >>
      ( (keyword_end.absent? >> root_body).repeat()).as(:class_expressions) >> keyword_end >> newline
    end

  end
end
