class Parse
  attr_reader :data, :data_file_path

  def initialize data_file_path
    @data_file_path = data_file_path
    @data = []
    @non_well_formatted = []
  end

  def prepare
    file_to_array @data_file_path
  end


  def parse_data data


  end

=begin
  rules:

  field check, order check



=end

  private

  def file_to_array (data_file_path)


    begin
      File.open(data_file_path, 'r') do |f|
        f.each_line do |line|
          line.encode!('UTF-8', :invalid => :replace, :undef => :replace, :replace => '')
          p line_valid? line
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
