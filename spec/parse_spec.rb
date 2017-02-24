require './dataParser/parse.rb'

describe Parse do
  it 'accepts one argument' do
    data_file = 'votes.txt'
    expect(Parse).to receive(:new).with('votes.txt')
    parse = Parse.new(data_file)
  end
end
