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
    parse_file_to_array @data_file_path
    store_in_db @data
    p @data
    # p @non_well_formatted
    print_message_for('summary')
  end

  private

  def store_in_db data
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
    end
  end

  def split_at_colon data
    data = data.scan(/[0-9a-zA-Z:+]/).join('')
    data.include?(':') ? data.split(':')[1] : data
  end

  def print_message_for purpose
    messages = {summary: "#{@data.count} records parsed and #{@non_well_formatted.count} discarded",
                loadSuccess: "Data successfully loaded to parser"}
    msg = messages[:"#{purpose}"]
    puts "#{msg}"
  end

  def parse_file_to_array (data_file_path)

    begin
      File.open(data_file_path, 'r') do |f|
        f.each_line do |line|
          replace_non_utf8_chars(line)
          line_valid?(line) ?  @data << line.split(' ') : @non_well_formatted << line
        end
      end
      print_message_for('loadSuccess')
      rescue => err
      puts "Exception: #{err}"
      raise LoadError
      err
    end
  end

  def replace_non_utf8_chars line
    line.encode!('UTF-8', :invalid => :replace, :undef => :replace, :replace => '').strip!
  end

  def line_valid? line
    valid = true;
    return false if empty_line? line
    data_row = line.split(' ')
    return false if row_length_incorrect?(data_row) || !headers_valid?(data_row)
    valid
  end
  def empty_line? line
    line == ""
  end
  def row_length_incorrect? data_row
    data_row.count != 9
  end
  def headers_valid? data_row
    headers = ['VOTE', String, 'Campaign', 'Validity', 'Choice', 'CONN', 'MSISDN', 'GUID', 'Shortcode']
    valid = true
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
