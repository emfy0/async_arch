class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :task
  belongs_to :billing_cycle

  has_one :payment, dependent: :destroy

  validates :kind, presence: true, inclusion: { in: %w[withdrawal enrollment compensation] }
end
