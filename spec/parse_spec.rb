require './dataParser/parse.rb'

describe Parse do
  before(:each) do
    @data_file_path = './dataParser/votes.txt'
    @parse = Parse.new(@data_file_path)
  end

  it 'accepts one argument' do
    expect(Parse).to receive(:new).with('./dataParser/votes.txt')
    @parse = Parse.new(@data_file_path)
  end

  it 'stores the file path' do
      expect(@parse.data_file_path).to eq @data_file_path
  end

  it 'has an empty data array by default' do
    expect(@parse.data).to eq []
  end

  it 'can open a file' do
    @parse.prepare
    expect { @parse.prepare }.not_to raise_error
  end

  it 'handles the encoding error by encoding it to UTF-8' do
    nonUTF_data_file_path = './dataParser/votes.txt'
    parse = Parse.new(nonUTF_data_file_path)
    expect { parse.prepare }.not_to raise_error
  end
  it "throws a 'LoadError' exeption if something can load the file" do
    wrong_data_file_path = './dataParser/tst.txt'
    parse = Parse.new(wrong_data_file_path)
    expect { parse.prepare }.to raise_error LoadError
  end

  it 'can validate the data rows during loading' do

  end

  it 'can store the files lines in the data array' do
    @parse.prepare
    expect(@parse.data.count).not_to eq 0
  end
end
