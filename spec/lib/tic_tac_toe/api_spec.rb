require 'spec_helper'
require 'tic_tac_toe/server/api'

describe TicTacToe::Server::API do
  include Rack::Test::Methods

  def app
    described_class
  end

  subject { JSON.parse(last_response.body,:symbolize_names => true) }

  context 'GET /game?id=1' do
    before { get '/game?id=1' }

    it 'is a valid response' do
      expect(last_response.status).to eq(200)
    end

    it 'returns an hash' do
      expect(subject).to be_kind_of(Hash)
    end

    it 'has an id of 1' do
      expect(subject[:id]).to eq(1)
    end
  end

  context 'POST /game' do
    before { post '/game' }

    it "returns a 'created' response" do
      expect(last_response.status).to eq(201)
    end

    it 'returns an hash' do
      expect(subject).to be_kind_of(Hash)
    end

    it 'has an id of greater than 1' do
      expect(subject[:id]).to be > 1
    end

    it "starts with X's turn" do
      expect(subject[:turn]).to eq("X")
    end
  end

  context 'POST /move' do
    before do
      move = { id: id, subgame: subgame, cell: cell }
      post '/move', move.to_json, 'CONTENT_TYPE' => 'application/json'
    end
    let(:game) do
      post '/game'
      JSON.parse(last_response.body,:symbolize_names => true)
    end
    let(:id)      { game[:id] }
    let(:subgame) { 3 }
    let(:cell)    { 8 }

    it 'is a valid response' do
      expect(last_response.status).to eq(200)
    end

    it 'has the correct game id' do
      expect(subject[:id]).to eq(game[:id])
    end

    it "is now Y's turn" do
      expect(subject[:turn]).to eq("Y")
    end

    it "now only allows '8' as the subgame" do
      expect(subject[:valid_subgames]).to eq([8])
    end
  end
end
