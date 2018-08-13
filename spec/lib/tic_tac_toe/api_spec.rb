require 'spec_helper'
require 'tic_tac_toe/server/api'

describe TicTacToe::Server::API do
  include Rack::Test::Methods

  def app
    described_class
  end

  context 'GET /api/statuses' do
    before { get '/api/statuses' }

    subject { JSON.parse(last_response.body) }

    it 'is a valid response' do
      expect(last_response.status).to eq(200)
    end

    it 'returns an array of five elements' do
      expect(subject).to be_kind_of(Array)
      expect(subject.count).to eq 5
    end

    it 'the array contains hashes' do
      expect(subject.all?{|t| t.is_a?(Hash)}).to be_truthy
    end

    it 'the elements match the expected hash' do
      expect(subject[0]["id"]).to eq(1)
      expect(subject[0]["sent_at"]).to eq("2017-02-13T22:13:53Z")
      expect(subject[1]["id"]).to eq(2)
      expect(subject[1]["sent_at"]).to eq("2017-02-13T22:14:53Z")
    end
  end

  context 'GET /api/statuses/random' do
    before { get '/api/statuses/random' }

    context 'returns a single hash' do
      subject { JSON.parse(last_response.body) }

      it 'is a valid response' do
        expect(last_response.status).to eq(200)
      end

      it 'returns an hash' do
        expect(subject).to be_kind_of(Hash)
      end

      it 'the elements match the expected hash' do
        expect(subject["id"]).not_to be_nil
        expect(subject["sent_at"]).not_to be_nil
      end
    end
  end

  context 'GET /api/statuses/1' do
    before { get '/api/statuses/1' }

    context 'returns a single hash' do
      subject { JSON.parse(last_response.body) }

      it 'is a valid response' do
        expect(last_response.status).to eq(200)
      end

      it 'returns an hash' do
        expect(subject).to be_kind_of(Hash)
      end

      it 'the elements match the expected hash' do
        expect(subject["id"]).to eq 1
        expect(subject["sent_at"]).to eq("2017-02-13T22:13:53Z")
      end
    end
  end

  context 'POST /api/statuses' do
    before do
      status = { id: status_id, sent_at: Time.now.utc.iso8601 }
      post '/api/statuses', status.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    context 'with a valid, unseen ID' do
      subject { JSON.parse(last_response.body) }

      let(:status_id) { 234123315 }

      it 'creation is successful' do
        expect(last_response.status).to eq(201)
      end
    end

    context 'with an existing ID' do
      subject { JSON.parse(last_response.body) }

      let(:status_id) { 2 }

      it 'creation is unsuccessful' do
        expect(last_response.status).to eq(409)
      end
    end
  end

  context 'PUT /api/statuses/8' do
    before do
      status = { id: status_id, sent_at: Time.now.utc.iso8601 }
      put "/api/statuses/#{status_id}", status.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    context 'with a valid, unseen ID' do
      subject { JSON.parse(last_response.body) }

      let(:status_id) { 8 }

      it 'creation is successful' do
        expect(last_response.status).to eq(201)
      end
    end

    context 'with an existing ID' do
      subject { JSON.parse(last_response.body) }

      let(:status_id) { 2 }

      it 'replacement is successful' do
        expect(last_response.status).to eq(204)
      end
    end
  end
end
