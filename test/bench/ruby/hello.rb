
counter = 100000;
while(counter > 0) do
  puts "Hello there"
  # roughly 4 times slower with this, which is like rubyx
  #STDOUT.flush
  counter = counter - 1
end
