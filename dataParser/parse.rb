require 'data_mapper'
require './dataParser/model/vote.rb'

ENV['RACK_ENV'] ||= 'development'
class Parse
  attr_reader :data, :data_file_path, :non_well_formatted
# use ARGV later to load the file instead of constructor!!
  def initialize data_file_path
    @data_file_path = data_file_path
    @data = []
    @non_well_formatted = []
  end

  def prepare
    file_to_array @data_file_path
    # parse_data @data
  end




  def parse_data data
    data.each do |rows|
      rows.each do row
        vote = Vote.new(type: row[0], epoch: row[1], campaign: row[2], validity: row[3], choice: row[4], conn: row[5], msisdn: row[6],  guid: row[7], shortcode: row[8])

      end
    end

  end

  private

  def file_to_array (data_file_path)
    begin
      File.open(data_file_path, 'r') do |f|
        f.each_line do |line|
          line.encode!('UTF-8', :invalid => :replace, :undef => :replace, :replace => '').strip!
          if line_valid? line
            @data << line.split(' ')
          else
            @non_well_formatted << line
          end
        end
      end
      puts 'Data successfully loaded loaded to parser'
    rescue => err
      puts "Exception: #{err}"
      raise LoadError
      err
    end
  end


  def line_valid? line
    headers = ['VOTE', String, 'Campaign', 'Validity', 'Choice', 'CONN', 'MSISDN', 'GUID', 'Shortcode']
    data_row = line.split(' ')
    valid = true;
    data_row.each.with_index do |item, index|
      if index == 1
        item.scan(/\d+/).join == item ? true : valid = false
      else
        item.split(':')[0] == headers[index] ? true : valid = false
      end
    end
    valid
  end

end


DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres@localhost/votesDashBoard_#{ENV['RACK_ENV']}")
DataMapper.finalize
DataMapper.auto_upgrade!
