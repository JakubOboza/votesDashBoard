require 'data_mapper'
require 'dm-postgres-adapter'

require './dataParser/model/vote.rb'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres@localhost/votesDashBoard_#{ENV['RACK_ENV']}")
DataMapper.finalize
DataMapper.auto_upgrade!
