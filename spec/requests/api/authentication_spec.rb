# spec/requests/api/authentication_spec.rb
require 'rails_helper'

RSpec.describe "Api::Authentication", type: :request do
  describe "POST /api/auth/register" do
    let(:valid_params) do
      {
        user: {
          username: 'tester',
          email: 'tester@mail.com',
          password: 'password123',
          first_name: 'Test',
          last_name: 'User'
        }
      }
    end

    it "registers a user and returns 201" do
      post "/api/auth/register", params: valid_params

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["data"]["username"]).to eq("tester")
    end

    it "returns error if username already taken" do
      create(:user, username: 'tester')
      post "/api/auth/register", params: valid_params

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "POST /api/auth/login" do
    let!(:user) { create(:user, username: 'reza', email: 'reza_dev@example.com', password: 'password123') }

    it "returns token when login is successful" do
      post "/api/auth/login", params: { email: 'reza_dev@example.com', password: 'password123' }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]["token"]).not_to be_nil
    end

    it "returns unauthorized for invalid credentials" do
      post "/api/auth/login", params: { email: 'reza_dev@example.com', password: 'wrong' }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
