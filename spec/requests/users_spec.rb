require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'GET /users/:id'do
    before { get "/users/#{current_user.id}", headers: authentication_header}

    it {expect(response).to be_successful}

    it 'is correctly serialized' do
      expect(parsed_body).to match({
        id: current_user.id,
        fullname: current_user.fullname,
        username: current_user.username
      }.stringify_keys)
    end
  end
end
