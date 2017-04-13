Dir["**/test_*.rb"].each { |f|
  next if f.include?("stash/")
  require_relative "../#{f}"
}
