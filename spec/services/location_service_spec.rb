# spec/services/location_service_spec.rb
require 'rails_helper'

RSpec.describe LocationService, type: :service do
  let(:service) { LocationService.new }
  let!(:location) { create(:location, name: "Gudang Pusat") }

  describe '#find_all_locations' do
    it 'returns all locations' do
      expect(service.find_all_locations).to include(location)
    end
  end

  describe '#find_location_by_id' do
    it 'returns the correct location' do
      expect(service.find_location_by_id(location.id)).to eq(location)
    end

    it 'raises error if location not found' do
      expect { service.find_location_by_id(-1) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create_location' do
    it 'creates a new location' do
      params = { name: "Kantor Cabang", description: "Jalan Sudirman" }
      expect { service.create_location(params) }.to change(Location, :count).by(1)
    end
  end

  describe '#update_location' do
    it 'updates the location attributes' do
      updated_location = service.update_location(location.id, { name: "Gudang Baru" })
      expect(updated_location.name).to eq("Gudang Baru")
    end
  end
end
