# spec/services/asset_service_spec.rb
require 'rails_helper'

RSpec.describe AssetService, type: :service do
  let(:user) { create(:user) }
  let(:location) { create(:location) }
  let(:service) { AssetService.new }

  before do
    # Cleanup before testing
    Asset.destroy_all
    AssetLog.destroy_all
  end

  describe '#find_all_assets' do
    it 'returns all assets' do
      assets  = create_list(:asset, 3, location: location)

      assets = service.find_all_assets
      expect(assets).to match_array(assets)
    end

    it 'returns empty array when no assets exist' do
      Asset.destroy_all

      assets = service.find_all_assets
      expect(assets).to eq([])
    end
  end

  describe '#find_asset_by_id' do
    it 'returns the asset if found' do
      asset = create(:asset, location: location)

      found_asset = service.find_asset_by_id(asset.id)
      expect(found_asset).to eq(asset)
    end

    it 'raises error if the asset is not found' do
      expect {
        service.find_asset_by_id(-1)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create_asset' do
    let(:valid_params) do
      {
        name: "MacBook Pro M3",
        asset_code: "AST-999",
        acquisition_cost: 25_000_000,
        location_id: location.id
      }
    end

    it 'creates an asset and logs the creation' do
      expect {
        service.create_asset(valid_params, user.id)
      }.to change(Asset, :count).by(1).and change(AssetLog, :count).by(1)

      expect(AssetLog.last.action).to eq('created')
      expect(AssetLog.last.remarks).to include("AST-999")
    end

    it 'raises error when validation fails' do
      expect {
        service.create_asset(valid_params.merge(name: ""), user.id)
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect(Asset.count).to eq(0)
      expect(AssetLog.count).to eq(0)
    end
  end

  describe '#update_asset' do
    let!(:asset) { create(:asset, name: "Old Laptop", location: location) }

    it 'logs specifically which fields changed' do
      service.update_asset(asset, { name: "New Laptop" }, user.id)

      log = AssetLog.last
      expect(log.action).to eq('updated')
      expect(log.remarks).to include("Asset updated with changes: name: Old Laptop -> New Laptop")
    end

    it 'does not create a log if update fails (transaction rollback)' do
      AssetLog.create!(asset: asset, user: user, action: 'created', remarks: 'initial', location: location)

      initial_log_count = AssetLog.count

      expect {
        service.update_asset(asset, { asset_code: nil }, user.id)
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect(AssetLog.count).to eq(initial_log_count)

      expect(AssetLog.last.action).to eq('created')
    end
  end
end
