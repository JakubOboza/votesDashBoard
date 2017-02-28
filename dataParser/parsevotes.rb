require './dataParser/parse.rb'
require './dataParser/data_mapper_setup.rb'

if !ARGV.empty?
path = ARGV[0].strip
parse = Parse.new(path)
parse.start
else
  info_msg = "This application is a data parser for the Votes Dashboard application. \nIt populates the connected database with the data provided as a space separated value log file. \n\n usage: ruby parsevotes.rb <filepath>\n\n"
  puts info_msg
end
