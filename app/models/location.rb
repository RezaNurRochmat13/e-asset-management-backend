class Location < ApplicationRecord
  has_many :assets
  has_many :asset_logs

  validates :name, presence: true
end
