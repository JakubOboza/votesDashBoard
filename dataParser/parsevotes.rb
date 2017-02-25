require './dataParser/parse.rb'
require './dataParser/data_mapper_setup.rb'

if !ARGV.empty?
path = ARGV[0].strip
parse = Parse.new(path)
parse.prepare
else
  puts 'usage: ruby parsevotes <filepath> '
end
