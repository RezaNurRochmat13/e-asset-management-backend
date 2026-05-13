# spec/requests/api/asset/assets_spec.rb
require 'rails_helper'

RSpec.describe "Api::Assets", type: :request do
  let!(:user) { create(:user) }
  let!(:location) { create(:location) }
  let!(:asset) { create(:asset, location: location) }

  let(:token) { JwtUtil.encode(user_id: user.id) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET /api/assets" do
    it "returns list of assets with success status" do
      get "/api/assets", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["data"]).to be_an(Array)
      expect(json["data"].first["id"]).to eq(asset.id)
    end

    it "returns error when no assets found" do
      Asset.destroy_all

      get "/api/assets", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["data"]).to be_an(Array)
      expect(json["data"]).to be_empty
    end

    it "returns unauthorized when no auth header" do
      get "/api/assets"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/assets/:id" do
    it "returns asset with success status" do
      get "/api/assets/#{asset.id}", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["data"]["id"]).to eq(asset.id)
    end

    it "returns error when asset not found" do
      get "/api/assets/9999", headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it "returns unauthorized when no auth header" do
      get "/api/assets/#{asset.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /api/assets" do
    let(:params) do
      {
        asset: {
          name: "iPad Air",
          asset_code: "IPD-001",
          location_id: location.id,
          acquisition_cost: 10000000,
          useful_value: 3,
          buy_date: Date.current
        }
      }
    end

    it "creates asset and returns 201 created" do
      expect {
        post "/api/assets", params: params, headers: headers
      }.to change(Asset, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["data"]["name"]).to eq("iPad Air")
    end

    it "returns error when params are missing" do
      post "/api/assets", params: { asset: { name: "" } }, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(JSON.parse(response.body)["status"]).to eq("error")
    end

    it "returns unauthorized when no auth header" do
      post "/api/assets", params: params

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PUT /api/assets/:id" do
    let(:update_params) do
      {
        asset: {
          name: "Updated Asset Name"
        }
      }
    end

    it "updates asset and returns success status" do
      put "/api/assets/#{asset.id}", params: update_params, headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["data"]["name"]).to eq("Updated Asset Name")
    end

    it "returns error when asset not found" do
      put "/api/assets/9999", params: update_params, headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it "returns error when update params are invalid" do
      put "/api/assets/#{asset.id}", params: { asset: { name: "" } }, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("error")
    end

    it "returns unauthorized when no auth header" do
      put "/api/assets/#{asset.id}", params: update_params

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
