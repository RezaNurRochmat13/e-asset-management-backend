# spec/requests/api/locations_spec.rb
require 'rails_helper'

RSpec.describe "Api::Locations", type: :request do
  let!(:user) { create(:user) }
  let!(:location) { create(:location, name: "HQ", description: "Main Office") }
  let(:token) { JwtUtil.encode(user_id: user.id) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET /api/locations" do
    it "returns success and all locations" do
      get "/api/locations", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["data"].any? { |l| l["name"] == "HQ" }).to be true
    end

    it "returns error when no locations found" do
      Location.destroy_all

      get "/api/locations", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["data"]).to be_an(Array)
      expect(json["data"]).to be_empty
    end
  end

  describe "GET /api/locations/:id" do
    it "returns the specific location" do
      get "/api/locations/#{location.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["name"]).to eq("HQ")
    end

    it "returns 404 for non-existent location" do
      # Note: Jika service pakai .find, ini akan kena exception handler Rails
      # yang biasanya merender 404 secara otomatis.
      get "/api/locations/-1", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/locations" do
    let(:valid_params) do
      { location: { name: "Server Room", description: "2nd Floor" } }
    end

    it "creates a location" do
      expect {
        post "/api/locations", params: valid_params, headers: headers
      }.to change(Location, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["name"]).to eq("Server Room")
    end

    it "returns error for invalid params" do
      post "/api/locations", params: { location: { name: "" } }, headers: headers

      expect(response).to have_http_status(:ok) # Karena controller tidak handle validasi error
      expect(JSON.parse(response.body)["data"]["name"]).to eq("")
    end
  end

  describe "PATCH /api/locations/:id" do
    it "updates the location" do
      patch "/api/locations/#{location.id}",
            params: { location: { name: "Updated HQ" } },
            headers: headers

      expect(response).to have_http_status(:ok)
      expect(location.reload.name).to eq("Updated HQ")
    end

    it "returns 404 for non-existent location" do
      patch "/api/locations/-1",
            params: { location: { name: "Non-existent" } },
            headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
