# frozen_string_literal: true

class AssetService
  def find_all_assets
    Asset.includes(:location, :asset_logs).all
  end

  def find_asset_by_id(id)
    Asset.includes(:location, :asset_logs).find(id)
  end

  def create_asset(params, user_id)
    ActiveRecord::Base.transaction do
      asset = Asset.create!(params)

      AssetLog.log_action(asset, User.find(user_id), "created", asset.location, "Asset created with code #{asset.asset_code}")

      asset
    end
  end

  def update_asset(asset, params, user_id)
    ActiveRecord::Base.transaction do
      asset.update!(params)

      changes = asset.saved_changes.except(:updated_at).map { |field, values| "#{field}: #{values[0]} -> #{values[1]}" }.join(", ")
      log_remarks = "Asset updated with changes: #{changes}"

      AssetLog.log_action(asset, User.find(user_id), "updated", asset.location, log_remarks)

      asset
    end
  end
end
