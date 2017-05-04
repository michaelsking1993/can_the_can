=begin
f = File.new("./my_file.txt", "w")
f.puts("Hey this is a line")
f.puts("go fuck yourself")
f.close


lines = ["base word", 'another one', 'hello']

f = File.new("./my_file.txt", "w")
lines.each { |line| f.puts(line) }
f.close

=end
begin
  lines = []
  file = File.open("./my_filef.txt", "r")

  while (line = file.gets) #works for nil case
    lines << line
  end
rescue => e
  puts e
end



file.close

lines.each { |l| puts l }