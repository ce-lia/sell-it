require 'rails_helper'

RSpec.describe "Classifieds", type: :request do
  let(:classified) {FactoryBot.create :classified, user_id: current_user.id}

  describe 'GET :classifieds' do
    context 'when everything is going well' do
      let(:page) {3}
      let(:per_page) {5}
      before {
        FactoryBot.create_list :classified, 18
        get '/v2/classifieds', params: { page: page, per_page: per_page}
      }

      it 'works' do
        expect(response).to have_http_status :partial_content
      end

      it 'returns paginated results' do
        expect(parsed_body.map { |c| c['id'] }).to eq Classified.all.limit(per_page).offset((page - 1) * per_page).pluck(:id)
      end
    end

    it 'returns a bad request when paramaters are missing' do
      get '/v2/classifieds'
      expect(response).to have_http_status :bad_request
      expect(parsed_body.keys).to include 'error'
      expect(parsed_body['error']).to eq 'missing parameters'
    end
  end

  describe 'GET /classifieds/:id' do
    context 'when everything goes well'do
      before {get "/v2/classifieds/#{classified.id}"}

      it 'works' do
        expect(response).to be_successful
      end

      it 'is correctly serialized' do
        expect(parsed_body).to match({
          id: classified.id,
          title: classified.title,
          price: classified.price,
          description: classified.description,
          user: {
            id: classified.user_id,
            fullname: classified.user.fullname
          }.stringify_keys
        }.stringify_keys)
      end
    end

    it 'returns a not found when the resources can not be found' do
      get '/v2/classifieds/toto'
      expect(response).to have_http_status :not_found
    end
  end

  describe 'POST /classifieds' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        post '/v2/classifieds'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      let(:params) {
        {classified: {title: 'title', price: 62, description: 'description'} }
      }

      it 'works' do
        post '/v2/classifieds', params: params, headers: authentication_header
        expect(response).to have_http_status :created
      end

      it 'create a new classified'do
      expect {
        post '/v2/classifieds', params: params, headers: authentication_header
      }.to change {
        current_user.classifieds.count
      }.by 1
      end

      it 'has correct fileds values for the created classified' do
        post '/v2/classifieds', params: params, headers: authentication_header
        created_classified = current_user.classifieds.last
        expect(created_classified.title).to eq 'title'
        expect(created_classified.price).to eq 62
        expect(created_classified.description).to eq 'description'
      end

      it 'returns a bad request when a parameter is missing' do
        params[:classified].delete(:price)
        post '/v2/classifieds', params: params, headers: authentication_header
        expect(response).to have_http_status :bad_request
      end

      it 'returns a bad request when a parameter has not the right format' do
        params[:classified][:price] = 'Soixante deux'
        post '/v2/classifieds', params: params, headers: authentication_header
        puts parsed_body
        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe 'PATCH /classifieds/:id' do
    let(:params) {
       {classified: {title: 'Better Title', price: 48} }
    }
    context 'when unauthenticated' do
      it 'returns aunauthorized' do
        patch "/v2/classifieds/#{classified.id}"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
        before { patch "/v2/classifieds/#{classified.id}", params: params, headers: authentication_header }

        it { expect(response).to have_http_status :forbidden }
    end
  end

  describe 'DELETE /classifieds/:id' do
    context 'when unauthenticated' do
      it 'return unauthorized' do
        delete "/v2/classifieds/#{classified.id}"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      context 'when everything goes well' do
        before {delete "/v2/classifieds/#{classified.id}", headers: authentication_header }

        it { expect(response).to have_http_status :no_content }

        it 'deletes the given classified' do
          expect(Classified.find_by(id: classified.id)).to eq nil
        end
      end

      it 'returns a not found when resources can not be found' do
        delete '/v2/classifieds/toto', headers: authentication_header
        expect(response).to have_http_status :not_found
      end

      it 'returns a forbidden when the requester is not the owner of the resources' do
        another_classified = FactoryBot.create :classified
        delete "/v2/classifieds/#{another_classified.id}", headers: authentication_header
        expect(response).to have_http_status :forbidden
      end
    end
  end
end