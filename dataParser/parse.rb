ENV['RACK_ENV'] ||= 'development'
require './dataParser/data_mapper_setup.rb'
require './dataParser/model/vote.rb'

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
    parse_data @data
  end

  private

  def parse_data data
    total = data.count
    data.each.with_index do |rows, index|
      vote = Vote.create(vote: split_at_colon(rows[0]),
      epoch: split_at_colon(rows[1]),
      campaign: split_at_colon(rows[2]),
      validity: split_at_colon(rows[3]),
      choice: split_at_colon(rows[4]),
      conn: split_at_colon(rows[5]),
      msisdn: split_at_colon(rows[6]),
      guid: split_at_colon(rows[7]),
      shortcode: split_at_colon(rows[8]))
      if (index % (total/20.0)) == 0
        print '.'
      end
    end
    print " #{total} records parsed and #{@non_well_formatted.count} discarded"
  end

  def split_at_colon data
    data = data.scan(/[0-9a-zA-Z:+]/).join('')
    data.include?(':') ? data.split(':')[1] : data
  end


  def file_to_array (data_file_path)

    begin
      File.open(data_file_path, 'r') do |f|
        f.each_line do |line|
          line.encode!('UTF-8', :invalid => :replace, :undef => :replace, :replace => '').strip!
          if line_valid? line
            @data << line.split(' ')
            print @data
          else
            @non_well_formatted << line
            # p @non_well_formatted
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
    if line == ""
      return
    end
    headers = ['VOTE', String, 'Campaign', 'Validity', 'Choice', 'CONN', 'MSISDN', 'GUID', 'Shortcode']
    data_row = line.split(' ')
    valid = true;
    if data_row.count != 9
      valid = false
    end
    data_row.each.with_index do |item, index|
      if index == 1
        item.scan(/\d+/).join == item ? true : valid = false
      elsif index > 1 && item.split(':')[1]
        item.split(':')[0] == headers[index] ? true : valid = false
      elsif index < 2
        item.split(':')[0] == headers[index] ? true : valid = false
      else
        valid = false
      end
    end
    valid
  end

end
