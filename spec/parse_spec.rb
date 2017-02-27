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
      expect(@parse.data).to eq []
    end
  end

  context ' when file passed in ' do
    it 'can open a file' do
      expect { @parse.prepare }.not_to raise_error
    end
  end

  context 'prepare' do
    before(:each) do
      @parse.prepare
    end

    it 'handles the encoding error by encoding it to UTF-8' do
      print ()
      nonUTF_data_file_path = './dataParser/test.txt'
      parse = Parse.new(nonUTF_data_file_path)
      expect { parse.prepare }.not_to raise_error
    end
    it "throws a 'LoadError' exeption if something can load the file" do
      wrong_data_file_path = './dataParser/tst.txt'
      parse = Parse.new(wrong_data_file_path)
      expect { parse.prepare }.to raise_error LoadError
    end

    it 'can validate the data rows during loading' do
      expect(@parse.non_well_formatted.empty?).to be false
    end

    it 'can store the files lines in the data array' do
      expect(@parse.data.count).not_to eq 0
    end

    it 'can store data in database' do
      p Vote.all
      expect(Vote.count).to eq @parse.data.count
    end
  end

end
