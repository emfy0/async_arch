class User < ApplicationRecord
  has_secure_password

  ROLES = %w[admin user manager].freeze

  has_many :sessions, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ROLES }
end
