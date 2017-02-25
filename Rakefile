# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

# require_relative 'config/application'
require 'data_mapper'
require './dataParser/parse.rb'
# require 'rspec'
# Rails.application.load_tasks

if ENV['RACK_ENV'] != 'production'

  # require 'rspec/core/rake_task'

  # RSpec::Core::RakeTask.new :spec
  #
  # task default: [:spec]

  task :auto_upgrade do
    DataMapper.auto_upgrade!
    puts 'Auto-upgrade complete (no data loss)'
  end

  task :auto_migrate do
    DataMapper.auto_migrate!
    puts 'Auto-migrate complete (data could have been lost)'
  end
end
