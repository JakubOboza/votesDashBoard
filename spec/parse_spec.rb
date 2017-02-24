require './dataParser/parse.rb'
require "spec_helper"
describe Parse do
  before(:each) do
    @data_file_path = './dataParser/votes.txt'
    @parse = Parse.new(@data_file_path)
  end

  xit 'accepts one argument' do
    expect(Parse).to receive(:new).with('./dataParser/votes.txt')
    @parse = Parse.new(@data_file_path)
  end

  xit 'stores the file path' do
      expect(@parse.data_file_path).to eq @data_file_path
  end

  xit 'has an empty data array by default' do
    expect(@parse.data).to eq []
  end

  xit 'can open a file' do
    @parse.prepare
    expect { @parse.prepare }.not_to raise_error
  end

  xit 'handles the encoding error by encoding it to UTF-8' do
    nonUTF_data_file_path = './dataParser/votes.txt'
    parse = Parse.new(nonUTF_data_file_path)
    expect { parse.prepare }.not_to raise_error
  end
  xit "throws a 'LoadError' exeption if something can load the file" do
    wrong_data_file_path = './dataParser/tst.txt'
    parse = Parse.new(wrong_data_file_path)
    expect { parse.prepare }.to raise_error LoadError
  end

  xit 'can validate the data rows during loading' do
    faulty_file_path = './dataParser/votes.txt'
    parse = Parse.new(faulty_file_path)
    parse.prepare
    p parse.non_well_formatted
    expect(parse.non_well_formatted.empty?).to be false
  end

  xit 'can store the files lines in the data array' do

    expect(@parse.data.count).not_to eq 0
  end

  it 'can store data in database' do
    @parse.prepare
    row = @parse.data[0]
    p row
    Vote.create(type: row[0], epoch: row[1], campaign: row[2], validity: row[3], choice: row[4], conn: row[5], msisdn: row[6],  guid: row[7], shortcode: row[8])
    id = 1;
    a_vote = Vote.findAll
    p 'hello'
    p a_vote
  end

end
