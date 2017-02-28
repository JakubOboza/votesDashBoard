require './dataParser/parse.rb'
require './dataParser/model/vote.rb'
require "spec_helper"
describe Parse do
  before(:each) do
    @data_file_path = './dataParser/test.txt'
    @parse = Parse.new(@data_file_path)
  end
  context 'at inialization' do
    before(:each) do
    end
    it 'accepts one argument' do
      expect(Parse).to receive(:new).with('./dataParser/test.txt')
      @parse = Parse.new(@data_file_path)
    end

    it 'stores the file path' do
      expect(@parse.data_file_path).to eq @data_file_path
    end

    it 'has an empty data array by default' do
      expect(@parse.data_raw).to eq []
    end
  end

  context '#parse_file_to_array ' do
    it 'can open a file' do
      expect { @parse.start }.not_to raise_error
    end
  end

  context '#parse_file_to_array' do
    before(:each) do
      @parse.start
    end

    it 'handles the encoding error by encoding it to UTF-8' do
      nonUTF_data_file_path = './dataParser/test.txt'
      parse = Parse.new(nonUTF_data_file_path)
      expect { parse.start }.not_to raise_error
    end
    it "throws a 'LoadError' exeption if can't load the file" do
      wrong_data_file_path = './dataParser/tst.txt'
      parse = Parse.new(wrong_data_file_path)
      expect { parse.start }.to raise_error LoadError
    end

    it 'can discard non well-formatted data rows during loading' do
      expect(@parse.non_well_formatted.empty?).to be false
    end

    it "headers_valid? checks the rows for valid headers except for epoch column" do
      headers = @parse.data_raw.first.map.with_index do |item, index|
        next if index == 1
        item.split(':')[0]
      end
      expect(headers).to contain_exactly('VOTE', nil, 'Campaign', 'Validity', 'Choice', 'CONN', 'MSISDN', 'GUID', 'Shortcode')
    end

    it "#headers_valid checks that the epoch column items contains only numbers " do
      valid_epoch_times = @parse.data_raw.map { |row| row[1]  }
      expect(valid_epoch_times).not_to include('1168aaa041837')
      expect(@parse.non_well_formatted.flatten(1)).to include ('1168aaa041837')
    end

    it 'can store the files lines in the data array' do
      expect(@parse.data_to_db.count).not_to eq 0
    end

    it "every lines first value is 'VOTE'" do
       first_elements = @parse.data_to_db.map { |row| row.first }
      expect(first_elements).to all(be_a(String).and include('VOTE'))
    end

    it "#split_at_colon keeps only the value in the columns (removes key and colon)" do
      flattened_array = @parse.data_to_db.flatten(1)
      expect(flattened_array).not_to include(':', 'Campaign', 'Validity', 'Choice', 'CONN', 'MSISDN', 'GUID', 'Shortcode')
    end

    it "discards empty lines" do
      @parse.data_to_db.flatten(1)
      expect(@parse.data_to_db.flatten).not_to include(""," ")
    end
    it "all rows have to be 9 columns long" do
      col_lengths = @parse.data_to_db.map { |row| row.count  }
      expect(col_lengths).to all(be < 10).and all(be > 8)
    end
    it '#store_in_db can store data in database' do
      expect(Vote.count).to eq @parse.data_to_db.count
    end
  end

end
