require 'rails_helper'

RSpec.describe "Classifieds", type: :request do

  describe 'GET :classifieds' do
    before {
      FactoryBot.create_list :classified, 3
      get '/classifieds'
    }

    it 'works' do
      expect(response).to be_successful
    end

    it 'returns all the entries' do
      expect(parsed_body.count).to eq Classified.all.count
    end
  end

  describe 'GET /classifieds/:id' do
    let(:classified) {FactoryBot.create :classified}
    before {get "/classifieds/#{classified.id}"}

    it 'works' do
      expect(response).to be_successful
    end

    it 'is correctly serialized' do
      expect(parsed_body['id']).to eq classified.id
      expect(parsed_body['title']).to eq classified.title
      expect(parsed_body['price']).to eq classified.price
      expect(parsed_body['description']).to eq classified.description
    end
  end

  describe 'POST /classifieds' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        post '/classifieds'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      let(:params) {
        {classified: {title: 'title', price: 62, description: 'description'} }
      }

      it 'works' do
        post '/classifieds', params: params, headers: authentication_header
        expect(response).to have_http_status :created
      end

      it 'create a new classified'do
      expect {
        post '/classifieds', params: params, headers: authentication_header
      }.to change {
        current_user.classifieds.count
      }.by 1
      end

      it 'has correct fileds values for the created classified' do
        post '/classifieds', params: params, headers: authentication_header
        created_classified = current_user.classifieds.last
        expect(created_classified.title).to eq 'title'
        expect(created_classified.price).to eq 62
        expect(created_classified.description).to eq 'description'
      end

      it 'returns a bad request when a parameter is missing' do
        params[:classified].delete(:price)
        post '/classifieds', params: params, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end

      it 'returns a bad request when a parameter has not the right format' do
        params[:classified][:price] = 'Soixante deux'
        post '/classifieds', params: params, headers: authentication_header
        puts parsed_body
        expect(response).to have_http_status :bad_request
      end

    end
  end
end
