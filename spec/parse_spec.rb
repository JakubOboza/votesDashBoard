require './dataParser/parse.rb'

describe Parse do
  before(:each) do
    @data_file = 'votes.txt'
    @parse = Parse.new(@data_file)
  end
  it 'accepts one argument' do
    expect(Parse).to receive(:new).with('votes.txt')
    @parse = Parse.new(@data_file)
  end
  it 'has an empty data array by default' do
    expect(@parse.data).to eq []
  end
  it 'parses a line i' do

  end
end
