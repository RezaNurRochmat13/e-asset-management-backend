class User < ApplicationRecord
  has_secure_password

  has_many :assets, foreign_key: "current_holder_id"
  has_many :asset_logs

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save :set_full_name

  private

  def set_full_name
    self.full_name = "#{first_name} #{last_name}"
  end
end
