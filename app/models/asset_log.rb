class AssetLog < ApplicationRecord
  belongs_to :asset
  belongs_to :user
  belongs_to :location, optional: true

  validates :action, presence: true

  def self.log_action(asset, user, action, location = nil, remarks = nil)
    create!(asset: asset, user: user, action: action, location: location, remarks: remarks)
  end
end
