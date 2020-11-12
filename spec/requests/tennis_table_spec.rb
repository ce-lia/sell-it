require 'rails_helper'

RSpec.describe "Tennis Table API", type: :request do
  describe '#ping' do
    context 'when unauthenticated' do

      before {get '/ping'}

      it 'works' do
        expect(response).to be_successful
      end

      it 'returns unauthorized pong'do
        expect(parsed_body['response']).to eq 'unauthorized pong'
      end
    end

    context 'when authenticated' do
      before {get '/ping', headers: authentication_header}

      it 'works' do
        expect(response).to be_successful
      end

      it 'resturns authorized pong'do
      expect(parsed_body['response']).to eq 'authorized pong'
      end
    end
  end
end
