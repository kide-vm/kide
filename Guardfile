# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :minitest do
  # with Minitest::Unit
  watch(%r{^test/(.*)\/?test_(.*)\.rb$})
  watch(%r{^test/(.*/)?helper.rb$})     { |m| "test/#{m[1]}test_all.rb" }
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }

  #Arm instructions
  watch(%r{^lib/arm/instructions/(.+)_instruction.rb}) { |m| "test/arm/test_#{m[1]}.rb" }

  #parfait basics
  watch(%r{^lib/typed/parfait/(.+).rb}) { |m| "test/typed/parfait/test_#{m[1]}.rb" }
  watch(%r{^lib/typed/parfait/type.rb}) { |m| "test/typed/type/test_all.rb" }
  watch(%r{^lib/typed/parfait/typed_method.rb}) { |m| "test/typed/type/test_method_api.rb" }

  # Vool to_mom compile process +   # Ruby to vool compile process
  watch(%r{^lib/vool/statements/(.+)_statement.rb}) { |m| ["test/vool/to_mom/test_#{m[1]}.rb" ,"test/vool/statements/test_#{m[1]}.rb"] }

end
