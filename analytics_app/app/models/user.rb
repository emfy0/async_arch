class User < ApplicationRecord
  scope :non_management, -> { where.not(role: ['admin', 'manager']) }

  has_many :tasks, dependent: :destroy

  validates :username, presence: true, uniqueness: true
end
