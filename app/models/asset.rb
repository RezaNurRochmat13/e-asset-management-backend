class Asset < ApplicationRecord
  belongs_to :location
  belongs_to :current_holder, class_name: "User", optional: true
  has_many :asset_logs, dependent: :destroy

  validates :name, :asset_code, presence: true
  validates :asset_code, uniqueness: true

  private

  def depreciation_value
    return acquisition_cost if useful_value.to_i <= 0 || buy_date.nil?

    total_months = useful_value * 12
    months_passed = ((Date.current.year * 12 + Date.current.month) - (buy_date.year * 12 + buy_date.month))

    return salvage_value if months_passed >= total_months

    return acquisition_cost if months_passed <= 0

    monthly_depreciation = (acquisition_cost - salvage_value) / total_months
    (acquisition_cost - (monthly_depreciation * months_passed)).round(2)
  end
end
