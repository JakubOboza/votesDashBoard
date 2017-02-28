require_relative 'config/application'
require 'data_mapper'
require './dataParser/parse.rb'
Rails.application.load_tasks

if ENV['RACK_ENV'] != 'production'
  task :auto_upgrade do
    DataMapper.auto_upgrade!
    puts 'Auto-upgrade complete (no data loss)'
  end

  task :auto_migrate do
    DataMapper.auto_migrate!
    puts 'Auto-migrate complete (data could have been lost)'
  end
end
