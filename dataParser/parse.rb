ENV['RACK_ENV'] ||= 'development'
require './dataParser/data_mapper_setup.rb'
require './dataParser/model/vote.rb'

class Parse
  attr_reader :data_to_db, :data_raw, :data_file_path, :non_well_formatted
  def initialize data_file_path
    @data_file_path = data_file_path
    @data_raw = []
    @data_to_db = []
    @non_well_formatted = []
  end

  def prepare
    parse_file_to_array @data_file_path
    store_in_db @data_to_db
    print_message_for('summary')
  end

  private

  def store_in_db data
    data.each.with_index do |row, index|
      vote = Vote.create(vote: (row[0]),
      epoch: (row[1]),
      campaign: (row[2]),
      validity: (row[3]),
      choice: (row[4]),
      conn: (row[5]),
      msisdn: (row[6]),
      guid: (row[7]),
      shortcode: (row[8]))
    end
  end

  def split_at_colon data
    data.each.with_index do |row|
      row = row.map.with_index do |item, index|
        item = item.scan(/[0-9a-zA-Z:+]/).join('')
        item.include?(':') ? item.split(':')[1] : item
      end
      @data_to_db << row
    end
  end


  def print_message_for purpose
    messages = {summary: "#{@data_to_db.count} records parsed and #{@non_well_formatted.count} discarded",
                loadSuccess: "Data successfully loaded to parser"}
    msg = messages[:"#{purpose}"]
    puts "#{msg}"
  end

  def parse_file_to_array (data_file_path)

    begin
      File.open(data_file_path, 'r') do |f|
        f.each_line do |line|
          replace_non_utf8_chars(line)
          line_valid?(line) ?  @data_raw << line.split(' ') : @non_well_formatted << line
        end
      end
      split_at_colon(@data_raw)
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
