module CodeChecker
  def check
    Virtual.machine.boot.parse_and_compile @string_input
    produced = Virtual.machine.space.get_main.source
    assert @output , "No output given"
    assert_equal @output.length ,  produced.blocks.length , "Block length"
    produced.blocks.each_with_index do |b,i|
      codes = @output[i]
      assert codes , "No codes for block #{i}"
      assert_equal b.codes.length , codes.length , "Code length for block #{i}"
      b.codes.each_with_index do |c , ii |
        assert_equal codes[ii] ,  c.class ,  "Block #{i} , code #{ii}"
      end
    end
  end
end
