class Session < ApplicationRecord
  belongs_to :user

  validates :token, presence: true, uniqueness: true

  def active? = valid_until > Time.current
end
